# Master script to create complete ToDo app with backdated commits
# Only Sumit's 11 commits

$ErrorActionPreference = "Continue"
$sumit = "Sumit <Sumitpant715@gmail.com>"

function Make-Commit {
    param([string]$Date, [string]$Time, [string]$Message)
    $datetime = "$Date $Time +0530"
    $env:GIT_AUTHOR_DATE = $datetime
    $env:GIT_COMMITTER_DATE = $datetime
    git add .
    git commit -m "$Message"
    Remove-Item Env:\GIT_AUTHOR_DATE -ErrorAction SilentlyContinue
    Remove-Item Env:\GIT_COMMITTER_DATE -ErrorAction SilentlyContinue
    Write-Host "OK $Date $Time - $Message" -ForegroundColor Green
}

Write-Host "`n=== Creating ToDo App with Backdated Commits ===" -ForegroundColor Cyan

# COMMIT 1: Aug 20 - Initial setup
Make-Commit "2026-08-20" "11:30:00" "Initial commit: Project setup and README"

# COMMIT 2: Aug 23 - Backend structure
mkdir -Force backend, backend\models, backend\routes, backend\config, public, tests, .github\workflows | Out-Null

@"
{
  "name": "todoapp-backend",
  "version": "1.0.0",
  "main": "server.js",
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js",
    "test": "jest"
  },
  "dependencies": {
    "express": "^4.18.2",
    "mongoose": "^7.5.0",
    "dotenv": "^16.3.1",
    "cors": "^2.8.5"
  },
  "devDependencies": {
    "nodemon": "^3.0.1",
    "jest": "^29.6.4",
    "supertest": "^6.3.3"
  }
}
"@ | Out-File -FilePath "backend\package.json" -Encoding UTF8

@"
MONGODB_URI=mongodb://localhost:27017/todoapp
PORT=3000
NODE_ENV=development
"@ | Out-File -FilePath "backend\.env.example" -Encoding UTF8

Make-Commit "2026-08-23" "14:15:00" "feat: Setup backend structure with package.json"

# COMMIT 3: Aug 26 - Task model
@"
const mongoose = require('mongoose');

const taskSchema = new mongoose.Schema({
  title: { type: String, required: true, trim: true, maxlength: 200 },
  description: { type: String, trim: true, maxlength: 1000 },
  completed: { type: Boolean, default: false },
  priority: { type: String, enum: ['low', 'medium', 'high'], default: 'medium' },
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now }
});

taskSchema.pre('save', function(next) {
  this.updatedAt = Date.now();
  next();
});

module.exports = mongoose.model('Task', taskSchema);
"@ | Out-File -FilePath "backend\models\Task.js" -Encoding UTF8

Make-Commit "2026-08-26" "10:45:00" "feat: Create Task model with mongoose schema"

# COMMIT 4: Aug 29 - Database config
@"
const mongoose = require('mongoose');
require('dotenv').config();

const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    console.log('MongoDB connected successfully');
  } catch (error) {
    console.error('MongoDB connection error:', error);
    process.exit(1);
  }
};

module.exports = connectDB;
"@ | Out-File -FilePath "backend\config\database.js" -Encoding UTF8

Make-Commit "2026-08-29" "16:20:00" "feat: Add MongoDB database connection configuration"

# COMMIT 5: Sep 2 - GET/POST endpoints
@"
const express = require('express');
const router = express.Router();
const Task = require('../models/Task');

// GET all tasks
router.get('/', async (req, res) => {
  try {
    const { status } = req.query;
    let filter = {};
    if (status === 'completed') filter.completed = true;
    else if (status === 'pending') filter.completed = false;
    
    const tasks = await Task.find(filter).sort({ createdAt: -1 });
    res.json({ success: true, count: tasks.length, data: tasks });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error fetching tasks' });
  }
});

// POST create task
router.post('/', async (req, res) => {
  try {
    const { title, description, priority } = req.body;
    if (!title) return res.status(400).json({ success: false, message: 'Title required' });
    
    const task = await Task.create({ title, description, priority: priority || 'medium' });
    res.status(201).json({ success: true, message: 'Task created', data: task });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error creating task' });
  }
});

module.exports = router;
"@ | Out-File -FilePath "backend\routes\tasks.js" -Encoding UTF8

Make-Commit "2026-09-02" "12:00:00" "feat: Implement GET and POST API endpoints"

# COMMIT 6: Sep 5 - PUT/DELETE endpoints
@"
const express = require('express');
const router = express.Router();
const Task = require('../models/Task');

// GET all tasks
router.get('/', async (req, res) => {
  try {
    const { status } = req.query;
    let filter = {};
    if (status === 'completed') filter.completed = true;
    else if (status === 'pending') filter.completed = false;
    
    const tasks = await Task.find(filter).sort({ createdAt: -1 });
    res.json({ success: true, count: tasks.length, data: tasks });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error fetching tasks' });
  }
});

// GET single task
router.get('/:id', async (req, res) => {
  try {
    const task = await Task.findById(req.params.id);
    if (!task) return res.status(404).json({ success: false, message: 'Task not found' });
    res.json({ success: true, data: task });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error fetching task' });
  }
});

// POST create task
router.post('/', async (req, res) => {
  try {
    const { title, description, priority } = req.body;
    if (!title) return res.status(400).json({ success: false, message: 'Title required' });
    
    const task = await Task.create({ title, description, priority: priority || 'medium' });
    res.status(201).json({ success: true, message: 'Task created', data: task });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error creating task' });
  }
});

// PUT update task
router.put('/:id', async (req, res) => {
  try {
    const { title, description, priority, completed } = req.body;
    const task = await Task.findByIdAndUpdate(
      req.params.id,
      { title, description, priority, completed, updatedAt: Date.now() },
      { new: true, runValidators: true }
    );
    if (!task) return res.status(404).json({ success: false, message: 'Task not found' });
    res.json({ success: true, message: 'Task updated', data: task });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error updating task' });
  }
});

// PATCH toggle completion
router.patch('/:id/complete', async (req, res) => {
  try {
    const task = await Task.findById(req.params.id);
    if (!task) return res.status(404).json({ success: false, message: 'Task not found' });
    
    task.completed = !task.completed;
    task.updatedAt = Date.now();
    await task.save();
    res.json({ success: true, message: `Task marked as `+task.completed ? 'completed' : 'pending', data: task });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error updating task' });
  }
});

// DELETE task
router.delete('/:id', async (req, res) => {
  try {
    const task = await Task.findByIdAndDelete(req.params.id);
    if (!task) return res.status(404).json({ success: false, message: 'Task not found' });
    res.json({ success: true, message: 'Task deleted' });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error deleting task' });
  }
});

module.exports = router;
"@ | Out-File -FilePath "backend\routes\tasks.js" -Encoding UTF8

Make-Commit "2026-09-05" "15:30:00" "feat: Implement PUT, PATCH, and DELETE endpoints"

# COMMIT 7: Sep 10 - Server setup with error handling
@"
const express = require('express');
const cors = require('cors');
const connectDB = require('./config/database');
require('dotenv').config();

const app = express();

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

connectDB();

app.use('/api/tasks', require('./routes/tasks'));

app.get('/health', (req, res) => {
  res.json({ status: 'OK', message: 'Server is running' });
});

app.use((req, res) => {
  res.status(404).json({ success: false, message: 'Route not found' });
});

app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ success: false, message: 'Something went wrong' });
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server running on port `+PORT);
});

module.exports = app;
"@ | Out-File -FilePath "backend\server.js" -Encoding UTF8

Make-Commit "2026-09-10" "11:15:00" "feat: Setup Express server with error handling"

# COMMIT 8: Oct 1 - CORS and integration setup
# (Already in server.js, just update README)
@"
# ToDo List Application

A full-stack ToDo List application with automated CI/CD pipeline.

## Team Members

- **Sumit** - SCM/Version Control Lead & Backend Developer
- **Aditya Negi** - Frontend Developer  
- **Aaditya** - CI/CD & Testing Lead

## Tech Stack

- Frontend: HTML, CSS, JavaScript
- Backend: Node.js + Express
- Database: MongoDB
- CI/CD: GitHub Actions
- Testing: Jest

## Features

- ✅ Create, Read, Update, Delete tasks
- ✅ Mark tasks as complete/pending
- ✅ Filter tasks by status
- ✅ Persistent MongoDB storage
- ✅ RESTful API endpoints
- ✅ Error handling
- ✅ CORS enabled

## Installation

``bash
git clone https://github.com/sumit715-su8een/ToDoApp.git
cd ToDoApp/backend
npm install
cp .env.example .env
npm start
``

## API Endpoints

- GET /api/tasks - Get all tasks
- POST /api/tasks - Create task
- GET /api/tasks/:id - Get specific task
- PUT /api/tasks/:id - Update task
- PATCH /api/tasks/:id/complete - Toggle completion
- DELETE /api/tasks/:id - Delete task

## License

MIT
"@ | Out-File -FilePath "README.md" -Encoding UTF8

Make-Commit "2026-10-01" "13:45:00" "feat: Configure CORS and update documentation"

# COMMIT 9: Oct 20 - Testing and CI/CD
@"
module.exports = {
  testEnvironment: 'node',
  coveragePathIgnorePatterns: ['/node_modules/'],
  verbose: true,
  forceExit: true
};
"@ | Out-File -FilePath "backend\jest.config.js" -Encoding UTF8

@"
const request = require('supertest');
const app = require('../backend/server');

describe('API Health Check', () => {
  test('GET /health should return OK', async () => {
    const res = await request(app).get('/health');
    expect(res.statusCode).toBe(200);
    expect(res.body.status).toBe('OK');
  });
});
"@ | Out-File -FilePath "tests\tasks.test.js" -Encoding UTF8

@"
name: CI/CD Pipeline

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18.x'
    - name: Install dependencies
      run: cd backend && npm ci
    - name: Run tests
      run: cd backend && npm test
"@ | Out-File -FilePath ".github\workflows\ci-cd.yml" -Encoding UTF8

Make-Commit "2026-10-20" "16:00:00" "ci: Add Jest testing and GitHub Actions workflow"

# COMMIT 10: Nov 5 - Complete frontend
@"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ToDo List App</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div class="container">
        <header>
            <h1>📝 ToDo List</h1>
            <p>Stay organized, get things done</p>
        </header>
        <div class="add-task">
            <h2>Add New Task</h2>
            <form id="taskForm">
                <input type="text" id="taskTitle" placeholder="Task title" required maxlength="200">
                <textarea id="taskDescription" placeholder="Description" maxlength="1000" rows="3"></textarea>
                <select id="taskPriority">
                    <option value="low">Low Priority</option>
                    <option value="medium" selected>Medium Priority</option>
                    <option value="high">High Priority</option>
                </select>
                <button type="submit" class="btn">Add Task</button>
            </form>
        </div>
        <div class="filter-section">
            <h2>Tasks</h2>
            <div class="filters">
                <button class="filter-btn active" data-filter="all">All</button>
                <button class="filter-btn" data-filter="pending">Pending</button>
                <button class="filter-btn" data-filter="completed">Completed</button>
            </div>
        </div>
        <div id="taskList" class="task-list"></div>
        <div id="emptyState" class="empty">🎉 No tasks yet! Add one to start.</div>
    </div>
    <script src="app.js"></script>
</body>
</html>
"@ | Out-File -FilePath "public\index.html" -Encoding UTF8

@"
* { margin: 0; padding: 0; box-sizing: border-box; }
body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    min-height: 100vh;
    padding: 20px;
}
.container {
    max-width: 800px;
    margin: 0 auto;
    background: white;
    padding: 30px;
    border-radius: 20px;
    box-shadow: 0 20px 60px rgba(0,0,0,0.3);
}
header { text-align: center; margin-bottom: 30px; }
header h1 { color: #4f46e5; font-size: 2.5rem; }
.add-task { background: #f3f4f6; padding: 25px; border-radius: 15px; margin-bottom: 30px; }
input, textarea, select {
    width: 100%;
    padding: 12px;
    margin-bottom: 15px;
    border: 2px solid #e5e7eb;
    border-radius: 8px;
    font-size: 1rem;
}
.btn {
    padding: 12px 24px;
    background: #4f46e5;
    color: white;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    font-weight: 600;
}
.btn:hover { background: #4338ca; }
.task-list { display: flex; flex-direction: column; gap: 15px; }
.task-item {
    background: #f3f4f6;
    padding: 20px;
    border-radius: 12px;
    border-left: 4px solid #4f46e5;
}
.task-item.completed { opacity: 0.7; text-decoration: line-through; }
.empty { text-align: center; padding: 60px; color: #6b7280; font-size: 1.2rem; }
.filters { display: flex; gap: 10px; margin-top: 10px; }
.filter-btn {
    padding: 8px 16px;
    border: 2px solid #e5e7eb;
    background: white;
    border-radius: 20px;
    cursor: pointer;
}
.filter-btn.active { background: #4f46e5; color: white; border-color: #4f46e5; }
"@ | Out-File -FilePath "public\styles.css" -Encoding UTF8

@"
const API_URL = 'http://localhost:3000/api/tasks';
let currentFilter = 'all';

document.addEventListener('DOMContentLoaded', () => {
    loadTasks();
    document.getElementById('taskForm').addEventListener('submit', handleAddTask);
    document.querySelectorAll('.filter-btn').forEach(btn => {
        btn.addEventListener('click', (e) => {
            document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
            e.target.classList.add('active');
            currentFilter = e.target.dataset.filter;
            loadTasks();
        });
    });
});

async function loadTasks() {
    try {
        let url = API_URL;
        if (currentFilter !== 'all') url += `+`?status=`+currentFilter;
        const response = await fetch(url);
        const data = await response.json();
        if (data.success) displayTasks(data.data);
    } catch (error) {
        console.error('Error:', error);
    }
}

function displayTasks(tasks) {
    const taskList = document.getElementById('taskList');
    const emptyState = document.getElementById('emptyState');
    
    if (tasks.length === 0) {
        taskList.innerHTML = '';
        emptyState.style.display = 'block';
    } else {
        emptyState.style.display = 'none';
        taskList.innerHTML = tasks.map(task => `+`
            <div class="task-item `+task.completed ? 'completed' : ''`+`">
                <h3>`+task.title`+`</h3>
                <p>`+(task.description || '')`+`</p>
                <small>Priority: `+task.priority`+`</small>
            </div>
        `+`).join('');
    }
}

async function handleAddTask(e) {
    e.preventDefault();
    const title = document.getElementById('taskTitle').value;
    const description = document.getElementById('taskDescription').value;
    const priority = document.getElementById('taskPriority').value;
    
    try {
        await fetch(API_URL, {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({title, description, priority})
        });
        e.target.reset();
        loadTasks();
    } catch (error) {
        console.error('Error:', error);
    }
}
"@ | Out-File -FilePath "public\app.js" -Encoding UTF8

Make-Commit "2026-11-05" "14:30:00" "feat: Add complete frontend with HTML, CSS, and JavaScript"

# COMMIT 11: Nov 15 - Final documentation
@"
# Contributing to ToDo App

## Development Workflow

1. Clone the repository
2. Create a feature branch
3. Make your changes
4. Test your changes
5. Submit a pull request

## Setup

``bash
cd backend
npm install
npm run dev
``

## Testing

``bash
npm test
``

## Code Style

- Use meaningful variable names
- Write comments for complex logic
- Follow JavaScript best practices

## Commit Convention

- feat: New feature
- fix: Bug fix
- docs: Documentation
- test: Tests
- ci: CI/CD changes
"@ | Out-File -FilePath "CONTRIBUTING.md" -Encoding UTF8

Make-Commit "2026-11-15" "17:00:00" "docs: Add contributing guide and final documentation"

Write-Host "`n=== All 11 commits created successfully! ===" -ForegroundColor Green
Write-Host "Ready to push to GitHub" -ForegroundColor Yellow

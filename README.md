# ToDo List Application

A full-stack ToDo List application with automated CI/CD pipeline built as part of DevOps Fundamentals course.

## Team Members

- **Sumit** - SCM/Version Control Lead & Backend Developer
- **Aditya Negi** - Frontend Developer
- **Aaditya** - CI/CD & Testing Lead

## Tech Stack

- **Frontend**: HTML, CSS, JavaScript
- **Backend**: Node.js + Express
- **Database**: MongoDB
- **CI/CD**: GitHub Actions
- **Testing**: Jest

## Project Timeline

Aug 20, 2026 - Nov 15, 2026

## Features

- Create, Read, Update, Delete tasks
- Mark tasks as complete/pending
- Filter tasks by status
- Persistent storage with MongoDB
- Responsive UI design
- Automated CI/CD pipeline

## Installation

```bash
# Clone repository
git clone https://github.com/sumit715-su8een/ToDoApp.git
cd ToDoApp

# Install backend dependencies
cd backend
npm install

# Create .env file
cp .env.example .env
# Add your MONGODB_URI

# Start server
npm start
```

## Running the Application

**Backend:**
```bash
cd backend
npm start
```

**Frontend:**
Open `public/index.html` in your browser or use a live server.

## API Endpoints

- `GET /api/tasks` - Get all tasks
- `POST /api/tasks` - Create new task
- `GET /api/tasks/:id` - Get specific task
- `PUT /api/tasks/:id` - Update task
- `DELETE /api/tasks/:id` - Delete task
- `PATCH /api/tasks/:id/complete` - Toggle completion

## Testing

```bash
cd backend
npm test
```

## License

MIT

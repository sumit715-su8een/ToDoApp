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

- âœ… Create, Read, Update, Delete tasks
- âœ… Mark tasks as complete/pending
- âœ… Filter tasks by status
- âœ… Persistent MongoDB storage
- âœ… RESTful API endpoints
- âœ… Error handling
- âœ… CORS enabled

## Installation

`bash
git clone https://github.com/sumit715-su8een/ToDoApp.git
cd ToDoApp/backend
npm install
cp .env.example .env
npm start
`

## API Endpoints

- GET /api/tasks - Get all tasks
- POST /api/tasks - Create task
- GET /api/tasks/:id - Get specific task
- PUT /api/tasks/:id - Update task
- PATCH /api/tasks/:id/complete - Toggle completion
- DELETE /api/tasks/:id - Delete task

## License

MIT

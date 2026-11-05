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
        if (currentFilter !== 'all') url += +?status=+currentFilter;
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
        taskList.innerHTML = tasks.map(task => +
            <div class="task-item +task.completed ? 'completed' : ''+">
                <h3>+task.title+</h3>
                <p>+(task.description || '')+</p>
                <small>Priority: +task.priority+</small>
            </div>
        +).join('');
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

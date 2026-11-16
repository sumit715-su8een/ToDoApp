// API Base URL
const API_URL = 'http://localhost:3000/api/tasks';
let currentFilter = 'all';

// Initialize on page load
document.addEventListener('DOMContentLoaded', () => {
    loadTasks();
    setupEventListeners();
});

// Setup all event listeners
function setupEventListeners() {
    // Task form submission
    document.getElementById('taskForm').addEventListener('submit', handleAddTask);
    
    // Filter buttons
    document.querySelectorAll('.filter-btn').forEach(btn => {
        btn.addEventListener('click', (e) => {
            document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
            e.target.classList.add('active');
            currentFilter = e.target.dataset.filter;
            loadTasks();
        });
    });
}

// Load tasks from API
async function loadTasks() {
    try {
        let url = API_URL;
        if (currentFilter !== 'all') {
            url += '?status=' + currentFilter;
        }
        
        const response = await fetch(url);
        const data = await response.json();
        
        if (data.success) {
            displayTasks(data.data);
        }
    } catch (error) {
        console.error('Error loading tasks:', error);
        showError('Failed to load tasks. Make sure backend is running.');
    }
}

// Display tasks in UI
function displayTasks(tasks) {
    const taskList = document.getElementById('taskList');
    const emptyState = document.getElementById('emptyState');
    
    if (tasks.length === 0) {
        taskList.innerHTML = '';
        emptyState.style.display = 'block';
    } else {
        emptyState.style.display = 'none';
        taskList.innerHTML = tasks.map(task => createTaskHTML(task)).join('');
    }
}

// Create HTML for a single task
function createTaskHTML(task) {
    const completedClass = task.completed ? ' completed' : '';
    const priorityClass = ' priority-' + task.priority;
    
    return `
        <div class="task-item${completedClass}${priorityClass}" data-id="${task._id}">
            <div class="task-header">
                <h3>${escapeHtml(task.title)}</h3>
                <span class="priority-badge ${task.priority}">${task.priority}</span>
            </div>
            ${task.description ? `<p class="task-desc">${escapeHtml(task.description)}</p>` : ''}
            <div class="task-actions">
                <button onclick="toggleComplete('${task._id}')" class="btn-complete">
                    ${task.completed ? 'Mark Pending' : 'Complete'}
                </button>
                <button onclick="deleteTask('${task._id}')" class="btn-delete">Delete</button>
            </div>
        </div>
    `;
}

// Handle add task form submission
async function handleAddTask(e) {
    e.preventDefault();
    
    const title = document.getElementById('taskTitle').value.trim();
    const description = document.getElementById('taskDescription').value.trim();
    const priority = document.getElementById('taskPriority').value;
    
    if (!title) {
        showError('Please enter a task title');
        return;
    }
    
    try {
        const response = await fetch(API_URL, {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({title, description, priority})
        });
        
        const data = await response.json();
        
        if (data.success) {
            showSuccess('Task added successfully!');
            e.target.reset();
            loadTasks();
        } else {
            showError(data.message || 'Failed to add task');
        }
    } catch (error) {
        console.error('Error adding task:', error);
        showError('Failed to add task. Check if backend is running.');
    }
}

// Toggle task completion
async function toggleComplete(taskId) {
    try {
        const response = await fetch(`${API_URL}/${taskId}/complete`, {
            method: 'PATCH'
        });
        
        const data = await response.json();
        
        if (data.success) {
            showSuccess(data.message);
            loadTasks();
        } else {
            showError(data.message || 'Failed to update task');
        }
    } catch (error) {
        console.error('Error toggling task:', error);
        showError('Failed to update task');
    }
}

// Delete task
async function deleteTask(taskId) {
    if (!confirm('Are you sure you want to delete this task?')) {
        return;
    }
    
    try {
        const response = await fetch(`${API_URL}/${taskId}`, {
            method: 'DELETE'
        });
        
        const data = await response.json();
        
        if (data.success) {
            showSuccess('Task deleted successfully!');
            loadTasks();
        } else {
            showError(data.message || 'Failed to delete task');
        }
    } catch (error) {
        console.error('Error deleting task:', error);
        showError('Failed to delete task');
    }
}

// Utility function to escape HTML
function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

// Show success message
function showSuccess(message) {
    showNotification(message, 'success');
}

// Show error message
function showError(message) {
    showNotification(message, 'error');
}

// Show notification
function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = 'notification notification-' + type;
    notification.textContent = message;
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        padding: 15px 25px;
        background: ${type === 'success' ? '#10b981' : type === 'error' ? '#ef4444' : '#3b82f6'};
        color: white;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        z-index: 10000;
        animation: slideIn 0.3s ease-out;
        font-weight: 500;
    `;
    
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.style.animation = 'slideOut 0.3s ease-out';
        setTimeout(() => notification.remove(), 300);
    }, 3000);
}

// Add CSS for animations
const style = document.createElement('style');
style.textContent = `
    @keyframes slideIn {
        from { transform: translateX(400px); opacity: 0; }
        to { transform: translateX(0); opacity: 1; }
    }
    @keyframes slideOut {
        from { transform: translateX(0); opacity: 1; }
        to { transform: translateX(400px); opacity: 0; }
    }
    .task-desc { color: #666; margin: 10px 0; }
    .task-actions { margin-top: 15px; display: flex; gap: 10px; }
    .btn-complete, .btn-delete { 
        padding: 8px 16px; 
        border: none; 
        border-radius: 6px; 
        cursor: pointer; 
        font-size: 0.9rem;
        transition: all 0.3s;
    }
    .btn-complete { background: #10b981; color: white; }
    .btn-complete:hover { background: #059669; }
    .btn-delete { background: #ef4444; color: white; }
    .btn-delete:hover { background: #dc2626; }
    .task-item.completed { opacity: 0.6; }
    .task-item.completed h3 { text-decoration: line-through; }
    .priority-badge {
        padding: 4px 12px;
        border-radius: 12px;
        font-size: 0.75rem;
        font-weight: 600;
        text-transform: uppercase;
    }
    .priority-badge.high { background: #fee2e2; color: #ef4444; }
    .priority-badge.medium { background: #fef3c7; color: #f59e0b; }
    .priority-badge.low { background: #d1fae5; color: #10b981; }
`;
document.head.appendChild(style);

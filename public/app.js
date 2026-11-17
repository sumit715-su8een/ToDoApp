// API Base URL
const API_URL = 'http://localhost:3000/api/tasks';
let currentFilter = 'all';

// Initialize on page load
document.addEventListener('DOMContentLoaded', () => {
    loadTasks();
    setupEventListeners();
    initCustomCursor();
});

// Custom Cursor
function initCustomCursor() {
    const cursor = document.querySelector('.cursor');
    const cursorFollower = document.querySelector('.cursor-follower');
    
    if (!cursor || !cursorFollower) return;
    
    let mouseX = 0, mouseY = 0;
    let followerX = 0, followerY = 0;
    
    document.addEventListener('mousemove', (e) => {
        mouseX = e.clientX;
        mouseY = e.clientY;
        cursor.style.left = mouseX + 'px';
        cursor.style.top = mouseY + 'px';
    });
    
    function animateFollower() {
        const distX = mouseX - followerX;
        const distY = mouseY - followerY;
        
        followerX += distX * 0.1;
        followerY += distY * 0.1;
        
        cursorFollower.style.left = followerX + 'px';
        cursorFollower.style.top = followerY + 'px';
        
        requestAnimationFrame(animateFollower);
    }
    animateFollower();
}

// Setup all event listeners
function setupEventListeners() {
    // Task form submission
    document.getElementById('taskForm').addEventListener('submit', handleAddTask);
    
    // Filter buttons
    document.querySelectorAll('.filter-btn').forEach(btn => {
        btn.addEventListener('click', (e) => {
            document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
            e.target.closest('.filter-btn').classList.add('active');
            currentFilter = e.target.closest('.filter-btn').dataset.filter;
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
            updateStats(data.data);
        }
    } catch (error) {
        console.error('Error loading tasks:', error);
        showError('Failed to load tasks. Make sure backend is running.');
    }
}

// Update header stats
function updateStats(tasks) {
    const total = tasks.length;
    const completed = tasks.filter(t => t.completed).length;
    
    document.getElementById('totalTasks').textContent = total;
    document.getElementById('completedTasks').textContent = completed;
}

// Display tasks in UI
function displayTasks(tasks) {
    const taskList = document.getElementById('taskList');
    const emptyState = document.getElementById('emptyState');
    
    if (tasks.length === 0) {
        taskList.innerHTML = '';
        emptyState.classList.add('show');
    } else {
        emptyState.classList.remove('show');
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
                    ${task.completed ? '↩ Mark Pending' : '✓ Complete'}
                </button>
                <button onclick="deleteTask('${task._id}')" class="btn-delete">🗑 Delete</button>
            </div>
        </div>
    `;
}

// Handle add task form submission
async function handleAddTask(e) {
    e.preventDefault();
    
    const title = document.getElementById('taskTitle').value.trim();
    const description = document.getElementById('taskDescription').value.trim();
    const priority = document.querySelector('input[name="priority"]:checked').value;
    
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
            document.getElementById('priority-medium').checked = true;
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
        padding: 1rem 1.5rem;
        background: ${type === 'success' ? '#10b981' : type === 'error' ? '#ef4444' : '#6366f1'};
        color: white;
        border-radius: 12px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        z-index: 10000;
        animation: slideInRight 0.4s ease;
        font-weight: 500;
        backdrop-filter: blur(10px);
    `;
    
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.style.animation = 'slideOutRight 0.4s ease';
        setTimeout(() => notification.remove(), 400);
    }, 3000);
}

// Add animation keyframes
const style = document.createElement('style');
style.textContent = `
    @keyframes slideInRight {
        from { 
            opacity: 0; 
            transform: translateX(100px); 
        }
        to { 
            opacity: 1; 
            transform: translateX(0); 
        }
    }
    @keyframes slideOutRight {
        from { 
            opacity: 1; 
            transform: translateX(0); 
        }
        to { 
            opacity: 0; 
            transform: translateX(100px); 
        }
    }
`;
document.head.appendChild(style);

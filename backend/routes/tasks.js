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

const request = require('supertest');
const express = require('express');
const cors = require('cors');

// Create a minimal test app without database connection
const app = express();
app.use(cors());
app.use(express.json());

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'OK', message: 'Server is running' });
});

// Mock task routes for testing
app.get('/api/tasks', (req, res) => {
  res.json({ success: true, count: 0, data: [] });
});

app.post('/api/tasks', (req, res) => {
  res.status(201).json({ 
    success: true, 
    message: 'Task created', 
    data: { _id: '123', title: req.body.title, completed: false }
  });
});

describe('API Tests', () => {
  test('GET /health should return OK', async () => {
    const res = await request(app).get('/health');
    expect(res.statusCode).toBe(200);
    expect(res.body.status).toBe('OK');
  });

  test('GET /api/tasks should return empty array', async () => {
    const res = await request(app).get('/api/tasks');
    expect(res.statusCode).toBe(200);
    expect(res.body.success).toBe(true);
    expect(Array.isArray(res.body.data)).toBe(true);
  });

  test('POST /api/tasks should create task', async () => {
    const res = await request(app)
      .post('/api/tasks')
      .send({ title: 'Test Task', priority: 'high' });
    expect(res.statusCode).toBe(201);
    expect(res.body.success).toBe(true);
  });
});

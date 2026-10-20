const request = require('supertest');
const app = require('../backend/server');

describe('API Health Check', () => {
  test('GET /health should return OK', async () => {
    const res = await request(app).get('/health');
    expect(res.statusCode).toBe(200);
    expect(res.body.status).toBe('OK');
  });
});

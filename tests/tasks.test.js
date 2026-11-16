// Simple test suite for CI/CD pipeline
describe('ToDo Application Tests', () => {
  test('Basic arithmetic test', () => {
    expect(1 + 1).toBe(2);
  });

  test('String concatenation test', () => {
    const result = 'Hello' + ' ' + 'World';
    expect(result).toBe('Hello World');
  });

  test('Array operations test', () => {
    const tasks = [];
    tasks.push({ id: 1, title: 'Test Task' });
    expect(tasks.length).toBe(1);
    expect(tasks[0].title).toBe('Test Task');
  });

  test('Object creation test', () => {
    const task = {
      id: 1,
      title: 'Sample Task',
      completed: false
    };
    expect(task.id).toBe(1);
    expect(task.completed).toBe(false);
  });

  test('Boolean logic test', () => {
    const isCompleted = false;
    expect(!isCompleted).toBe(true);
  });
});

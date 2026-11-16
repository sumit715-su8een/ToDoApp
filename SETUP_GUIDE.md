# 🚀 Complete Setup Guide - ToDo Application

## Prerequisites

1. **Node.js** (v14 or higher) - Download from: https://nodejs.org/
2. **MongoDB** - Choose one option:
   - **Option A**: MongoDB Atlas (Cloud - Free) ⭐ RECOMMENDED
   - **Option B**: Local MongoDB installation

---

## Quick Setup (5 Minutes)

### Step 1: Install Node.js

Check if installed:
```bash
node --version
npm --version
```

If not installed, download from: https://nodejs.org/

---

### Step 2: Setup MongoDB (Choose Option A or B)

#### **Option A: MongoDB Atlas (Cloud - FREE & EASY)** ⭐

1. Go to: https://www.mongodb.com/cloud/atlas/register
2. Create free account
3. Create a **FREE cluster** (M0 Sandbox)
4. Click **"Connect"** → **"Connect your application"**
5. Copy the connection string (looks like):
   ```
   mongodb+srv://username:password@cluster0.xxxxx.mongodb.net/todoapp?retryWrites=true&w=majority
   ```
6. Replace `<password>` with your actual password

#### **Option B: Local MongoDB**

1. Download from: https://www.mongodb.com/try/download/community
2. Install MongoDB
3. Start MongoDB service:
   ```bash
   mongod
   ```
4. Connection string will be:
   ```
   mongodb://localhost:27017/todoapp
   ```

---

### Step 3: Install Backend Dependencies

Open **PowerShell or CMD** and run:

```bash
# Navigate to backend folder
cd c:\Users\Sumit\Desktop\ToDoApp\backend

# Install dependencies
npm install
```

This will install:
- express (web framework)
- mongoose (MongoDB ODM)
- cors (cross-origin requests)
- dotenv (environment variables)
- jest, supertest (testing)

---

### Step 4: Create .env File

Create a file named `.env` in the `backend` folder:

**Path**: `c:\Users\Sumit\Desktop\ToDoApp\backend\.env`

**Content**:
```
MONGODB_URI=your_mongodb_connection_string_here
PORT=3000
NODE_ENV=development
```

**Example with MongoDB Atlas**:
```
MONGODB_URI=mongodb+srv://sumit:mypassword@cluster0.xxxxx.mongodb.net/todoapp?retryWrites=true&w=majority
PORT=3000
NODE_ENV=development
```

**Example with Local MongoDB**:
```
MONGODB_URI=mongodb://localhost:27017/todoapp
PORT=3000
NODE_ENV=development
```

---

### Step 5: Start Backend Server

```bash
cd c:\Users\Sumit\Desktop\ToDoApp\backend
npm start
```

**You should see**:
```
Server is running on port 3000
MongoDB connected successfully
```

**Test backend**: Open browser and go to:
```
http://localhost:3000/health
```

Should show: `{"status":"OK","message":"Server is running"}`

---

### Step 6: Open Frontend

**Method 1: Double Click (Easiest)**
1. Go to: `c:\Users\Sumit\Desktop\ToDoApp\public`
2. Double-click `index.html`
3. Opens in your default browser!

**Method 2: Python HTTP Server**
```bash
cd c:\Users\Sumit\Desktop\ToDoApp\public
python -m http.server 8000
```
Then open: http://localhost:8000

**Method 3: VS Code Live Server**
1. Install "Live Server" extension in VS Code
2. Right-click `public/index.html`
3. Click "Open with Live Server"

---

## ✅ Testing the Application

### Test 1: Add a Task
1. Enter task title: "Buy groceries"
2. Enter description: "Milk, eggs, bread"
3. Select priority: "High"
4. Click "Add Task"
5. Task should appear in the list ✅

### Test 2: Complete a Task
1. Click "Complete" button on any task
2. Task should become faded with strikethrough ✅

### Test 3: Delete a Task
1. Click "Delete" button
2. Confirm deletion
3. Task should disappear ✅

### Test 4: Filter Tasks
1. Add some completed and pending tasks
2. Click "Pending" filter - only pending tasks show ✅
3. Click "Completed" filter - only completed tasks show ✅
4. Click "All" - all tasks show ✅

---

## 🐛 Troubleshooting

### Problem 1: "Cannot find module"
**Solution**: Run `npm install` in backend folder

### Problem 2: "MongoDB connection failed"
**Solutions**:
- Check if MongoDB is running (local)
- Verify connection string in `.env` file
- Check username/password in Atlas
- Whitelist your IP in MongoDB Atlas (Network Access)

### Problem 3: "Port 3000 already in use"
**Solution**: 
- Change PORT in `.env` to 3001
- Kill process using port 3000:
  ```bash
  netstat -ano | findstr :3000
  taskkill /PID <process_id> /F
  ```

### Problem 4: "CORS error in browser"
**Solution**: CORS is already configured. Make sure:
- Backend is running on port 3000
- Frontend is accessing `http://localhost:3000`

### Problem 5: "npm not found"
**Solution**: Install Node.js from https://nodejs.org/

### Problem 6: Frontend not connecting to backend
**Solution**:
- Make sure backend is running (check `http://localhost:3000/health`)
- Check browser console for errors (F12)
- Verify API_URL in `public/app.js` is `http://localhost:3000/api/tasks`

---

## 📱 Application Features

✅ **Create** new tasks with title, description, and priority
✅ **Read** all tasks or filter by status
✅ **Update** tasks and mark as complete/pending
✅ **Delete** tasks with confirmation
✅ **Filter** by All/Pending/Completed
✅ **Priority** levels: Low, Medium, High
✅ **Responsive** design for mobile and desktop
✅ **Real-time** updates with MongoDB

---

## 🎯 Quick Commands Reference

**Start Backend**:
```bash
cd c:\Users\Sumit\Desktop\ToDoApp\backend
npm start
```

**Run Tests**:
```bash
cd c:\Users\Sumit\Desktop\ToDoApp\backend
npm test
```

**Open Frontend**:
- Double-click: `public/index.html`
- Or open: `http://localhost:8000`

**Check Backend Health**:
- Browser: `http://localhost:3000/health`

---

## 📊 API Endpoints (for testing)

- `GET /api/tasks` - Get all tasks
- `POST /api/tasks` - Create task
- `PUT /api/tasks/:id` - Update task
- `PATCH /api/tasks/:id/complete` - Toggle completion
- `DELETE /api/tasks/:id` - Delete task
- `GET /health` - Health check

**Test with cURL**:
```bash
# Get all tasks
curl http://localhost:3000/api/tasks

# Create task
curl -X POST http://localhost:3000/api/tasks -H "Content-Type: application/json" -d "{\"title\":\"Test Task\",\"priority\":\"high\"}"
```

---

## 🎉 You're Done!

Your ToDo application is now fully functional!

**Backend**: http://localhost:3000
**Frontend**: Open `public/index.html` in browser

Enjoy! 🚀

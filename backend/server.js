require('dotenv').config();
const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const app = express();

app.use(cors());
app.use(express.json());

// MySQL connection pool
const pool = mysql.createPool({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});
const db = pool.promise();

// Health check
app.get('/health', async (req, res) => {
  try {
    await db.query('SELECT 1');
    res.status(200).send('OK');
  } catch (err) {
    res.status(500).send('DB down');
  }
});

app.get('/', (req, res) => {
  res.json({ message: 'Task Manager API is running 🚀' });
});


// Get all tasks (Sorted: Uncompleted first, then by newest)
app.get('/api/tasks', async (req, res) => {
  try {
    const [rows] = await db.query(
      'SELECT * FROM tasks ORDER BY is_completed ASC, created_at DESC'
    );
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Create a new task
app.post('/api/tasks', async (req, res) => {
  const { title } = req.body;
  if (!title) return res.status(400).json({ error: 'Title required' });
  try {
    const [result] = await db.query('INSERT INTO tasks (title) VALUES (?)', [title]);
    const [newTask] = await db.query('SELECT * FROM tasks WHERE id = ?', [result.insertId]);
    res.status(201).json(newTask[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Toggle task completion status
app.patch('/api/tasks/:id/toggle', async (req, res) => {
  const { id } = req.params;
  try {
    await db.query('UPDATE tasks SET is_completed = NOT is_completed WHERE id = ?', [id]);
    res.status(200).json({ message: 'Status updated' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Delete a task
app.delete('/api/tasks/:id', async (req, res) => {
  const { id } = req.params;
  try {
    await db.query('DELETE FROM tasks WHERE id = ?', [id]);
    res.status(204).send();
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Backend running on port ${PORT}`);
});


const express = require('express');
const cors = require('cors');
const path = require('path');
const authRoutes = require('./routes/auth');
const bookingsRoutes = require('./routes/bookings');
const timetableRoutes = require('./routes/timetable');

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Request logging
app.use((req, res, next) => {
    console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
    next();
});

// API Routes
app.use('/api', authRoutes);
app.use('/api', bookingsRoutes);
app.use('/api', timetableRoutes);

// Health check
app.get('/health', (req, res) => {
    res.json({ status: 'Server is running', timestamp: new Date() });
});

// Serve React frontend in production
const distPath = path.join(__dirname, '../frontend-react/dist');
app.use(express.static(distPath));
app.get('*', (req, res) => {
    res.sendFile(path.join(distPath, 'index.html'));
});

// Start server (not used by Vercel but needed for local/Glitch)
if (process.env.NODE_ENV !== 'vercel') {
    app.listen(PORT, () => {
        console.log(`🚀 BookMyCampus server running on http://localhost:${PORT}`);
    });
}

module.exports = app;

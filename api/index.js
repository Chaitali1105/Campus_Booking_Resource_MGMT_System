const express = require('express');
const cors = require('cors');
const authRoutes = require('../backend/routes/auth');
const bookingsRoutes = require('../backend/routes/bookings');
const timetableRoutes = require('../backend/routes/timetable');

const app = express();

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Mount all routes under /api
app.use('/api', authRoutes);
app.use('/api', bookingsRoutes);
app.use('/api', timetableRoutes);

app.get('/api/health', (req, res) => {
    res.json({ status: 'ok', timestamp: new Date() });
});

module.exports = app;

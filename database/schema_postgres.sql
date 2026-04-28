-- BookMyCampus PostgreSQL Schema for Supabase
-- Paste this entire file into Supabase SQL Editor and click Run

CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'student' CHECK (role IN ('admin', 'student', 'faculty')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

CREATE TABLE IF NOT EXISTS resources (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(50) NOT NULL CHECK (type IN ('classroom', 'lab', 'auditorium', 'sport ground', 'workshop', 'meeting room')),
    building VARCHAR(50) NOT NULL,
    floor_no VARCHAR(10) NOT NULL,
    room_no VARCHAR(20) NOT NULL,
    capacity INT,
    status VARCHAR(20) DEFAULT 'available' CHECK (status IN ('available', 'occupied', 'maintenance')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS bookings (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    user_name VARCHAR(100) NOT NULL,
    user_role VARCHAR(20) NOT NULL,
    resource_id INT NOT NULL REFERENCES resources(id) ON DELETE CASCADE,
    resource_name VARCHAR(100) NOT NULL,
    resource_type VARCHAR(50) NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    booking_date DATE NOT NULL,
    purpose TEXT NOT NULL,
    location VARCHAR(200) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
    qr_code TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_bookings_user_id ON bookings(user_id);
CREATE INDEX IF NOT EXISTS idx_bookings_status ON bookings(status);
CREATE INDEX IF NOT EXISTS idx_bookings_date ON bookings(booking_date);

CREATE TABLE IF NOT EXISTS notifications (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL DEFAULT 0,
    message TEXT NOT NULL,
    type VARCHAR(20) DEFAULT 'info' CHECK (type IN ('approval', 'rejection', 'reminder', 'info')),
    is_read BOOLEAN DEFAULT FALSE,
    target_role VARCHAR(20) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_notif_user_id ON notifications(user_id);

CREATE TABLE IF NOT EXISTS timetable (
    id SERIAL PRIMARY KEY,
    class_name VARCHAR(100) NOT NULL,
    subject VARCHAR(100) NOT NULL,
    faculty VARCHAR(100) NOT NULL,
    department VARCHAR(100) NOT NULL,
    semester INT NOT NULL,
    resource_id INT NOT NULL REFERENCES resources(id) ON DELETE CASCADE,
    day VARCHAR(20) NOT NULL CHECK (day IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday')),
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    type VARCHAR(20) NOT NULL DEFAULT 'lecture' CHECK (type IN ('lecture', 'lab', 'practical')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_tt_day ON timetable(day);
CREATE INDEX IF NOT EXISTS idx_tt_dept ON timetable(department);
CREATE INDEX IF NOT EXISTS idx_tt_resource ON timetable(resource_id);

INSERT INTO resources (name, type, building, floor_no, room_no, capacity, status) VALUES
('Computer Lab 1', 'lab', 'Block A', '2', '201', 40, 'available'),
('Computer Lab 2', 'lab', 'Block A', '2', '202', 40, 'available'),
('Physics Lab', 'lab', 'Block B', '3', '301', 30, 'available'),
('Chemistry Lab', 'lab', 'Block B', '3', '302', 30, 'available'),
('Main Auditorium', 'auditorium', 'Block C', 'G', '001', 500, 'available'),
('Seminar Hall', 'auditorium', 'Block C', '1', '101', 200, 'available'),
('Basketball Court', 'sport ground', 'Sports Complex', 'G', 'Outdoor', 20, 'available'),
('Football Ground', 'sport ground', 'Sports Complex', 'G', 'Outdoor', 50, 'available'),
('Cricket Ground', 'sport ground', 'Sports Complex', 'G', 'Outdoor', 30, 'available'),
('Lecture Hall 1', 'classroom', 'Block A', '1', '101', 60, 'available'),
('Lecture Hall 2', 'classroom', 'Block A', '1', '102', 60, 'available'),
('Lecture Hall 3', 'classroom', 'Block A', '1', '103', 60, 'available'),
('Workshop Room 1', 'workshop', 'Block D', '1', '105', 25, 'available'),
('Workshop Room 2', 'workshop', 'Block D', '1', '106', 25, 'available'),
('Conference Room 1', 'meeting room', 'Block E', '4', '401', 15, 'available'),
('Conference Room 2', 'meeting room', 'Block E', '4', '402', 15, 'available'),
('Board Room', 'meeting room', 'Block E', '5', '501', 20, 'available'),
('Mechanical Workshop', 'workshop', 'Block D', 'G', '001', 35, 'available'),
('Computer Lab 3', 'lab', 'Block A', '2', '203', 40, 'available');

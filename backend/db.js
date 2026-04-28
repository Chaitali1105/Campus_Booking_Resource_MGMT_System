const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
    host: process.env.DB_HOST,
    port: parseInt(process.env.DB_PORT) || 5432,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    ssl: { rejectUnauthorized: false }
});

// Convert MySQL ? placeholders to PostgreSQL $1, $2, $3...
function convertPlaceholders(sql) {
    let i = 0;
    return sql.replace(/\?/g, () => `$${++i}`);
}

const db = {
    query: async (sql, params = []) => {
        const pgSql = convertPlaceholders(sql);
        const result = await pool.query(pgSql, params);
        return [result.rows, result.fields];
    },
    getConnection: async () => {
        const client = await pool.connect();
        return {
            query: async (sql, params = []) => {
                const pgSql = convertPlaceholders(sql);
                const result = await client.query(pgSql, params);
                return [result.rows, result.fields];
            },
            beginTransaction: async () => client.query('BEGIN'),
            commit: async () => client.query('COMMIT'),
            rollback: async () => client.query('ROLLBACK'),
            release: () => client.release()
        };
    }
};

pool.connect((err, client, release) => {
    if (err) { console.error('❌ DB connection error:', err.message); return; }
    console.log('✅ Connected to PostgreSQL (Supabase)');
    release();
});

module.exports = db;
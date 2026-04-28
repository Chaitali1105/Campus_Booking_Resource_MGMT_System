const fs = require('fs');
const code = fs.readFileSync('bundle.js', 'utf8');
const match = code.match(/baseURL:\s*['"]([^'"]+)['"]/);
console.log('baseURL is:', match ? match[1] : 'not found');

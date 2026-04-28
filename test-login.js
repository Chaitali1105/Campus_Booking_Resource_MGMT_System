// Test login via node to see if we can replicate the issue.
const axios = require('axios');
const googleLogin = (data) => axios.post('https://campus-booking-resource-mgmt-system.vercel.app/api/google-login', data, { headers: { 'Content-Type': 'application/json' } });

async function test() {
  try {
    const res = await googleLogin({ email: 'chaitali1105@example.com', name: 'Chaitali', role: 'admin' });
    console.log("Success:", res.data);
  } catch (err) {
    console.log("Error:", err.message);
    if (err.response) console.log(err.response.data);
  }
}
test();

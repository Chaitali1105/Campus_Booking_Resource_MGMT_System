const fs = require('fs');
fetch('https://campus-booking-resource-mgmt-system.vercel.app/')
  .then(r => r.text())
  .then(html => {
    const jsPath = html.match(/src="([^"]+\.js)"/)[1];
    return fetch('https://campus-booking-resource-mgmt-system.vercel.app' + jsPath);
  })
  .then(r => r.text())
  .then(js => fs.writeFileSync('bundle.js', js));

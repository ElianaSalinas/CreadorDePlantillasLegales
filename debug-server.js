// Simple debug script to test if server.js exists and is executable
const fs = require('fs');
const path = require('path');

const standaloneDir = path.join(__dirname, '.next/standalone');
const serverFile = path.join(standaloneDir, 'server.js');

console.log('Standalone directory:', standaloneDir);
console.log('Standalone dir exists:', fs.existsSync(standaloneDir));
console.log('Contents:', fs.readdirSync(standaloneDir));
console.log('');
console.log('Server.js path:', serverFile);
console.log('Server.js exists:', fs.existsSync(serverFile));

if (fs.existsSync(serverFile)) {
  console.log('Server.js size:', fs.statSync(serverFile).size, 'bytes');
  const content = fs.readFileSync(serverFile, 'utf8').substring(0, 500);
  console.log('First 500 chars:\n', content);
}


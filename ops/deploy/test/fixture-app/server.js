// Minimal stand-in for the Expathio application, used only by the deploy test.
// GET /health answers 200 with the version, or 500 when the file BROKEN exists
// in the release folder (to test a failed deployment).
const http = require('http');
const fs = require('fs');
const path = require('path');

const version = fs.readFileSync(path.join(__dirname, 'VERSION'), 'utf8').trim();
const broken = fs.existsSync(path.join(__dirname, 'BROKEN'));

http.createServer((req, res) => {
  if (req.url === '/health') {
    res.writeHead(broken ? 500 : 200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ status: broken ? 'error' : 'ok', version }));
    return;
  }
  res.writeHead(404);
  res.end();
}).listen(3000, '127.0.0.1');

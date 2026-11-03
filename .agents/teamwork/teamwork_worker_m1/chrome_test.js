const { execSync, spawn } = require('child_process');
const fs = require('fs');

const chromePath = 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe';

console.log('Testing Chrome Headless against http://localhost:3000 and http://localhost:56855...');

try {
  const dom3000 = execSync(`"${chromePath}" --headless=new --dump-dom "http://localhost:3000"`, {
    maxBuffer: 10 * 1024 * 1024,
    timeout: 15000,
  }).toString();

  console.log('[Chrome Browser Test: Port 3000 React Web]');
  console.log('- Total DOM length:', dom3000.length);
  console.log('- Contains brand "CILULATAKS":', dom3000.includes('CILULATAKS'));
  console.log('- Contains user "Sarah Pratama":', dom3000.includes('Sarah Pratama'));
  console.log('- Contains quick action "Buat Tugas Baru":', dom3000.includes('Buat Tugas Baru'));
  console.log('- Contains active tasks card:', dom3000.includes('Tugas Aktif'));
  console.log('- Contains approaching deadline:', dom3000.includes('Mendekati Batas Waktu'));
  console.log('- Contains bottom nav tabs:', dom3000.includes('Beranda') && dom3000.includes('Tugas'));

  fs.writeFileSync('c:\\T\\Cilalutask\\.agents\\teamwork\\teamwork_worker_m1\\chrome_dom_3000.html', dom3000);
  console.log('Saved Chrome DOM to chrome_dom_3000.html');
} catch (e) {
  console.error('Error dumping DOM 3000:', e.message);
}

try {
  const dom56855 = execSync(`"${chromePath}" --headless=new --dump-dom "http://localhost:56855"`, {
    maxBuffer: 10 * 1024 * 1024,
    timeout: 15000,
  }).toString();

  console.log('\n[Chrome Browser Test: Port 56855 Flutter Web]');
  console.log('- Total DOM length:', dom56855.length);
  console.log('- Contains flutter_bootstrap.js:', dom56855.includes('flutter_bootstrap.js'));
  console.log('- Title:', dom56855.match(/<title>(.*?)<\/title>/)?.[1]);

  fs.writeFileSync('c:\\T\\Cilalutask\\.agents\\teamwork\\teamwork_worker_m1\\chrome_dom_56855.html', dom56855);
  console.log('Saved Chrome DOM to chrome_dom_56855.html');
} catch (e) {
  console.error('Error dumping DOM 56855:', e.message);
}

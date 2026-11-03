const { spawn } = require('child_process');
const http = require('http');

const chromePath = 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe';

async function wait(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function getWsUrl(port) {
  for (let i = 0; i < 20; i++) {
    try {
      const res = await fetch(`http://127.0.0.1:${port}/json/version`);
      const data = await res.json();
      if (data.webSocketDebuggerUrl) {
        return data.webSocketDebuggerUrl;
      }
    } catch (e) {
      // wait
    }
    await wait(500);
  }
  throw new Error('Chrome remote debugging WebSocket not available');
}

async function runBrowserInteractiveTest() {
  console.log('Launching Chrome with remote debugging on port 9222...');
  const tmpDir = 'C:\\Users\\HP\\AppData\\Local\\Temp\\chrome_dev_qa';
  const chromeProcess = spawn(chromePath, [
    '--headless=new',
    '--remote-debugging-port=9222',
    `--user-data-dir=${tmpDir}`,
    '--disable-gpu',
    '--no-sandbox',
    'http://localhost:3000',
  ]);

  try {
    const wsUrl = await getWsUrl(9222);
    console.log('Connected to Chrome DevTools WebSocket:', wsUrl);

    // Open target page
    const listRes = await fetch('http://127.0.0.1:9222/json/list');
    const pages = await listRes.json();
    const appPage = pages.find((p) => p.url.includes('localhost:3000')) || pages[0];
    console.log('Target Page ID:', appPage.id, 'URL:', appPage.url);

    const ws = new WebSocket(appPage.webSocketDebuggerUrl);

    let id = 1;
    const callbacks = new Map();

    ws.onmessage = (event) => {
      const msg = JSON.parse(event.data);
      if (msg.id && callbacks.has(msg.id)) {
        callbacks.get(msg.id)(msg);
        callbacks.delete(msg.id);
      }
    };

    await new Promise((resolve) => {
      ws.onopen = resolve;
    });

    function sendCommand(method, params = {}) {
      return new Promise((resolve) => {
        const cmdId = id++;
        callbacks.set(cmdId, resolve);
        ws.send(JSON.stringify({ id: cmdId, method, params }));
      });
    }

    // Enable Page and Runtime
    await sendCommand('Page.enable');
    await sendCommand('Runtime.enable');
    await sendCommand('DOM.enable');

    console.log('CDP initialized. Evaluating UI interaction in browser...');

    // Helper to evaluate JS in page
    async function evalInPage(expr) {
      const res = await sendCommand('Runtime.evaluate', {
        expression: expr,
        returnByValue: true,
        awaitPromise: true,
      });
      return res.result?.result?.value;
    }

    // Wait for React to mount
    await wait(2000);

    // 1. Verify Initial Screen is Beranda
    const initialTitle = await evalInPage('document.querySelector("header h1, header span.capitalize")?.textContent');
    console.log('Initial Tab Title:', initialTitle);

    // 2. Click "Tugas" bottom nav tab
    await evalInPage(`
      const buttons = Array.from(document.querySelectorAll('nav button'));
      const tugasBtn = buttons.find(b => b.textContent.includes('Tugas'));
      if (tugasBtn) tugasBtn.click();
    `);
    await wait(1000);

    const tugasSubTitle = await evalInPage('document.querySelector("header span.capitalize")?.textContent');
    console.log('After clicking Tugas nav -> Header subtitle:', tugasSubTitle);

    const tugasCardsCount = await evalInPage('document.querySelectorAll(".space-y-3 > div").length');
    console.log('Tugas Screen rendered task cards count:', tugasCardsCount);

    // 3. Test Task Search filter
    await evalInPage(`
      const input = document.querySelector('input[placeholder*="Cari tugas"]');
      if (input) {
        input.value = 'Aurora';
        input.dispatchEvent(new Event('input', { bubbles: true }));
      }
    `);
    await wait(500);
    const searchResultText = await evalInPage('document.body.innerText.includes("Aurora")');
    console.log('Search filter for "Aurora" matches:', searchResultText);

    // 4. Click "SOP" bottom nav tab
    await evalInPage(`
      const buttons = Array.from(document.querySelectorAll('nav button'));
      const sopBtn = buttons.find(b => b.textContent.includes('SOP'));
      if (sopBtn) sopBtn.click();
    `);
    await wait(1000);

    const sopHeader = await evalInPage('document.querySelector("header span.capitalize")?.textContent');
    console.log('After clicking SOP nav -> Header subtitle:', sopHeader);
    const urgentBannerVisible = await evalInPage('document.body.innerText.includes("WAJIB DIBACA")');
    console.log('Urgent mandatory SOP banner displayed in browser:', urgentBannerVisible);

    // 5. Click "Laporan" bottom nav tab
    await evalInPage(`
      const buttons = Array.from(document.querySelectorAll('nav button'));
      const lapBtn = buttons.find(b => b.textContent.includes('Laporan'));
      if (lapBtn) lapBtn.click();
    `);
    await wait(1000);

    const completionRateMetric = await evalInPage(`
      const text = document.body.innerText;
      text.includes('92.4%') && text.includes('88%') && text.includes('1.8');
    `);
    console.log('Laporan screen displays 92.4% completion rate and sub-metrics:', completionRateMetric);

    // 6. Click "Tim & Notif" bottom nav tab
    await evalInPage(`
      const buttons = Array.from(document.querySelectorAll('nav button'));
      const timBtn = buttons.find(b => b.textContent.includes('Tim'));
      if (timBtn) timBtn.click();
    `);
    await wait(1000);

    const timMembersCount = await evalInPage('document.querySelectorAll(".space-y-2\\\\.5 > div").length');
    console.log('Team screen rendered employee cards:', timMembersCount);

    // Switch to Notif subtab
    await evalInPage(`
      const subtabs = Array.from(document.querySelectorAll('button'));
      const notifBtn = subtabs.find(b => b.textContent.includes('Notif'));
      if (notifBtn) notifBtn.click();
    `);
    await wait(1000);

    const notifsCount = await evalInPage('document.body.innerText.includes("Tandai Semua Dibaca")');
    console.log('Notification center rendered with mark-as-read action:', notifsCount);

    ws.close();
    console.log('CDP browser interaction test completed successfully!');
  } finally {
    chromeProcess.kill();
  }
}

runBrowserInteractiveTest().catch((e) => {
  console.error('Browser interactive test failed:', e);
});

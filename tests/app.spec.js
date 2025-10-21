const { test, expect, _electron: electron } = require('@playwright/test');
const path = require('path');

const electronBinary = process.env.ELECTRON_BINARY || require('electron');

const appRoot = path.join(__dirname, '..');

async function launchElectron() {
  return electron.launch({
    executablePath: typeof electronBinary === 'string' ? electronBinary : undefined,
    args: [appRoot],
    env: {
      ...process.env,
      ELECTRON_DISABLE_SANDBOX: '1'
    }
  });
}

test.describe('Electron renderer', () => {
  test('displays welcome message and status', async () => {
    const electronApp = await launchElectron();
    const window = await electronApp.firstWindow();

    await expect(window.locator('#app-title')).toHaveText('Playwright + Electron');
    await expect(window.locator('#status-message')).toHaveText('Renderer process booted successfully.');

    const description = await window.locator('#app-description').textContent();
    expect(description).toContain('Playwright Electron Sandbox');

    await electronApp.close();
  });
});

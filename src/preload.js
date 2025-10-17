const { contextBridge } = require('electron');

contextBridge.exposeInMainWorld('appInfo', {
  name: 'Playwright Electron Sandbox',
  version: '0.1.0'
});

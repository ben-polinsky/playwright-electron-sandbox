const title = document.getElementById('app-title');
const description = document.getElementById('app-description');

if (window.appInfo) {
  description.textContent = `Welcome to ${window.appInfo.name} v${window.appInfo.version}!`;
}

window.addEventListener('DOMContentLoaded', () => {
  const status = document.createElement('p');
  status.id = 'status-message';
  status.textContent = 'Renderer process booted successfully.';
  document.querySelector('main').appendChild(status);
});

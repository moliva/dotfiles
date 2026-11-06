// Raise the Chrome window that holds a tab and make that tab the active one.
// Usage: osascript -l JavaScript focus.js <window id> <tab id>
// Ids, not indexes: tabs move and close between listing and selecting.
function run(argv) {
  const winId = Number(argv[0]);
  const tabId = Number(argv[1]);
  const chrome = Application("Google Chrome");
  for (const win of chrome.windows()) {
    if (win.id() !== winId) continue;
    const index = win.tabs.id().indexOf(tabId);
    if (index < 0) break;
    win.activeTabIndex = index + 1;
    win.index = 1;
    chrome.activate();
    return;
  }
  throw new Error("That tab is no longer open");
}

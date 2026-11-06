// Raise the Chrome window that holds a tab and make that tab the active one.
// Usage: osascript -l JavaScript focus.js <window id> <tab id>
// Ids, not indexes: tabs move and close between listing and selecting. Looked up
// with the same bulk id queries tabs.py lists with, compared as strings.
function run(argv) {
  const winId = String(argv[0]);
  const tabId = String(argv[1]);
  const chrome = Application("Google Chrome");
  const windows = chrome.windows;
  const winIds = windows.id().map(String);
  const w = winIds.indexOf(winId);
  if (w < 0) {
    throw new Error(`window ${winId} is gone (open: ${winIds.join(",")})`);
  }
  const win = windows[w];
  const tabIds = win.tabs.id().map(String);
  const t = tabIds.indexOf(tabId);
  if (t < 0) {
    throw new Error(`tab ${tabId} is gone from window ${winId} (has: ${tabIds.join(",")})`);
  }
  win.activeTabIndex = t + 1;
  win.index = 1;
  chrome.activate();
}

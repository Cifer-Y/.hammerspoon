-- local menubar = hs.menubar.new()
-- menubar:setIcon("flash.pdf")
-- menubar:setMenu({
--   { title = "Reload", fn = hs.reload },
--   { title = "Console", fn = hs.openConsole },
-- })

local hyper = {"alt", "ctrl"}

-- undo
local undo = require 'undo'
hs.hotkey.bind(hyper, 'u', function()
  undo:undo()
end)


-- Maximize
hs.hotkey.bind(hyper, "o", function ()
  -- hs.grid.maximizeWindow()
  local win = hs.window.focusedWindow()
  if not win or win:isFullScreen() then
    return
  end
  undo:addToStack()
  win:maximize()
end)


-- left half
hs.hotkey.bind(hyper, "left", function()
  local win = hs.window.focusedWindow()
  if not win or win:isFullScreen() then
    return
  end
  local screenrect = win:screen():frame()
  local f = win:frame()
  f.x = 0
  f.y = 0
  f.w = screenrect.w / 2
  f.h = screenrect.h
  undo:addToStack()
  win:setFrame(f)
end)


-- right half
hs.hotkey.bind(hyper, "right", function()
  local win = hs.window.focusedWindow()
  if not win or win:isFullScreen() then
    return
  end
  local screenrect = win:screen():frame()
  local f = win:frame()
  f.x = screenrect.w / 2
  f.y = 0
  f.w = screenrect.w / 2
  f.h = screenrect.h
  undo:addToStack()
  win:setFrame(f)
end)


-- top half
hs.hotkey.bind(hyper, "up", function ()
  local win = hs.window.focusedWindow()
  if not win or win:isFullScreen() then
    return
  end
  local screenrect = win:screen():frame()
  local f = win:frame()
  f.x = 0
  f.y = 0
  f.w = screenrect.w
  f.h = screenrect.h / 2
  undo:addToStack()
  win:setFrame(f)
end)


-- below half
hs.hotkey.bind(hyper, "down", function()
  local win = hs.window.focusedWindow()
  if not win or win:isFullScreen() then
    return
  end
  local screenrect = win:screen():frame()
  local f = win:frame()
  f.x = 0
  f.y = screenrect.h / 2 + 23
  f.w = screenrect.w
  f.h = screenrect.h / 2
  undo:addToStack()
  win:setFrame(f)
end)


local apps = {
  q = 'QQ',
  g = "Google Chrome",
  k = "Slack",
  i = "iTerm",
  f = "finder",
  --e = "Emacs",
  w = "WeChat",
  t = "Telegram",
  p = "Preview"
}

apps["1"] = "1Password"

for key, name in pairs(apps) do
  hs.hotkey.bind(hyper, key, function()
    hs.application.launchOrFocus(name)
    moveCursorToWindowCenter()
  end)
end

hs.hints.showTitleThresh = 0
hs.hotkey.bind(hyper, "l", function()
  local qq = hs.appfinder.appFromName("QQ")
  hs.hints.windowHints(table.insert({}, qq))
end)

function moveCursorToWindowCenter()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  hs.mouse.setAbsolutePosition({
      x = f.x + f.w / 2,
      y = f.y + f.h / 2,
  })
end


hs.hotkey.bind(hyper, "0", function()
  local apps = {
    { name = 'Slack',            x = 0,    y = 0,    w = 1080,  h = 600 },
    { name = 'Telegram',            x = 0,    y = 600,    w = 1080,  h = 600 },
    { name = 'QQ',               x = 0,    y = 1200,  w = 1080,  h = 660 },
  }
  for _, app in pairs(apps) do
    local a = hs.appfinder.appFromName(app.name)
    if a ~= nil then
      local w = a:mainWindow()
      local f = w:frame()

      f.x = app.x
      f.y = app.y
      f.w = app.w
      f.h = app.h
      w:setFrame(f)
    end
  end
end)

hs.hotkey.bind(hyper, "e", function()
  local app = hs.appfinder.appFromName("Emacs")
  if app == nil then return end
  app:activate()
  moveCursorToWindowCenter()
end)


function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")

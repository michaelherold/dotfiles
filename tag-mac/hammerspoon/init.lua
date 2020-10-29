function reloadConfig(files)
  doReload = false

  for _, file in pairs(files) do
    if (file:sub(-4) == ".lua") then
      hs.console.printStyledtext("yo")
      hs.console.printStyledtext(file)
      hs.console.printStyledtext("yo")
      doReload = true
    end
  end

  if doReload then
    hs.reload()
  end
end

function halfLeft()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h

  win:setFrame(f)
end

function halfRight()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + max.w / 2 + 5
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h

  win:setFrame(f)
end

function fullscreen()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + 2
  f.y = max.y
  f.w = max.w
  f.h = max.h

  win:setFrame(f)
end

hs.hotkey.bind({"cmd", "ctrl"}, "h", halfLeft)
hs.hotkey.bind({"cmd", "ctrl"}, "Left", halfLeft)
hs.hotkey.bind({"cmd", "ctrl"}, "l", halfRight)
hs.hotkey.bind({"cmd", "ctrl"}, "Right", halfRight)
hs.hotkey.bind({"cmd", "ctrl"}, "f", fullscreen)

configWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()

hs.alert.show("Hammerspoon reloaded")

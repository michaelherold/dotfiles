hs.spoons.use(
  "ReloadConfiguration",
  {
    config = {
      watch_paths = {
        dotHammerspoon = hs.configdir,
        dotfilesTag = os.getenv("HOME") .. "/code/dotfiles/tag-mac/hammerspoon/"
      }
    },
    hotkeys = {
      reloadConfiguration = {{"cmd", "ctrl"}, "r"}
    },
    start = true,
  }
)

hs.alert.show("Hammerspoon reloaded")

function halfTop()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w
  f.h = max.h / 2

  win:setFrame(f)
end


function halfBottom()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y + max.h / 2 + 5
  f.w = max.w
  f.h = max.h / 2

  win:setFrame(f)
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

hs.hotkey.bind({"cmd", "ctrl"}, "k", halfTop)
hs.hotkey.bind({"cmd", "ctrl"}, "Up", halfTop)
hs.hotkey.bind({"cmd", "ctrl"}, "j", halfBottom)
hs.hotkey.bind({"cmd", "ctrl"}, "Down", halfBottom)
hs.hotkey.bind({"cmd", "ctrl"}, "h", halfLeft)
hs.hotkey.bind({"cmd", "ctrl"}, "Left", halfLeft)
hs.hotkey.bind({"cmd", "ctrl"}, "l", halfRight)
hs.hotkey.bind({"cmd", "ctrl"}, "Right", halfRight)
hs.hotkey.bind({"cmd", "ctrl"}, "f", fullscreen)

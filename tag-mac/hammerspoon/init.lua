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
      reloadConfiguration = {{"cmd", "ctrl"}, "c"}
    },
    start = true,
  }
)

hs.alert.show("Hammerspoon reloaded")

hs.spoons.use(
  "AudioDeviceManagement",
  {
    config = {
      deviceNames = { "MacBook Pro Speakers", "ATR USB microphone" },
    },
    hotkeys = { switchAudioDevice = {{}, "f19"} },
    start = true,
  }
)

hs.spoons.use(
  "DarkMode",
  {
    config = {
      handlers = {
      },
    },
    hotkeys = { toggle = {{}, "f18"}  },
    start = true,
  }
)

hs.spoons.use(
  "WindowManagement",
  {}
)

--- Utility bindings
-- hs.hotkey.bind({"cmd", "ctrl"}, "z", hs.toggleConsole)

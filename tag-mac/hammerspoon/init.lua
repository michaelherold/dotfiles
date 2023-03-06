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

hs.spoons.use(
  "AudioDeviceManagement",
  {
    config = {
      device_names = { "MacBook Pro Speakers", "ATR USB microphone" },
    },
    hotkeys = { switchAudioDevice = {{}, "f19"} },
    start = true,
  }
)

hs.spoons.use(
  "WindowManagement",
  {}
)

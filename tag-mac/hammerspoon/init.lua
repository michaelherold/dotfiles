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
      device_names = { "MacBook Pro Speakers", "ATR USB microphone" },
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
        function(mode)
          local theme

          if mode == "light" then theme = "Solarized Light"
          else theme = "Snazzy"
          end

          hs.execute("kitty +kitten themes --reload-in=all '" .. theme .. "'", true)
        end,
        function(mode)
          hs.execute("tmux source-file ~/.config/tmux/" .. mode .. ".conf", true)
        end,
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

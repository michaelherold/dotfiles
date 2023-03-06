--- === AudioDeviceManagement ===
---
--- Adds hotkeys for changing audio devices.
---
--- Download: [https://github.com/michaelherold/dotfiles/raw/main/tag-mac/hammerspoon/Spoons/AudioDeviceManagement.spoon](https://github.com/michaelherold/dotfiles/raw/main/tag-mac/hammerspoon/Spoons/AudioDeviceManagement.spoon)
---
--- Note: This works well enough for my purposes right now but I wouldn't recommend use by anyone else!

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "AudioDeviceManagement"
obj.version = "1.0"
obj.author = "Michael Herold <opensource@michaeljherold.com"
obj.homepage = "https://github.com/michaelherold/dotfiles/tag-mac/hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.device_names = {}

function obj:start()
  self.devices = {}

  for idx, device_name in pairs(self.device_names) do
    local device = hs.audiodevice.findOutputByName(device_name)

    if device ~= nil then
      self.devices[idx] = device_name
    else
      print("  Warning: could not find device " .. device_name .. ", skipping")
    end
  end

  return self
end

--- AudioDeviceManagement:bindHotkeys(mapping)
--- Method
--- Binds hotkeys for AudioDeviceManagement
---
--- Parameters:
---  * mapping - A table containing hotkey modifier/key details for the following items:
---   * switchAudioDevice - This will switch the audio device to the opposing one
function obj:bindHotkeys(mapping)
  local def = { switchAudioDevice = hs.fnutils.partial(switchAudioDevice, self) }
  hs.spoons.bindHotkeysToSpec(def, mapping)
end

--- Switches audio output device between the MacBook Pro speakers and my microphone feed
function switchAudioDevice()
  if not next(obj.devices) then return end

  local needsHandling = false

  for _, device_name in pairs(obj.devices) do
    device = hs.audiodevice.findOutputByName(device_name)

    if device and needsHandling then
      device:setDefaultOutputDevice()
      hs.alert.show("Output: " .. device:name())
      needsHandling = false
      break
    elseif device and device:inUse() then
      needsHandling = true
    end
  end

  -- Toggling back to the first output in the list
  if needsHandling then
    device = hs.audiodevice.findOutputByName(obj.devices[1])
    device:setDefaultOutputDevice()
    hs.alert.show("Output: " .. device:name())
  end
end

return obj

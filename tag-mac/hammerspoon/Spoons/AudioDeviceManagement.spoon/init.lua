--- === AudioDeviceManagement ===
---
--- Adds hotkeys for changing audio devices.
---
--- Download: [https://github.com/michaelherold/dotfiles/raw/main/tag-mac/hammerspoon/Spoons/AudioDeviceManagement.spoon](https://github.com/michaelherold/dotfiles/raw/main/tag-mac/hammerspoon/Spoons/AudioDeviceManagement.spoon)
---
--- Note: This works well enough for my purposes right now but I wouldn't recommend use by anyone else!

local log = require("hs.logger").new("audio", "info")
local obj = {}
obj.__index = obj

-- Metadata
obj.name = "AudioDeviceManagement"
obj.version = "1.1"
obj.author = "Michael Herold <opensource@michaeljherold.com"
obj.homepage = "https://github.com/michaelherold/dotfiles/tag-mac/hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.deviceNames = {}
obj.getLogLevel = log.getLogLevel
obj.setLogLevel = log.setLogLevel

function obj:start()
  self.devices = {}

  for idx, deviceName in pairs(self.deviceNames) do
    local device = hs.audiodevice.findOutputByName(deviceName)

    if device ~= nil then
      self.devices[idx] = deviceName
    else
      log.wf("could not find device %s, skipping", deviceName)
    end
  end

  return self
end

--- AudioDeviceManagement:bindHotkeys(mapping)
--- Method
--- Binds hotkeys for AudioDeviceManagement
---
--- Parameters:
---   * mapping - A table containing hotkey modifier/key details for the following items:
---   * switchAudioDevice - This will switch the audio device to the opposing one
function obj:bindHotkeys(mapping)
  local def = { switchAudioDevice = hs.fnutils.partial(switchAudioDevice, self) }
  hs.spoons.bindHotkeysToSpec(def, mapping)
end

--- Toggles the next audio device in the list after the current device as the default
function switchAudioDevice()
  if not next(obj.devices) then return end

  local needsHandling = false
  local defaultDevice = hs.audiodevice.defaultOutputDevice()
  local defaultDeviceName = nil

  if defaultDevice ~= nil then
    defaultDeviceName = defaultDevice:name()
  end

  -- Iterate through until we find the current default device, then enabling the
  -- toggle behavior for the next device
  for idx, deviceName in pairs(obj.devices) do
    device = hs.audiodevice.findOutputByName(deviceName)

    if device and needsHandling then
      toggleDeviceAsDefault(device)
      needsHandling = false
      break
    elseif device and deviceName == defaultDeviceName then
      needsHandling = true
    end
  end

  -- Toggling back to the first output in the list
  if needsHandling then
    device = hs.audiodevice.findOutputByName(obj.devices[1])

    toggleDeviceAsDefault(device)
  end
end

--- Toggles a device as the default output and shows an alert, when present
---
--- Parameters:
---   * device - device or nil
function toggleDeviceAsDefault(device)
  if device ~= nil then
    device:setDefaultOutputDevice()
    hs.alert.show("Output: " .. device:name())
  else
    log.wf("No device to toggle")
  end
end

return obj

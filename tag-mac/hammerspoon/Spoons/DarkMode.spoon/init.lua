--- === DarkMode ===
---
--- Adds support for reacting to dark mode changes.
---
--- Download: [https://github.com/michaelherold/dotfiles/raw/main/tag-mac/hammerspoon/Spoons/DarkMode.spoon](https://github.com/michaelherold/dotfiles/raw/main/tag-mac/hammerspoon/Spoons/DarkMode.spoon)

local obj = {}
obj.__index = obj

obj.name = "DarkMode"
obj.version = "0.1.0"
obj.author = "Michael Herold <opensource@michaeljherold.com>"
obj.homepage = "https://github.com/michaelherold/dotfiles/tag-mac/hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

--- DarkMode.currentMode
--- Variable
--- Indicates the current mode that Hammerspoon knows the OS to be in. One of
--- "light", "dark", or nil.
obj.currentMode = nil

--- DarkMode.handlers
--- Variable
--- A list of functions to run when transitioning between modes. They receive
--- either "light" or "dark" as an argument.
obj.handlers = {}

--- DarkMode:bindHotkeys(mapping)
--- Method
--- Binds hotkeys for DarkMode
---
--- Parameters:
---  * mapping - A table containing hotkey modifier/key details for the following items:
---   * toggle - This will toggle dark mode on or off
function obj:bindHotkeys(mapping)
	local def = { toggle = hs.fnutils.partial(obj.toggle, self) }

	hs.spoons.bindHotkeysToSpec(def, mapping)
end

--- DarkMode:currentMode()
--- Method
--- Gets the current mode for the operating system. Returns "light" or "dark".
function obj:getCurrentMode()
	local _, enabled = hs.osascript.javascript(
		"Application('System Events').appearancePreferences.darkMode.get()"
	)

	if enabled then
		return "dark"
	else
		return "light"
	end
end

--- DarkMode:start()
--- Method
--- Start DarkMode
---
--- Parameters:
---   * None
function obj:start()
	self.currentMode = obj:getCurrentMode()
	self.watcher = hs.distributednotifications.new(
		function(name, object, userInfo)
			local currentMode = obj:getCurrentMode()

			if currentMode ~= self.currentMode then
				self.currentMode = currentMode

				for _, fn in ipairs(obj.handlers) do; fn(currentMode); end
			end
		end,
		"AppleInterfaceThemeChangedNotification"
	)

  self.watcher:start()
end

--- DarkMode:toggle()
--- Method
--- Toggles dark mode on or off in the operating system.
---
--- Parameters:
---   * None
function obj:toggle()
	local cmd = string.format(
		"Application('System Events').appearancePreferences.darkMode.set(%s)",
		obj.currentMode ~= "dark"
	)

	hs.osascript.javascript(cmd)
end

return obj

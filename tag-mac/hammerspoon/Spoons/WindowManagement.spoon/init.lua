--- === WindowManagement ===
---
--- Adds hotkeys for moving windows around.
---
--- Download: [https://github.com/michaelherold/dotfiles/raw/main/tag-mac/hammerspoon/Spoons/WindowManagement.spoon](https://github.com/michaelherold/dotfiles/raw/main/tag-mac/hammerspoon/Spoons/WindowManagement.spoon)

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "WindowManagement"
obj.version = "1.0"
obj.author = "Michael Herold <opensource@michaeljherold.com"
obj.homepage = "https://github.com/michaelherold/dotfiles/tag-mac/hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

function makeMap(name, mods, key)
  local map = hs.hotkey.modal.new(mods, key)

  function map:entered() hs.alert("Entered " .. name .. " mode") end
  function map:exited() hs.alert("Exited " .. name .. " mode") end

  map:bind("",       "escape", function () map:exit() end)
  map:bind({"ctrl"}, "g",      function () map:exit() end)
  map:bind(mods,     key,      function () map:exit() end)

  return map
end

-- Disable window animations
hs.window.animationDuration = 0

-- Unit rectangles for making changes to window frames
units = {
  fullscreen = hs.geometry(0.00, 0.00, 1.00, 1.00),
  quarter    = hs.geometry(nil, nil, 0.25, 0.25),

  left50     = hs.geometry(0.00, 0.00, 0.50, 1.00),
  right50    = hs.geometry(0.50, 0.00, 0.50, 1.00),
  top50      = hs.geometry(0.00, 0.00, 1.00, 0.50),
  bottom50   = hs.geometry(0.00, 0.50, 1.00, 0.50),
}

hs.hotkey.bind({"cmd", "ctrl"}, "f", function () resizeToUnit(units.fullscreen) end)

-- Move and resize windows to halves of the screen
hs.hotkey.bind({"cmd", "ctrl"}, "h",     function () resizeToUnit(units.left50) end)
hs.hotkey.bind({"cmd", "ctrl"}, "j",     function () resizeToUnit(units.bottom50) end)
hs.hotkey.bind({"cmd", "ctrl"}, "k",     function () resizeToUnit(units.top50) end)
hs.hotkey.bind({"cmd", "ctrl"}, "l",     function () resizeToUnit(units.right50) end)
hs.hotkey.bind({"cmd", "ctrl"}, "left",  function () resizeToUnit(units.left50) end)
hs.hotkey.bind({"cmd", "ctrl"}, "down",  function () resizeToUnit(units.bottom50) end)
hs.hotkey.bind({"cmd", "ctrl"}, "up",    function () resizeToUnit(units.top50) end)
hs.hotkey.bind({"cmd", "ctrl"}, "right", function () resizeToUnit(units.right50) end)

-- Grow or shrink windows by a quarter of the screen
obj.resizeMap = makeMap("resize", {"cmd", "ctrl"}, "r")
obj.resizeMap:bind("", "h",     function () changeByUnit(units.quarter, "W") end)
obj.resizeMap:bind("", "j",     function () changeByUnit(units.quarter, "S") end)
obj.resizeMap:bind("", "k",     function () changeByUnit(units.quarter, "N") end)
obj.resizeMap:bind("", "l",     function () changeByUnit(units.quarter, "E") end)
obj.resizeMap:bind("", "left",  function () changeByUnit(units.quarter, "W") end)
obj.resizeMap:bind("", "down",  function () changeByUnit(units.quarter, "S") end)
obj.resizeMap:bind("", "up",    function () changeByUnit(units.quarter, "N") end)
obj.resizeMap:bind("", "right", function () changeByUnit(units.quarter, "E") end)

-- Move windows by a quarter of the screen
obj.moveMap = makeMap("movement", {"cmd", "ctrl"}, "m")
obj.moveMap:bind("", "h",     function () moveFocusedByUnit(units.quarter, "W") end)
obj.moveMap:bind("", "j",     function () moveFocusedByUnit(units.quarter, "S") end)
obj.moveMap:bind("", "k",     function () moveFocusedByUnit(units.quarter, "N") end)
obj.moveMap:bind("", "l",     function () moveFocusedByUnit(units.quarter, "E") end)
obj.moveMap:bind("", "left",  function () moveFocusedByUnit(units.quarter, "W") end)
obj.moveMap:bind("", "down",  function () moveFocusedByUnit(units.quarter, "S") end)
obj.moveMap:bind("", "up",    function () moveFocusedByUnit(units.quarter, "N") end)
obj.moveMap:bind("", "right", function () moveFocusedByUnit(units.quarter, "E") end)

--- Change a frame by a particular unit rectangle.
-- Growth happens to the east and south.
-- Contraction happens to the north and west.
--
-- @param unitRect The unit rectange to set for the frame
-- @param direction The direction to move, one of "N", "E", "S", or "W"
-- @param window The window to change, defaulting to the currently focused window
function changeByUnit(unitRect, direction, window)
  window = window or hs.window.focusedWindow()
  local result = frameToUnitFrame(window:frame())

  if direction == "N" then
    result.h = result.h - unitRect.h
  elseif direction == "E" then
    result.w = result.w + unitRect.w
  elseif direction == "S" then
    result.h = result.h + unitRect.h
  elseif direction == "W" then
    result.w = result.w - unitRect.w
  end

  result.w = clamp(result.w, 0.25, 1.00)
  result.h = clamp(result.h, 0.25, 1.00)

  resizeToUnit(result, window)
end

--- Clamps a number x between a min and max value.
--
-- @param x The value to clamp
-- @param min The minimum of the clamp range
-- @param max The maximum of the clamp range
--
-- @return The clamped value
function clamp(x, min, max)
  if x <= min then x = min end
  if x >= max then x = max end

  return x
end

--- Translates a frame from screen space to unit space.
--
-- @param frame The frame to translate
--
-- @return The frame translated to a unit rectange
function frameToUnitFrame(frame)
  local bounds = hs.window.focusedWindow():screen():frame()
  local result = hs.geometry(
    (frame.x - bounds.x) / bounds.w,
    (frame.y - bounds.y) / bounds.h,
    frame.w / bounds.w,
    frame.h / bounds.h
  )

  return result
end

--- Moves a frame by a particular unit rectangle.
--
-- @param unitRect The unit rectange to set for the frame
-- @param direction The direction to move, one of "N", "E", "S", or "W"
-- @param window The window to move, defaulting to the currently focused window
function moveFocusedByUnit(unitRect, direction, window)
  window = window or hs.window.focusedWindow()
  local result = frameToUnitFrame(window:frame())

  if direction == "N" then
    result.y = result.y - unitRect.h
  elseif direction == "E" then
    result.x = result.x + unitRect.w
  elseif direction == "S" then
    result.y = result.y + unitRect.h
  elseif direction == "W" then
    result.x = result.x - unitRect.w
  end

  result.x = clamp(result.x, 0, 1)
  result.y = clamp(result.y, 0, 1)

  resizeToUnit(result, window)
end

--- Moves a frame to a particular unit rectangle.
--
-- @param unitRect The unit rectange to set for the frame
-- @param frame The focused frame, defaulting to the currently focused window
function resizeToUnit(unitRect, window)
  window = window or hs.window.focusedWindow()

  window:move(unitRect, nil, true)
end

return obj

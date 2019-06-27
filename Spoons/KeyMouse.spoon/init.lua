-- Control mouse by keyboard
local obj={}
obj.__index = obj

-- Metadata
obj.name = "KeyMouse"
obj.version = "0.1"
obj.author = "Long Changjin"
obj.homepage = ""
obj.license = ""

obj.logger = hs.logger.new('KeyMouse')

obj.defaultHotkeys = {
   move_left    = { {"shift", "alt"}, 'h' },
   move_right   = { {"shift", "alt"}, 'l' },
   move_up      = { {"shift", "alt"}, 'k' },
   move_down    = { {"shift", "alt"}, 'j' },
   scroll_left   = { {"shift", "alt"}, 'y' },
   scroll_right  = { {"shift", "alt"}, 'o' },
   scroll_up     = { {"shift", "alt"}, 'i' },
   scroll_down   = { {"shift", "alt"}, 'u' },
   click_left   = { {"shift", "alt"}, ',' },
   click_middle   = { {"shift", "alt"}, '.' },
   click_right   = { {"shift", "alt"}, '/' },
}

function obj.moveMouse(direct)
  local currentpos = hs.mouse.getAbsolutePosition()
  local step = 10
  if direct == 'left' then
    currentpos.x = currentpos.x - step
  elseif direct == 'right' then
    currentpos.x = currentpos.x + step
  elseif direct == 'up' then
    currentpos.y = currentpos.y - step
  elseif direct == 'down' then
    currentpos.y = currentpos.y + step
  end
  hs.mouse.setAbsolutePosition(currentpos)
end

function obj.scrollMouse(direct)
  local offset = {0, 0}
  local step = 3
  if direct == 'left' then
    offset[1] = offset[1] + step
  elseif direct == 'right' then
    offset[1] = offset[1] - step
  elseif direct == 'up' then
    offset[2] = offset[2] + step
  elseif direct == 'down' then
    offset[2] = offset[2] - step
  end
  return true, {hs.eventtap.event.newScrollEvent(offset, {}, "line")}
end

function obj.clickMouse(button)
  local currentpos = hs.mouse.getAbsolutePosition()
  local fn = button .. 'Click'
  return true, {hs.eventtap[fn](currentpos)}
end

obj.moveMouseLeft     = hs.fnutils.partial(obj.moveMouse, 'left')
obj.moveMouseRight    = hs.fnutils.partial(obj.moveMouse, 'right')
obj.moveMouseUp       = hs.fnutils.partial(obj.moveMouse, 'up')
obj.moveMouseDown     = hs.fnutils.partial(obj.moveMouse, 'down')
obj.scrollMouseLeft   = hs.fnutils.partial(obj.scrollMouse, 'left')
obj.scrollMouseRight  = hs.fnutils.partial(obj.scrollMouse, 'right')
obj.scrollMouseUp     = hs.fnutils.partial(obj.scrollMouse, 'up')
obj.scrollMouseDown   = hs.fnutils.partial(obj.scrollMouse, 'down')
obj.clickLeft         = hs.fnutils.partial(obj.clickMouse, 'left')
obj.clickMiddle       = hs.fnutils.partial(obj.clickMouse, 'middle')
obj.clickRight        = hs.fnutils.partial(obj.clickMouse, 'right')

function obj:bindHotkeys(mapping)
  if mapping then
    -- change hot keys
    for name, keyspec in pairs(mapping) do
      if self.defaultHotkeys[name] then
        self.defaultHotkeys[name] = keyspec
      end
    end
  end
  local action_to_method_map = {
    move_left = self.moveMouseLeft,
    move_right = self.moveMouseRight,
    move_up = self.moveMouseUp,
    move_down = self.moveMouseDown,
  }
  for name, keyspec in pairs(self.defaultHotkeys) do
    local fn = action_to_method_map[name]
    if fn then
      hs.hotkey.bindSpec(keyspec, nil, fn, fn, nil)
    end
  end
  -- hs.spoons.bindHotkeysToSpec(action_to_method_map, self.defaultHotkeys)
  return self
end

function obj.catcher(event)
  local action_to_method_map = {
    scroll_left = obj.scrollMouseLeft,
    scroll_right = obj.scrollMouseRight,
    scroll_up = obj.scrollMouseUp,
    scroll_down = obj.scrollMouseDown,
    click_left = obj.clickLeft,
    click_middle = obj.clickMiddle,
    click_right = obj.clickRight,
  }
  local flags = event:getFlags()
  local keyCode = event:getKeyCode()

  -- for key, value in pairs(flags) do
  --   obj.logger.e('key press ' .. key .. ' ' .. event:getCharacters(true) .. hs.keycodes.map[keyCode])
  --   obj.logger.e(keyCode)
  -- end

  for name, keyspec in pairs(obj.defaultHotkeys) do
    local match = true
    if hs.keycodes.map[keyspec[2]] ~= keyCode then
      -- check key code
      match = false
    else
      for index, value in pairs(keyspec[1]) do
        -- check modifier keys
        if not flags[value] then
          match = false
          break
        end
      end
    end

    if match and action_to_method_map[name] then
      return action_to_method_map[name]()
    end
  end
end

function obj:init()
  self.fn_tapper = hs.eventtap.new({hs.eventtap.event.types.keyDown}, self.catcher)
end

function obj:start()
  if self.fn_tapper and (not self.fn_tapper:isEnabled()) then
    self.fn_tapper:start()
  end
end

function obj:stop()
  if self.fn_tapper and self.fn_tapper:isEnabled() then
    self.fn_tapper:stop()
  end
end

return obj

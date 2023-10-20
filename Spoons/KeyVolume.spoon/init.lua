-- Control Volume by keyboard
local obj={}
obj.__index = obj

-- Metadata
obj.name = "KeyVolume"
obj.version = "0.1"
obj.author = "Long Changjin"
obj.homepage = ""
obj.license = ""

obj.logger = hs.logger.new('KeyVolume')

obj.defaultHotkeys = {
  -- 调节音量
   volume_down    = { {"shift", "alt"}, 'q' },
   volume_up      = { {"shift", "alt"}, 'w' },
   volume_mute    = { {"shift", "alt"}, 'e' },
   -- switch_input_source = { {"shift", "alt"}, 'm' },     -- 切换输入法
}

function sendSystemKey(key)
  hs.eventtap.event.newSystemKeyEvent(key, true):post()
  hs.eventtap.event.newSystemKeyEvent(key, false):post()
end
obj.setVolumeUp = hs.fnutils.partial(sendSystemKey, "SOUND_UP")
obj.setVolumeDown = hs.fnutils.partial(sendSystemKey, "SOUND_DOWN")
obj.setMute = hs.fnutils.partial(sendSystemKey, "MUTE")

function switchInputSource()
  -- { '英文', 'com.apple.keylayout.ABC' },
  -- { '五笔', 'com.sogou.inputmethod.sogouWB.wubi' }
  local oldName = hs.keycodes.currentMethod()
  local newId = ''
  if not oldName then
    oldName = '英文'
    newId = 'com.sogou.inputmethod.sogouWB.wubi'
  else
    newId = 'com.apple.keylayout.ABC'
  end
  print('当前输入法' .. hs.keycodes.currentSourceID() .. oldName)

  print('切换到前输入法' .. newId)

  hs.keycodes.currentSourceID(newId)
  local newName = hs.keycodes.currentMethod()
  if not newName then
    newName = '英文'
  end
  hs.alert.show('switch from ' .. oldName .. ' to ' .. newName)
end

function obj:bindHotkeys(mapping)
  local action_to_method_map = {
    volume_up = self.setVolumeUp,
    volume_down = self.setVolumeDown,
    volume_mute = self.setMute,
    -- switch_input_source = switchInputSource
  }
 hs.spoons.bindHotkeysToSpec(action_to_method_map, mapping)
 return self
end

-- https://gist.github.com/amirrajan/ab15226a41f2ac0e4076faad954337f9
-- ==========================================
-- Right Shift
-- ==========================================
send_right_paren = false
right_paren_last_mods = {}

right_shift_key_handler = function()
   send_right_paren = false
end

right_shift_key_timer = hs.timer.delayed.new(0.15, right_shift_key_handler)

right_shift_handler = function(evt)
  if evt:getKeyCode() ~= hs.keycodes.map["rightshift"] then
    return
  end
  local new_mods = evt:getFlags()
  if right_paren_last_mods["shift"] == new_mods["shift"] then
    return false
  end
  if not right_paren_last_mods["shift"] then
    right_paren_last_mods = new_mods
    send_right_paren = true
    right_shift_key_timer:start()
  else
    if send_right_paren then
      -- 右shift 键切换输入法
      switchInputSource()
    end
    right_paren_last_mods = new_mods
    right_shift_key_timer:stop()
  end
  return false
end

right_shift_tap = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, right_shift_handler)

right_shift_other_handler = function(evt)
   send_right_paren = false
   return false
end
right_shift_other_tap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, right_shift_other_handler)

function obj:init()
  -- right shift 功能
  right_shift_tap:start()
  right_shift_other_tap:start()
end

return obj

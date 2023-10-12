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
   volume_down    = { {"shift", "alt"}, 'q' },
   volume_up      = { {"shift", "alt"}, 'w' },
   volume_mute    = { {"shift", "alt"}, 'e' },
   switch_input_source = { {"shift", "alt"}, 'm' },     -- 切换输入法
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
    switch_input_source = switchInputSource
  }
 hs.spoons.bindHotkeysToSpec(action_to_method_map, mapping)
 return self
end

function obj:init()
end

return obj

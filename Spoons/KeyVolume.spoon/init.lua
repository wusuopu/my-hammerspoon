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
}

function sendSystemKey(key)
  hs.eventtap.event.newSystemKeyEvent(key, true):post()
  hs.eventtap.event.newSystemKeyEvent(key, false):post()
end
obj.setVolumeUp = hs.fnutils.partial(sendSystemKey, "SOUND_UP")
obj.setVolumeDown = hs.fnutils.partial(sendSystemKey, "SOUND_DOWN")
obj.setMute = hs.fnutils.partial(sendSystemKey, "MUTE")

function obj:bindHotkeys(mapping)
  local action_to_method_map = {
    volume_up = self.setVolumeUp,
    volume_down = self.setVolumeDown,
    volume_mute = self.setMute,
  }
 hs.spoons.bindHotkeysToSpec(action_to_method_map, mapping)
 return self
end

function obj:init()
end

return obj

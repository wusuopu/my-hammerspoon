-- Control Volume by keyboard
local obj={}
obj.__index = obj

-- 将 table 序列化为字符串
function dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k,v in pairs(o) do
      if type(k) ~= 'number' then k = '"'..k..'"' end
      s = s .. '['..k..'] = ' .. dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

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
   switch_to_iterm    = { {"ctrl", "alt"}, 't' },         -- 切换到 iTerm
   switch_to_browser  = { {"ctrl", "alt"}, 'b' },         -- 切换到 Chrome
   switch_to_vscode  = { {"ctrl", "alt"}, 'v' },         -- 切换到 VSCode
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
    -- newId = 'com.sogou.inputmethod.sogouWB.wubi'
    -- newId = 'com.aodaren.inputmethod.Qingg'
    newId = 'com.baidu.inputmethod.BaiduIM.wubi'
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
function switchAppITerm()
  hs.osascript.applescript('tell application "iTerm" to activate')
end
function switchAppChrome()
  hs.osascript.applescript('tell application "Google Chrome" to activate')
end
function switchAppVSCode()
  hs.osascript.applescript('tell application "Visual Studio Code" to activate')
end

function obj:bindHotkeys(mapping)
  local action_to_method_map = {
    volume_up = self.setVolumeUp,
    volume_down = self.setVolumeDown,
    volume_mute = self.setMute,
    -- switch_input_source = switchInputSource,
    switch_to_iterm = switchAppITerm,
    switch_to_browser = switchAppChrome,
    switch_to_vscode = switchAppVSCode,
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

right_alt_key_handler = function()
   send_right_paren = false
end

right_alt_key_timer = hs.timer.delayed.new(0.15, right_alt_key_handler)

right_alt_handler = function(evt)
  if evt:getKeyCode() ~= hs.keycodes.map["rightalt"] then
    return
  end
  local new_mods = evt:getFlags()
  if right_paren_last_mods["alt"] == new_mods["alt"] then
    return false
  end
  if not right_paren_last_mods["alt"] then
    right_paren_last_mods = new_mods
    send_right_paren = true
    right_alt_key_timer:start()
  else
    if send_right_paren then
      -- 右alt 键切换输入法
      switchInputSource()
    end
    right_paren_last_mods = new_mods
    right_alt_key_timer:stop()
  end
  return false
end

right_alt_tap = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, right_alt_handler)

right_alt_other_handler = function(evt)
  send_right_paren = false
  return false
end
right_alt_other_tap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, right_alt_other_handler)

function obj:init()
  -- right alt 功能
  right_alt_tap:start()
  right_alt_other_tap:start()
end

return obj

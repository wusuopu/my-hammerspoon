-- Prevent the screen from going to sleep Download
hs.loadSpoon('Caffeine')
spoon.Caffeine:start()
spoon.Caffeine:clicked()

hs.loadSpoon('WindowHalfsAndThirds')
spoon.WindowHalfsAndThirds:bindHotkeys({
  left_half   = { {"cmd", "alt", "ctrl"}, "Left" },
  right_half  = { {"cmd", "alt", "ctrl"}, "Right" },
  top_half    = { {"cmd", "alt", "ctrl"}, "Up" },
  bottom_half = { {"cmd", "alt", "ctrl"}, "Down" },
  max         = { {"cmd", "alt", "ctrl"}, "/" },
  undo        = { {"cmd", "alt", "ctrl"}, "." },
  next_screen     = { {"cmd", "alt", "ctrl"}, "l" },
  previous_screen = { {"cmd", "alt", "ctrl"}, "h" },
})

hs.loadSpoon('HSKeybindings')
-- hs.loadSpoon('WinWin')


-- only keep text clipboard history. Use ClipMenu App can keep image clipboard history.
-- hs.loadSpoon('ClipboardTool')
-- spoon.ClipboardTool:start()

hs.loadSpoon('KeyMouse')
spoon.KeyMouse:bindHotkeys()
spoon.KeyMouse:start()

hs.loadSpoon('KeyVolume')
spoon.KeyVolume:bindHotkeys(spoon.KeyVolume.defaultHotkeys)

-- Prevent the screen from going to sleep Download
hs.loadSpoon('Caffeine')
spoon.Caffeine:start()

hs.loadSpoon('WindowHalfsAndThirds')
spoon.WindowHalfsAndThirds:bindHotkeys({
  left_half   = { {"cmd", "alt", "ctrl"}, "Left" },
  right_half  = { {"cmd", "alt", "ctrl"}, "Right" },
  top_half    = { {"cmd", "alt", "ctrl"}, "Up" },
  bottom_half = { {"cmd", "alt", "ctrl"}, "Down" },
  max         = { {"cmd", "alt", "ctrl"}, "M" },
  undo        = { {"cmd", "alt", "ctrl"}, "/" }
})

hs.loadSpoon('HSKeybindings')
-- hs.loadSpoon('WinWin')


-- only keep text clipboard history. Use ClipMenu App can keep image clipboard history.
-- hs.loadSpoon('ClipboardTool')
-- spoon.ClipboardTool:start()

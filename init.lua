-- Prevent the screen from going to sleep Download
hs.loadSpoon('Caffeine')
spoon.Caffeine:start()

hs.loadSpoon('WindowHalfsAndThirds')
spoon.WindowHalfsAndThirds:bindHotkeys({
  left_half   = { {"cmd", "shift", "alt"}, "Left" },
  right_half  = { {"cmd", "shift", "alt"}, "Right" },
  top_half    = { {"cmd", "shift", "alt"}, "Up" },
  bottom_half = { {"cmd", "shift", "alt"}, "Down" },
  max         = { {"cmd", "shift", "alt"}, "M" },
  undo        = { {"cmd", "shift", "alt"}, "/" }
})

hs.loadSpoon('HSKeybindings')
-- hs.loadSpoon('WinWin')


-- only keep text clipboard history. Use ClipMenu App can keep image clipboard history.
-- hs.loadSpoon('ClipboardTool')
-- spoon.ClipboardTool:start()

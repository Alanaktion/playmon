import 'CoreLibs/frameTimer'
import 'CoreLibs/timer'
import 'CoreLibs/easing'
import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'

gfx = playdate.graphics
Point = playdate.geometry.point
Rect = playdate.geometry.rect

displayWidth, displayHeight = playdate.display.getSize()

import 'text'
import 'overlay'
import 'title'
import 'level'
import 'battle'
import 'monsterdex'
-- import 'soundManager'

playdate.display.setRefreshRate(40)

Title()
-- Battle()
-- Monsterdex()

local fade = 0
function playdate.update()
	gfx.sprite.update()
	playdate.frameTimer.updateTimers()
	playdate.timer.updateTimers()
	playdate.drawFPS(0, 0)
	-- sampleFonts()
end

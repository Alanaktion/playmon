import 'CoreLibs/frameTimer'
import 'CoreLibs/easing'
import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'

gfx = playdate.graphics
Point = playdate.geometry.point
Rect = playdate.geometry.rect

displayWidth, displayHeight = playdate.display.getSize()

import 'level'
import 'battle'
import 'title'
-- import 'soundManager'

Title()

function playdate.update()
	gfx.sprite.update()
	playdate.frameTimer.updateTimers()
	playdate.drawFPS(0, 0)
	-- sampleFonts()
end

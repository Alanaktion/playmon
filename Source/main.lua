import 'CoreLibs/frameTimer'
import 'CoreLibs/easing'
import 'CoreLibs/object'
import 'CoreLibs/sprites'
import 'level'
-- import 'soundManager'

playdate.display.setRefreshRate(40)

local FrameTimer_update = playdate.frameTimer.updateTimers
local gfx = playdate.graphics

Level.change('big-world')

function playdate.update()
	gfx.sprite.update()
	FrameTimer_update()
	playdate.drawFPS(0, 0)
end

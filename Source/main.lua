import 'CoreLibs/frameTimer'
import 'CoreLibs/easing'
import 'CoreLibs/object'
import 'CoreLibs/sprites'
import 'level'
-- import 'soundManager'

playdate.display.setRefreshRate(30)

local FrameTimer_update = playdate.frameTimer.updateTimers
local gfx = playdate.graphics

-- local level = Level('big-world.json')
local level = Level('overworld.json')

function playdate.update()
	gfx.sprite.update()
	FrameTimer_update()
end

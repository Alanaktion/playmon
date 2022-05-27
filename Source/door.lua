local gfx = playdate.graphics
class('Door').extends(gfx.sprite)

-- class variables
-- local doorTimer = playdate.frameTimer.new(7)	-- Timer to control door animations
-- doorTimer.repeats = false

-- local doorImages = gfx.imagetable.new('img/door')

function Door:init(initialPosition, image)
	Door.super.init(self)

	-- self:setImage(doorImages[1])
	self:setImage(image)
	self:setZIndex(800)
	self:setCenter(0, 0)
	self:setCollideRect(0, 0, 16, 16)
	self.position = initialPosition or Rect.new(0, 0, 1, 1)
	self:setBounds(self.position)
end

-- local setImage = gfx.sprite.setImage
-- local getImage = gfx.imagetable.getImage

-- function Door:update()
-- 	local frame = math.floor(doorTimer.frame / 2) + 1
-- 	setImage(self, doorImages[frame])
-- end

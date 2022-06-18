Title = {}
class('Title').extends(gfx.sprite)

local displayWidth, displayHeight = playdate.display.getSize()

local pc1
local pc2

function Title:init()
	Title.super.init(self)

	playdate.display.setRefreshRate(20)

	self:setZIndex(0)
	self:setCenter(0, 0)
	self:setBounds(0, 0, displayWidth, displayHeight)

	self.fade = 0

	pc1 = gfx.sprite.new(gfx.image.new("img/pc1"))
	pc1:setCenter(.5, 1)
	pc1:moveTo(200, 240)
	pc1:add()

	pc2 = gfx.sprite.new(gfx.image.new("img/pc2"))
	pc2:setCenter(.5, 1)
	pc2:moveTo(300, 240)
	pc2:add()

	self:add()
end

function Title:update()
	if self.fade ~= 0 then
		self.fade += 10
		self:markDirty()
	end
	if self.fade > 100 then
		Level.change('big-world')
	end
	if playdate.buttonJustPressed("A") then
		playdate.display.setRefreshRate(40)
		self.fade = 10
	end
end

function Title:draw(x, y, width, height)
	if self.fade then
		local black = gfx.image.new(displayWidth, displayHeight, gfx.kColorBlack)
		black:drawFaded(0, 0, self.fade / 100, gfx.image.kDitherTypeDiagonalLine)
		-- gfx.image.kDitherTypeScreen
	end
end

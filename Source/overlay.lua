Overlay = {}
class('Overlay').extends(gfx.sprite)

function Overlay:init()
	Overlay.super.init(self)

	self:setCenter(0, 0)
	self:setZIndex(9999)
	self:setBounds(0, 0, displayWidth, displayHeight)
	self:setIgnoresDrawOffset(true)

	self.fade = 0
	self.fadeTarget = 0

	self:add()
end

local black = gfx.image.new('img/black')
-- local diagOverlay = {
-- 	gfx.image.new('img/diag25'),
-- 	gfx.image.new('img/diag50'),
-- 	gfx.image.new('img/diag75'),
-- 	black,
-- }
local bayerOverlay = {
	gfx.image.new('img/bayer10'),
	gfx.image.new('img/bayer20'),
	gfx.image.new('img/bayer30'),
	gfx.image.new('img/bayer40'),
	gfx.image.new('img/bayer50'),
	gfx.image.new('img/bayer60'),
	gfx.image.new('img/bayer70'),
	gfx.image.new('img/bayer80'),
	gfx.image.new('img/bayer90'),
	black,
}
-- local screen = {
-- 	gfx.image.new('img/screen25'),
-- 	gfx.image.new('img/screen50'),
-- 	gfx.image.new('img/screen75'),
--	black,
-- }

local fadeCallback

function Overlay:fadeIn(callback)
	self.fade = #bayerOverlay
	self.fadeTarget = 0
	if callback ~= nil then
		fadeCallback = callback
	end
end

function Overlay:fadeOut(callback)
	self.fade = 0
	self.fadeTarget = #bayerOverlay
	if callback ~= nil then
		fadeCallback = callback
	end
end

function Overlay:update()
	if self.fade ~= self.fadeTarget then
		if self.fade > self.fadeTarget then
			self.fade -= 1
		else
			self.fade += 1
		end
		self:markDirty()
	elseif fadeCallback ~= nil then
		fadeCallback()
		fadeCallback = nil
	end
end

function Overlay:draw(x, y, width, height)
	if self.fade ~= 0 then
		bayerOverlay[self.fade]:draw(0, 0)
	end
end

overlay = Overlay()

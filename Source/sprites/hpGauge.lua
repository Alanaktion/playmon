HpGauge = {}
class('HpGauge').extends(gfx.sprite)

function HpGauge:init()
	HpGauge.super.init(self)
	self:setCenter(0, 0)
	self:setSize(130, 10)
	self.curHP = 1
	self.maxHP = 1
	self:setAlwaysRedraw(false)
end

function HpGauge:setHP(val, max)
	self.curHP = val
	self.maxHP = max
	self:markDirty()
	-- TODO: tween values when changing
end

function HpGauge:draw(x, y, width, height)
	-- container
	gfx.fillRoundRect(0, 0, 130, 10, 5)

	-- label
	gfx.setColor(gfx.kColorWhite)
	gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
	font11bold:drawText('HP', 7, 1)
	gfx.setImageDrawMode(gfx.kDrawModeCopy)

	-- track
	gfx.fillRoundRect(27, 1, 102, 8, 4)
	gfx.setColor(gfx.kColorBlack)

	-- fill
	local fillWidth = math.floor(self.curHP / self.maxHP * 100)
	gfx.fillRoundRect(28, 2, fillWidth, 6, 3)
end

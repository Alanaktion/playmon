BattleBubbleOpponent = {}
class('BattleBubbleOpponent').extends(gfx.sprite)

function BattleBubbleOpponent:init()
	BattleBubbleOpponent.super.init(self)
	self:setCenter(0, 0)
	self.image = gfx.image.new("img/msg-opponent")
	self:setSize(self.image:getSize())
	self.name = ''
	self.curHP = 1
	self.maxHP = 1
	self:setAlwaysRedraw(false)
end

function BattleBubbleOpponent:setName(name, lv)
	self.name = name
	self.lv = lv
	self:markDirty()
end

function BattleBubbleOpponent:setHP(val, max)
	self.curHP = val
	self.maxHP = max
	self:markDirty()
end

function BattleBubbleOpponent:draw(x, y, width, height)
	self.image:draw(0, 0)

	-- Top text
	font15:drawText(self.name, 5, 2)
	font15:drawTextAligned('Lv ' .. self.lv, self.width - 12, 2, kTextAlignment.right)

	-- Gauge container
	gfx.fillRoundRect(46, 18, 130, 10, 5)

	-- Gauge label
	gfx.setColor(gfx.kColorWhite)
	gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
	font11bold:drawText('HP', 53, 19)
	gfx.setImageDrawMode(gfx.kDrawModeCopy)

	-- Gauge track
	gfx.fillRoundRect(73, 19, 102, 8, 4)
	gfx.setColor(gfx.kColorBlack)

	-- Gauge fill
	local fillWidth = math.floor(self.curHP / self.maxHP * 100)
	gfx.fillRoundRect(74, 20, fillWidth, 6, 3)
end

import 'hpGauge'

BattleBubbleOpponent = {}
class('BattleBubbleOpponent').extends(gfx.sprite)

function BattleBubbleOpponent:init(x, y)
	BattleBubbleOpponent.super.init(self)

	self:setCenter(0, 0)
	self:setZIndex(20)
	self:moveTo(x, y)
	self.image = gfx.image.new("img/msg-opponent")
	self:setSize(self.image:getSize())

	self.name = ''

	self.hpGauge = HpGauge()
	self.hpGauge:moveTo(x + 46, y + 18)
	self.hpGauge:setZIndex(21)
	self.hpGauge:add()

	self:setAlwaysRedraw(false)
end

function BattleBubbleOpponent:setName(name, lv)
	self.name = name
	self.lv = lv
	self:markDirty()
end

function BattleBubbleOpponent:setHP(val, max)
	self.hpGauge:setHP(val, max)
end

function BattleBubbleOpponent:remove()
	self.hpGauge:remove()
	gfx.sprite.removeSprite(self)
end

function BattleBubbleOpponent:draw(x, y, width, height)
	self.image:draw(0, 0)

	-- Top text
	font15:drawText(self.name, 5, 2)
	font15:drawTextAligned('Lv ' .. self.lv, self.width - 12, 2, kTextAlignment.right)
end

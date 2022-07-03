import 'hpGauge'

BattleBubblePlayer = {}
class('BattleBubblePlayer').extends(gfx.sprite)

function BattleBubblePlayer:init(x, y)
	BattleBubblePlayer.super.init(self)

	self:setCenter(0, 0)
	self:setZIndex(20)
	self:moveTo(x, y)
	self.image = gfx.image.new("img/msg-player")
	self:setSize(self.image:getSize())

	self.name = ''
	self.curAP = 0
	self.maxAP = 0
	self.curEXP = 0
	self.maxEXP = 0

	self.hpGauge = HpGauge()
	self.hpGauge:moveTo(x + 52, y + 18)
	self.hpGauge:setZIndex(21)
	self.hpGauge:add()

	self:setAlwaysRedraw(false)
end

function BattleBubblePlayer:setName(name, lv)
	self.name = name
	self.lv = lv
	self:markDirty()
end

function BattleBubblePlayer:setHP(val, max)
	self.hpGauge:setHP(val, max)
end

function BattleBubblePlayer:setAP(val, max)
	self.curAP = val
	self.maxAP = max
	self:markDirty()
end

function BattleBubblePlayer:setEXP(val, max)
	self.curEXP = val
	self.maxEXP = max
	self:markDirty()
end

function BattleBubblePlayer:remove()
	self.hpGauge:remove()
	gfx.sprite.removeSprite(self)
end

function BattleBubblePlayer:draw(x, y, width, height)
	self.image:draw(0, 0)

	-- Name/Level top text
	font15:drawText(self.name, 10, 2)
	font15:drawTextAligned('Lv ' .. self.lv, self.width - 5, 2, kTextAlignment.right)

	-- EXP gauge
	font11bold:drawText('EXP', 10, 34)
	gfx.drawRoundRect(34, 35, 84, 6, 2)
	local expWidth = math.floor(self.curEXP / self.maxEXP * 80)
	gfx.fillRect(36, 37, expWidth, 2)

	-- AP bottom text
	font15:drawTextAligned(self.curAP .. ' / ' .. self.maxAP, self.width - 5, 30, kTextAlignment.right)
end

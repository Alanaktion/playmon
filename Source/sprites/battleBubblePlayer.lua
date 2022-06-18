BattleBubblePlayer = {}
class('BattleBubblePlayer').extends(gfx.sprite)

function BattleBubblePlayer:init()
	BattleBubblePlayer.super.init(self)
	self:setCenter(0, 0)
	self.image = gfx.image.new("img/msg-player")
	self:setSize(self.image:getSize())
	self.name = ''
	self.curHP = 1
	self.maxHP = 1
	self.curAP = 0
	self.maxAP = 0
	self.curEXP = 0
	self.maxEXP = 0
	self:setAlwaysRedraw(false)
end

function BattleBubblePlayer:setName(name, lv)
	self.name = name
	self.lv = lv
	self:markDirty()
end

function BattleBubblePlayer:setHP(val, max)
	self.curHP = val
	self.maxHP = max
	self:markDirty()
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

function BattleBubblePlayer:draw(x, y, width, height)
	self.image:draw(0, 0)

	-- Name/Level top text
	font15:drawText(self.name, 10, 2)
	font15:drawTextAligned('Lv ' .. self.lv, self.width - 5, 2, kTextAlignment.right)

	-- HP container + label
	gfx.fillRoundRect(52, 18, 130, 10, 5)
	gfx.setColor(gfx.kColorWhite)
	gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
	font11bold:drawText('HP', 59, 19)
	gfx.setImageDrawMode(gfx.kDrawModeCopy)

	-- HP track + fill
	gfx.fillRoundRect(79, 19, 102, 8, 4)
	gfx.setColor(gfx.kColorBlack)
	local hpWidth = math.floor(self.curHP / self.maxHP * 100)
	gfx.fillRoundRect(80, 20, hpWidth, 6, 3)

	-- EXP gauge
	font11bold:drawText('EXP', 10, 34)
	gfx.drawRoundRect(34, 35, 84, 6, 2)
	local expWidth = math.floor(self.curEXP / self.maxEXP * 80)
	gfx.fillRect(36, 37, expWidth, 2)

	-- AP bottom text
	font15:drawTextAligned(self.curAP .. ' / ' .. self.maxAP, self.width - 5, 30, kTextAlignment.right)
end

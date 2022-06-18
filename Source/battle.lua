import 'sprites/battleBubbleOpponent'
import 'sprites/battleBubblePlayer'
import 'sprites/messageBox'

Battle = {}
class('Battle').extends(gfx.sprite)

local msg
local npc
local npcMsg
local pl
local plMsg

function Battle:init()
	Battle.super.init(self)

	playdate.display.setRefreshRate(30)

	self:setZIndex(0)
	self:setCenter(0, 0)
	self:setBounds(0, 0, displayWidth, displayHeight)

	msg = MessageBox(displayWidth, 48)
	msg:setCenter(0, 1)
	msg:setDark(true)
	msg:moveTo(0, displayHeight)
	msg:setZIndex(20)
	msg:setText('*Player* encountered a wild *douche*! This is going to be a quick battle.')
	msg:add()

	npc = gfx.sprite.new(gfx.image.new("img/pc1"))
	npc:setCenter(.5, 1)
	npc:moveTo(320, 108)
	npc:setZIndex(10)
	npc:add()

	npcMsg = BattleBubbleOpponent()
	npcMsg:moveTo(60, 12)
	npcMsg:setZIndex(20)
	npcMsg:setName('turntSNACO', 12)
	npcMsg:setHP(10, 14)
	npcMsg:add()

	pl = gfx.sprite.new(gfx.image.new("img/pc2"))
	pl:setCenter(.5, 1)
	pl:moveTo(80, displayHeight - msg.height)
	pl:setZIndex(10)
	pl:add()

	plMsg = BattleBubblePlayer()
	plMsg:moveTo(160, displayHeight - msg.height - 60)
	plMsg:setZIndex(20)
	plMsg:setName('Playerone', 15)
	plMsg:setHP(22, 22)
	plMsg:setAP(24, 24)
	plMsg:setEXP(30, 50)
	plMsg:add()

	self:add()
	self:markDirty()
end

function Battle:update()
	if playdate.buttonJustPressed("B") then
		-- TODO: this is obviously not how battles are exited
		self:exit()
	end
end

function Battle:draw(x, y, width, height)
	gfx.setColor(gfx.kColorBlack)

	-- Light gray bg
	local bg = gfx.image.new(displayWidth, displayHeight - msg.height, gfx.kColorBlack)
	bg:drawFaded(0, 0, 1/8, gfx.image.kDitherTypeBayer4x4)

	-- npc underline
	-- TODO: this should maybe be an image, or not exist at all?
	gfx.fillPolygon(
		244, 108,
		400, 108,
		400, 112,
		256, 112
	)
end

function Battle:exit()
	msg:remove()
	npc:remove()
	npcMsg:remove()
	pl:remove()
	plMsg:remove()
	self:remove()
	playdate.display.setRefreshRate(40)
	Level:show()
	battle = nil
end

import 'sprites/battleBubbleOpponent'
import 'sprites/battleBubblePlayer'
-- import 'sprites/messageBox'

Battle = {}
class('Battle').extends(gfx.sprite)

local bg = gfx.image.new('img/bg-battle')
local margin = 6
local textRect = Rect.new(
	margin,
	margin + displayHeight - 48,
	displayWidth - margin * 2,
	48 - margin * 2
)
local platImg = gfx.image.new("img/platform")

local msg
local npc
local npcPlat
local npcMsg
local pl
local plMsg

function Battle:init()
	Battle.super.init(self)

	self:setZIndex(0)
	self:setCenter(0, 0)
	self:setBounds(0, 0, displayWidth, displayHeight)

	msg = '*Alice* encountered a wild *Leozar*! Watch out for its sharp hot tail.'

	npc = gfx.sprite.new(gfx.image.new("img/monsters/water6_dither"))
	npc:setCenter(.5, 1)
	npc:moveTo(310, 108)
	npc:setZIndex(10)
	npc:add()

	npcPlat = gfx.sprite.new(platImg)
	npcPlat:setCenter(.5, .7)
	npcPlat:moveTo(310, 108)
	npcPlat:setZIndex(9)
	npcPlat:add()

	npcMsg = BattleBubbleOpponent(60, 12)
	npcMsg:setName('Leozar', 12)
	npcMsg:setHP(10, 14)
	npcMsg:add()

	pl = gfx.sprite.new(gfx.image.new("img/monsters/water9_dither"))
	pl:setCenter(.5, 1)
	pl:moveTo(90, displayHeight - 48)
	pl:setZIndex(10)
	pl:add()

	plPlat = gfx.sprite.new(platImg)
	plPlat:setClipRect(0, 0, displayWidth, displayHeight - 48)
	plPlat:setCenter(.5, .7)
	plPlat:moveTo(90, displayHeight - 48)
	plPlat:setZIndex(9)
	plPlat:add()

	plMsg = BattleBubblePlayer(160, displayHeight - 48 - 60)
	plMsg:setName('Lunaraus', 15)
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
		overlay:fadeOut(function()
			self:exit()
		end)
	end
end

function Battle:draw(x, y, width, height)
	gfx.setColor(gfx.kColorBlack)
	bg:draw(0, 0)

	-- npc underline
	-- TODO: this should maybe be an image, or not exist at all?
	-- gfx.fillPolygon(
	-- 	244, 108,
	-- 	400, 108,
	-- 	400, 112,
	-- 	256, 112
	-- )

	-- draw message text
	if msg then
		gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
		local w, h, trunc = gfx.drawTextInRect(msg, textRect)
		if trunc then
			print("Battle text was truncated!", msg)
		end
		gfx.setImageDrawMode(gfx.kDrawModeCopy)
	end
end

function Battle:exit()
	npc:remove()
	npcMsg:remove()
	npcPlat:remove()
	pl:remove()
	plMsg:remove()
	plPlat:remove()
	self:remove()
	Level:showWithFade()
	battle = nil
end

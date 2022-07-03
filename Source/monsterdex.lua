import 'CoreLibs/ui/gridview.lua'
import 'CoreLibs/nineslice'

Monsterdex = {}
class('Monsterdex').extends(gfx.sprite)

local monsters
local monsterImages
local bg
local gridview
local selectedIndex = 0
local selectedMonster

function Monsterdex:init()
	Monsterdex.super.init(self)

	self:setZIndex(0)
	self:setCenter(0, 0)
	self:setBounds(0, 0, displayWidth, displayHeight)
	bg = gfx.image.new('img/diag25')

	monsters = json.decodeFile('data/monsters.json')
	monsterImages = {}
	for i = 1, #monsters do
		monsterImages[i] = gfx.image.new("img/monsters/" .. monsters[i].image)
	end

	gridview = playdate.ui.gridview.new(96, 96)
	gridview:setNumberOfColumns(2)
	gridview:setNumberOfRows(math.ceil(#monsters / 2))
	-- gridview:setNumberOfRows(2, 4, 3, 5) -- Group monsters by type?
	-- gridview:setSectionHeaderHeight(24)
	gridview:setCellPadding(4, 4, 4, 4)
	gridview.changeRowOnColumnWrap = true

	gfx.setLineWidth(2)
	function gridview:drawCell(section, row, column, selected, x, y, width, height)
		local index = (row * 2) - 1 + (column - 1)
		if selected then
			if #monsters < index then
				selectedMonster = nil
			elseif index ~= selectedIndex then
				selectedIndex = index
				selectedMonster = monsters[index]
			end
			gfx.setColor(gfx.kColorWhite)
			gfx.fillRoundRect(x, y, width, height, 4)
			gfx.setColor(gfx.kColorBlack)
			gfx.drawRoundRect(x, y, width, height, 4)
		end
		if #monsters >= index then
			monsterImages[index]:draw(x, y)
		end
	end

	-- function gridview:drawSectionHeader(section, x, y, width, height)
	-- 	gfx.drawText("*Section ".. section .. "*", x + 10, y + 8)
	-- end

	self:add()
end

function Monsterdex:draw(x, y, width, height)
	bg:draw(x, y, nil, Rect.new(0, 0, 208, displayHeight))
	gridview:drawInRect(0, 0, 208, displayHeight)
	gfx.drawLine(209, 0, 209, displayHeight)
	if selectedMonster ~= nil then
		font24round:drawText(selectedMonster.name, 220, 30)
		font15italic:drawText(selectedMonster.type .. ' type', 220, 60)
	end
end

function Monsterdex:update()
	if playdate.buttonJustPressed("up") then
		gridview:selectPreviousRow(true)
	end
	if playdate.buttonJustPressed("down") then
		gridview:selectNextRow(true)
	end
	if playdate.buttonJustPressed("left") then
		gridview:selectPreviousColumn(true)
	end
	if playdate.buttonJustPressed("right") then
		gridview:selectNextColumn(true)
	end

	if playdate.buttonJustPressed("B") then
		overlay:fadeOut(function()
			self:exit()
		end)
	end
end

function Monsterdex:exit()
	self:remove()
	Level:showWithFade()
	monsters = nil
	monsterImages = nil
	bg = nil
	selectedIndex = 0
	selectedMonster = nil
	monsterdex = nil
end

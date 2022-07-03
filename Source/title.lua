Title = {}
class('Title').extends(gfx.sprite)

local displayWidth, displayHeight = playdate.display.getSize()

local pc1
local pc2

local menu = playdate.getSystemMenu()
local dexMenuItem

function Title:init()
	Title.super.init(self)

	self:setZIndex(0)
	self:setCenter(0, 0)
	self:setBounds(0, 0, displayWidth, displayHeight)

	pc1 = gfx.sprite.new(gfx.image.new("img/pc1"))
	pc1:setCenter(.5, 1)
	pc1:moveTo(70, 240)
	pc1:add()

	pc2 = gfx.sprite.new(gfx.image.new("img/pc2"))
	pc2:setCenter(.5, 1)
	pc2:moveTo(180, 245)
	pc2:add()

	self:add()
end

function Title:update()
	if playdate.buttonJustPressed("A") then
		menu:addMenuItem("monsterdex", function()
			-- TODO: only hide level if in level screen
			-- Honestly this menu item should probably be added and removed to only
			-- show while in the level screen because the dex is not necessary in-battle
			Level.hideWithFade(function()
				monsterdex = new Monsterdex()
				overlay:fadeIn()
			end)
		end)
		overlay:fadeOut(function()
			Level.change('big-world')
		end)
	end
end

function Title:draw(x, y, width, height)
	font24round:drawText('Playmon', 20, 50)
	font15italic:drawText('I didn\'t bother naming it edition', 20, 80)

	gfx.drawText('Ⓐ Start', 320, displayHeight - 30)
end

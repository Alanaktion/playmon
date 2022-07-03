LevelObject = {}
class('LevelObject').extends(gfx.sprite)

local Point = playdate.geometry.point
local Rect = playdate.geometry.rect

function LevelObject:init(initialPosition, type)
	LevelObject.super.init(self)

	self.type = type
	self:setZIndex(800)
	self:setCenter(0, 0)
	if initialPosition ~= nil then
		self:setCollideRect(0, 0, initialPosition.width, initialPosition.height)
	else
		print('LevelObject instance created without position data')
	end
	self.position = initialPosition or Rect.new(0, 0, 1, 1)
	self:setBounds(self.position)
end

function LevelObject:setProperties(properties)
	self.properties = properties
end

-- Called when the player presses A while intersecting the object
function LevelObject:activate()
	if self.type == "grass" then
		-- TODO: do accumulated chance of encounter while colliding with grass and moving, rather than entering a battle manually with A
		Level.hideWithFade(function()
			battle = new Battle()
			overlay:fadeIn()
		end)
		return
	end
	local props = self.properties
	if props == nil then
		return
	end
	if props.teleport ~= nil then
		local position
		if props.teleportX then
			position = Point.new(props.teleportX, props.teleportY)
		end
		Level.change(props.teleport, position)
	end
end

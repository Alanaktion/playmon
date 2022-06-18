LevelObject = {}
class('LevelObject').extends(gfx.sprite)

local Point = playdate.geometry.point
local Rect = playdate.geometry.rect

function LevelObject:init(initialPosition, type)
	LevelObject.super.init(self)

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

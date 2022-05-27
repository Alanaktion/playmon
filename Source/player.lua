local gfx = playdate.graphics
class('Player').extends(gfx.sprite)

-- Local references
local Point = playdate.geometry.point
local Rect = playdate.geometry.rect
local vector2D = playdate.geometry.vector2D
local min, max, abs, floor = math.min, math.max, math.abs, math.floor

-- Constants
local DT = 3
local LEFT, RIGHT = 1, 2
local STAND, RUN1, RUN2, RUN3, TURN, JUMP, CROUCH = 1, 2, 3, 4, 5, 6, 7 -- frames

local minPosition = Point.new(6, 20) -- emulate sprite collision with corner
local maxPosition = Point.new(0, 0) -- real value set in level.lua
local spriteWidth = 16
local spriteHeight = 32
local facing = RIGHT
local runImageIndex = 1
local spawnPoint = Point.new(128, 64)

function Player:init()
	Player.super.init(self)

	self.playerImages = gfx.imagetable.new('img/player')
	self:setImage(self.playerImages:getImage(1))
	self:setZIndex(1000)
	self:setCenter(0.5, 1)	-- set center point to center bottom middle
	self:moveTo(spawnPoint.x, spawnPoint.y)
	self:setCollideRect(2, 12, spriteWidth-4, spriteHeight-12)

	self.position = spawnPoint
	self.velocity = vector2D.new(0,0)
end

function Player:setSpawnPoint(x, y)
	print('spawn point', x, y)
	spawnPoint = Point.new(x, y)
end

function Player:reset()
	self.position = spawnPoint
	self:moveTo(spawnPoint.x, spawnPoint.y)
	self.velocity = vector2D.new(0,0)
end

function Player:collisionResponse(other)
	-- if other:isa(NPC) or other:isa(Monster) then
	-- 	return gfx.sprite.kCollisionTypeOverlap
	-- end

	return gfx.sprite.kCollisionTypeSlide
end

function Player:update()
	-- TODO: possibly make player move by tile instead of by pixel, for example with a single press of "right" resulting in an animated one-tile move to the right.

	-- Handle horizontal movement
	if playdate.buttonIsPressed("right") then
		facing = RIGHT
		self.velocity.x = 1
	elseif playdate.buttonIsPressed("left") then
		facing = LEFT
		self.velocity.x = -1
	else
		self.velocity.x = 0
	end

	-- Handle vertical movement
	if playdate.buttonIsPressed("down") then
		self.velocity.y = 1
	elseif playdate.buttonIsPressed("up") then
		self.velocity.y = -1
	else
		self.velocity.y = -0
	end

	-- Handle object activation
	if playdate.buttonJustPressed("A") then
		-- TODO: activate any object currently collided with player (e.g. doors)
	end

	-- Allow running while holding B
	if playdate.buttonIsPressed("B") then
		self.velocity.x *= 2
		self.velocity.y *= 2
		runImageIndex += 1
	else
		runImageIndex += 0.5
	end

	if runImageIndex > 3.5 then runImageIndex = 1 end

	-- Update Player position based on current velocity
	local velocityStep = self.velocity * DT
	self.position = self.position + velocityStep

	-- Don't move outside the walls of the map
	if self.position.x < minPosition.x then
		self.velocity.x = 0
		self.position.x = minPosition.x
	elseif self.position.x > maxPosition.x then
		self.velocity.x = 0
		self.position.x = maxPosition.x
	end
	if self.position.y < minPosition.y then
		self.velocity.y = 0
		self.position.y = minPosition.y
	elseif self.position.y > maxPosition.y then
		self.velocity.y = 0
		self.position.y = maxPosition.y
	end

	self:updateImage()
end

-- sets the appropriate sprite image for Player based on the current conditions
function Player:updateImage()
	local flip = gfx.kImageUnflipped
	if facing == LEFT then
		flip = gfx.kImageFlippedX
	end
	if self.velocity.x == 0 and self.velocity.y == 0 then
		self:setImage(self.playerImages:getImage(STAND), flip)
	else
		self:setImage(self.playerImages:getImage(floor(runImageIndex+1)), flip)
	end
end

function Player:setMaxPosition(x, y)
	maxPosition = Point.new(x, y)
end

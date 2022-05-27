import 'levelLoader'
import 'door'
import 'player'

-- local references
local gfx = playdate.graphics
local Point = playdate.geometry.point
local Rect = playdate.geometry.rect
local abs, floor, ceil, min, max = math.abs, math.floor, math.ceil, math.min, math.max

local displayWidth, displayHeight = playdate.display.getSize()

local tileset

-- tilemaps
local walls
local background

local player = Player()
local objects

-- constants
local DOOR_GID = 417
local STAIR_GID = 418
local TILE_SIZE = 16
local CAMERA_PAN_MIN = 64

local cameraMin = Point.new(0, 0)
local cameraMax

cameraX = 0
cameraY = 0

class('Level').extends(gfx.sprite)

function Level:init(pathToLevelJSON)
	Level.super.init(self)

	self:setZIndex(0)
	self:setCenter(0, 0) -- set center point to top left

	self.doors = {}
	self.enemies = {}

	tileset, self.layers, objects = importDataFromTiledJSON(pathToLevelJSON)

	-- set up local references for the layers we read
	walls = self.layers["Walls"]
	background = self.layers["Background"]

	self:setBounds(0, 0, background.pixelWidth, background.pixelHeight)

	cameraMax = Point.new(background.pixelWidth - displayWidth, background.pixelHeight - displayHeight)
	player:setMaxPosition(background.pixelWidth - 8, background.pixelHeight)

	self:setupWallSprites()
	self:setupObjects()

	player:addSprite() -- we want player's update() to be called before layer's, so add it first
	self:addSprite()

	-- start playing background music
	-- SoundManager:playBackgroundMusic()
end


--! Utility

-- returns the bounds rect for the tile at column, row
local function boundsForTileAtPosition(column, row)
	return Rect.new(column * TILE_SIZE - TILE_SIZE, row * TILE_SIZE - TILE_SIZE, TILE_SIZE, TILE_SIZE)
end


-- returns a range of currently visible tiles as the tuple (startRow, endRow, startColumn, endColumn)
function Level:rangeOfTilesInRect(rect)
	local startRow = floor((rect.y) / TILE_SIZE + 1)
	local endRow = ceil((rect.y + rect.height) / TILE_SIZE)

	local startColumn = floor((rect.x) / TILE_SIZE + 1)
	local endColumn = ceil((rect.x + rect.width) / TILE_SIZE)

	return startRow, endRow, startColumn, endColumn
end


-- sets the tile to the new value and updates our wall edges array
function Level:setTileAtPosition(column, row, newTileValue)
	walls.tilemap:setTileAtPosition(column, row, newTileValue)
end


--! Sprite Movement

function Level:movePlayer()
	local collisions, len
	player.position.x, player.position.y, collisions, len = player:moveWithCollisions(player.position)

	for i = 1, len do
		local c = collisions[i]

		if c.other.isWall == true then
			if c.normal.y ~= 0 then
				player.velocity.y = 0
			end
			if c.normal.x ~= 0 then	-- sideways hit. stop moving
				player.velocity.x = 0
			end
		elseif c.other:isa(Door) then
			self:collideDoor(c.other)
		elseif c.other:isa(Enemy) then
			-- TODO: we don't have enemies on-screen but we probably want to handle something similarly
		end
	end

end

function Level:moveEnemies()
-- 	local enemies = self.enemies
-- 	for i=1, #enemies do
-- 		local enemy = enemies[i]
-- 		if not enemy.crushed then
-- 			enemy.position.x, enemy.position.y, cols, cols_len = enemy:moveWithCollisions(enemy.position.x, enemy.position.y)
-- 			for i=1, cols_len do
-- 				local col = cols[i]
-- 				if col.normal.x ~= 0 then -- hit something in the X direction
-- 					enemy:changeDirections()
-- 				end
-- 			end
-- 		end
-- 	end
end

-- moves the camera horizontally based on player's current position
function Level:updateCameraPosition()
	local newX = -cameraX
	local newY = -cameraY

	if player.position.y - newY < CAMERA_PAN_MIN then
		newY = max(cameraMin.y, player.position.y - CAMERA_PAN_MIN)
	elseif player.position.y - newY > displayHeight - CAMERA_PAN_MIN then
		newY = min(cameraMax.y, player.position.y - displayHeight + CAMERA_PAN_MIN)
	end
	if player.position.x - newX < CAMERA_PAN_MIN then
		newX = max(cameraMin.x, player.position.x - CAMERA_PAN_MIN)
	elseif player.position.x - newX > displayWidth - CAMERA_PAN_MIN then
		newX = min(cameraMax.x, player.position.x - displayWidth + CAMERA_PAN_MIN)
	end

	if newX ~= -cameraX or newY ~= -cameraY then
		cameraX = -newX
		cameraY = -newY
		gfx.setDrawOffset(cameraX, cameraY)
		gfx.sprite.addDirtyRect(newX, newY, displayWidth, displayHeight)

		--[[
		Possible optimization: Instead of redrawing the entire screen when it scrolls, draw the previous frame at an offset and only mark the exposed area as dirty.

		local d = newX + cameraX
		cameraX = -newX
		gfx.setDrawOffset(cameraX,0)
		gfx.getDisplayImage():draw(newX,0)

		if d > 0 then
			gfx.sprite.addDirtyRect(newX + displayWidth - d, 0, d, displayHeight)
		else
			gfx.sprite.addDirtyRect(newX, 0, -d, displayHeight)
		end
		]]
	end
end


--! Sprite library callbacks

function Level:update()
	self:movePlayer()
	-- self:moveEnemies()
	self:updateCameraPosition()
end

function Level:draw(x, y, width, height)
	background.tilemap:draw(0, 0)
	walls.tilemap:draw(0, 0)
end


--! Sprite setup (doors, enemies)

function Level:addDoorSprite(x, y, gid)
	local tilePosition = Rect.new(x, y, TILE_SIZE, TILE_SIZE)
	local image = tileset.imageTable[gid]
	local newDoor = Door(tilePosition, image)
	newDoor:addSprite()
	table.insert(self.doors, newDoor)
end

function Level:addEnemySprite(column, row)
	local tilePosition = boundsForTileAtPosition(column, row)
	local newEnemy = Enemy(tilePosition)
	newEnemy:addSprite()
	self.enemies[#self.enemies+1] = newEnemy
end

function Level:setupSprites()
	local tilemap = sprites.tilemap
	local width, height = tilemap:getSize()

	for column = 1, width do
		for row = 1, height do
			local gid = tilemap:getTileAtPosition(column, row)

			if gid ~= nil and gid > 0 then
				if gid == DOOR_GID then
					self:addDoorSprite(column * TILE_SIZE, row * TILE_SIZE, gid)
				end
				-- TODO: handle more tile-based sprite types here
				-- TODO: consider using the object layer instead of a sprite layer, though that does make placement harder since it's pixel-precise in the editor.
			end
		end
	end
end

function Level:setupObjects()
	for i=1, #objects do
		local object = objects[i]
		if object.type == 'spawn' then
			player:setSpawnPoint(object.x, object.y)
			player:reset()
		elseif object.type == 'door' then
			-- TODO: store all of the useful door properties in our doors array
			self:addDoorSprite(object.x, object.y, object.gid)
		elseif object.type == 'enemy' then
			print('enemy', object.x, object.y)
		else
			print(objects[i].type)
		end
	end
end


--! Wall setup

function Level:setupWallSprites()
	-- may want to dynamically load and unload wall sprites as the player moves around the level

	-- group the wall areas into larger areas and add collision sprites for them
	local walls = gfx.sprite.addWallSprites(walls.tilemap, {1})
	for i = 1, #walls do
		local w = walls[i]
		w.isWall = true
	end
end


--! Collision Handling

function Level:collideDoor(door)
	print('Hit door')
	-- SoundManager:playSound(SoundManager.kSoundCoin)
end

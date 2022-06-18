import 'levelLoader'
import 'sprites/levelObject'
import 'sprites/player'

-- tilemaps
local walls
local background

local player = Player()

-- constants
local TILE_SIZE = 16
local CAMERA_PAN_MIN = 64

local cameraMin = Point.new(0, 0)
local cameraMax

cameraX = 0
cameraY = 0

class('Level').extends(gfx.sprite)

function Level:init(pathToLevelJSON, position)
	Level.super.init(self)

	self:setZIndex(0)
	self:setCenter(0, 0) -- set center point to top left

	self.fade = 0
	self.fadeTarget = 0
	self.objInstances = {}
	self.tileset, self.layers, self.objects = importDataFromTiledJSON(pathToLevelJSON)
	self:setAlwaysRedraw(false)

	-- set up local references for the layers we read
	walls = self.layers["Walls"]
	background = self.layers["Background"]

	self:setBounds(0, 0, background.pixelWidth, background.pixelHeight)

	cameraMax = Point.new(background.pixelWidth - displayWidth, background.pixelHeight - displayHeight)
	player:setMaxPosition(background.pixelWidth - 8, background.pixelHeight)

	self:setupWallSprites()
	self:setupObjects()

	if position ~= nil then
		player:reset(position.x, position.y)
	end

	player:add()
	self:add()

	-- start playing background music
	-- SoundManager:playBackgroundMusic()
end

-- Unload the current level, and init the new specified level
-- Optionally place the player at the specified position
function Level.change(newLevel, position)
	-- TODO: fade out current level before fading in
	gfx.sprite.removeAll()
	level = Level('maps/' .. newLevel .. '.json', position)
	level:fadeIn()
end

function Level:fadeIn()
	self.fade = 100
	self.fadeTarget = 0
end

function Level:fadeOut()
	self.fade = 0
	self.fadeTarget = 100
end

function Level.hide()
	gfx.setDrawOffset(0, 0)
	level:setVisible(false)
	level:remove()
	player:remove()
end

function Level.show()
	gfx.setDrawOffset(-cameraX, -cameraY)
	level:setVisible(true)
	level:add()
	player:add()
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
			if c.normal.x ~= 0 then
				player.velocity.x = 0
			end
		elseif c.other:isa(Monster) then
			-- TODO: handle monster collision, if this is something we need.
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

function Level:updateCameraPosition()
	local newX = math.min(cameraX, cameraMax.x)
	local newY = math.min(cameraY, cameraMax.y)

	if player.position.y - newY < CAMERA_PAN_MIN then
		newY = math.max(cameraMin.y, player.position.y - CAMERA_PAN_MIN)
	elseif player.position.y - newY > displayHeight - CAMERA_PAN_MIN then
		newY = math.min(cameraMax.y, player.position.y - displayHeight + CAMERA_PAN_MIN)
	end
	if player.position.x - newX < CAMERA_PAN_MIN then
		newX = math.max(cameraMin.x, player.position.x - CAMERA_PAN_MIN)
	elseif player.position.x - newX > displayWidth - CAMERA_PAN_MIN then
		newX = math.min(cameraMax.x, player.position.x - displayWidth + CAMERA_PAN_MIN)
	end

	if newX ~= cameraX or newY ~= cameraY then
		cameraX, cameraY = newX, newY
		gfx.setDrawOffset(-newX, -newY)
		gfx.sprite.addDirtyRect(newX, newY, displayWidth, displayHeight)
	end
end


--! Sprite library callbacks

function Level:update()
	self:movePlayer()
	self:updateCameraPosition()
	if self.fade ~= self.fadeTarget then
		if self.fade > self.fadeTarget then
			self.fade -= 10
		else
			self.fade += 10
		end
		self:markDirty()
	end
end

function Level:draw(x, y, width, height)
	background.tilemap:draw(0, 0, Rect.new(x, y, width, height))
	walls.tilemap:draw(0, 0, Rect.new(x, y, width, height))
	if self.fade then
		local black = gfx.image.new(displayWidth, displayHeight, gfx.kColorBlack)
		black:drawFaded(cameraX, cameraY, self.fade / 100, gfx.image.kDitherTypeDiagonalLine)
		-- gfx.image.kDitherTypeScreen
	end
end


--! Sprite setup (objects, walls)

function Level:setupObjects()
	for i=1, #self.objects do
		local object = self.objects[i]
		if object.type == 'spawn' then
			-- Set the player spawn point
			player:reset(object.x, object.y)
		else
			-- Create a generic object instance
			local position = Rect.new(object.x, object.y, object.width, object.height)
			local objInstance = LevelObject(position, object.type)
			if object.gid then
				objInstance:setImage(self.tileset.imageTable[object.gid])
			end
			if object.properties then
				objInstance:setProperties(object.properties)
			end
			objInstance:add()
			table.insert(self.objInstances, objInstance)
		end
	end
end

function Level:setupWallSprites()
	-- group wall tiles into larger rects and add collision sprites for them
	-- TODO: Change empty IDs to just {0} once empty tiles are supported
	-- https://devforum.play.date/t/allowing-getcollisionrects-to-use-invalid-tileid/5465
	local walls = gfx.sprite.addWallSprites(walls.tilemap, {0,1,2})
	for i = 1, #walls do
		local w = walls[i]
		w.isWall = true
	end
end


--! Collision Handling

-- function Level:collideDoor(door)
-- 	print('Hit door')
-- 	-- SoundManager:playSound(SoundManager.kSoundCoin)
-- end

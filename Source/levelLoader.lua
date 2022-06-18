-- helper class for loading game data from a Tiled JSON file

-- loads the json file and returns a lua table containing the data
local function getJSONTableFromTiledFile(path)
	local levelData = nil

	local f = playdate.file.open(path)
	if f then
		local s = playdate.file.getSize(path)
		levelData = f:read(s)
		f:close()

		if not levelData then
			print('ERROR LOADING DATA for ' .. path)
			return nil
		end
	end

	local jsonTable = json.decode(levelData)

	if not jsonTable then
		print('ERROR PARSING JSON DATA for ' .. levelPath)
		return nil
	end

	return jsonTable
end

-- returns the first tileset contained in the JSON table
local function getTilesetFromJSON(jsonTable)
	local tileset = jsonTable.tilesets[1]
	local newTileset = {}

	newTileset.firstgid = tileset.firstgid
	newTileset.lastgid = tileset.firstgid + tileset.tilecount - 1
	newTileset.name = tileset.name
	newTileset.tileHeight = tileset.tileheight
	newTileset.tileWidth = tileset.tilewidth
	local tilesetImageName = string.sub(tileset.image, 4, string.find(tileset.image, '-table-') - 1)
	newTileset.imageTable = playdate.graphics.imagetable.new(tilesetImageName)

	return newTileset
end

-- returns custom layer tables containing the data, which are basically a subset of the layer objects found in the Tiled file
function getTilemapsFromJSON(jsonTable, tileset)

	-- create tilemaps from the level data and already-loaded tilesets
	local layers = {}

	for i=1, #jsonTable.layers do
		local level = {}

		local layer = jsonTable.layers[i]
		level.name = layer.name
		level.x = layer.x
		level.y = layer.y
		level.tileHeight = layer.height
		level.tileWidth = layer.width

		if layer.type == 'tilelayer' then
			level.pixelHeight = level.tileHeight * tileset.tileHeight
			level.pixelWidth = level.tileWidth * tileset.tileWidth

			local tilemap = playdate.graphics.tilemap.new()
			tilemap:setImageTable(tileset.imageTable)
			tilemap:setSize(level.tileWidth, level.tileHeight)

			-- we want our indexes for each tileset to be 1-based, so remove the offset that Tiled adds.
			-- this is only makes sense because because we have exactly one tilemap image per layer
			local indexModifier = tileset.firstgid-1

			local tileData = layer.data

			local x = 1
			local y = 1

			for j=1, #tileData do
				local tileIndex = tileData[j]

				if tileIndex > 0 then
					tileIndex = tileIndex - indexModifier
					tilemap:setTileAtPosition(x, y, tileIndex)
				end

				x = x + 1
				if x > level.tileWidth then
					x = 1
					y = y + 1
				end
			end

			level.tilemap = tilemap
			layers[layer.name] = level
		end
	end

	return layers
end

function getObjectsFromJSON(jsonTable)
	local objects = {}
	for i=1, #jsonTable.layers do
		local layer = jsonTable.layers[i]
		if layer.type == 'objectgroup' then
			for j=1, #layer.objects do
				local object = layer.objects[j]
				-- Tiled uses bottom-left corner as origin of tile objects
				if object.gid and object.height > 0 then
					object.y -= object.height
				end
				if object.properties ~= nil then
					local properties = object.properties
					object.properties = {}
					for k=1, #properties do
						local property = properties[k]
						object.properties[property.name] = property.value
					end
				end
				table.insert(objects, object)
			end
		end
	end
	return objects
end

-- loads the data we are interested in from the Tiled json file
function importDataFromTiledJSON(path)
	local jsonTable = getJSONTableFromTiledFile(path)

	if jsonTable == nil then
		return
	end

	local tileset = getTilesetFromJSON(jsonTable)
	return tileset, getTilemapsFromJSON(jsonTable, tileset), getObjectsFromJSON(jsonTable)
end

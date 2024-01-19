local Assets = {}

Assets.graphics = setmetatable({}, {__index = function(assets, gfxType)
	local sprites = setmetatable({}, {__index = function(sprites, id)
		if gfxType == 'ui' then
			local name = id
			local path = Files.resolveGraphic(name) or Files.resolveGraphic('graphics/' .. gfxType .. '/' .. name)
			
			local texture = Graphics.newImage(path)
			
			rawset(sprites, id, texture)
			return rawget(sprites, id)
		else
			local name = (gfxType .. '-' .. id)
			local path = Files.resolveGraphic(name) or Files.resolveGraphic('graphics/' .. gfxType .. '/' .. name)
			
			local texture = Graphics.newImage(path)
			
			rawset(sprites, id, texture)
			return rawget(sprites, id)
		end
	end})
	
	rawset(assets, gfxType, sprites)
	return rawget(assets, gfxType)
end})

local iniParser = require("src.lib.parser.ini")
local soundIni

Assets.sounds = setmetatable({}, {__index = function(_, id)
	soundIni = soundIni or iniParser.read("sounds.ini")

	local data = soundIni['sound-' .. id]
	
	data['hidden'] = (data.hidden or 0)
	data['single-channel'] = (data['single-channel'] or 0)
	data['volume'] = (data.volume or 1)
	data['pitch'] = (data.pitch or 1)
	
	rawset(Assets.sounds, id, data)
	return rawget(Assets.sounds, id)
end})

local function findContent(path) return pcallext(require, path) end

Assets.content = setmetatable({}, {__index = function(_, object)
	rawset(Assets.content, object, setmetatable({}, {__index = function(self, id)
		local libPath = (object .. '-' .. id)
		
		local _ENV = {
			ID = id,
		}
		setmetatable(_ENV, {__index = _G})

		local content = findContent(libPath) or findContent('content/' .. object .. '/' .. libPath)
		
		rawset(self, id, content)
		return rawget(self, id)
	end}))
	
	return rawget(Assets.content, object)
end})

return Assets
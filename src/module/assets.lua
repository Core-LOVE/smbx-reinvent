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

return Assets
local Assets = {}

function Assets.getTexture(path)
	
end

local function findTexture(path) return pcallext(love.graphics.newImage, path) end

Assets.graphics = setmetatable({}, {__index = function(_, object)
	if object == "ui" then
		rawset(Assets.graphics, object, setmetatable({}, {__index = function(self, id)
			local imgPath = (id .. '.png')
			
			local texture = findTexture(imgPath) or findTexture('graphics/' .. object .. '/' .. imgPath)
			
			rawset(self, id, texture)
			return rawget(self, id)
		end}))
	else
		rawset(Assets.graphics, object, setmetatable({}, {__index = function(self, id)
			local imgPath = (object .. '-' .. id .. '.png')
			
			local texture = findTexture(imgPath) or findTexture('graphics/' .. object .. '/' .. imgPath)
			
			rawset(self, id, texture)
			return rawget(self, id)
		end}))
	end
	
	return rawget(Assets.graphics, object)
end})

local function findContent(path) return pcallext(require, path) end

Assets.content = setmetatable({}, {__index = function(_, object)
	rawset(Assets.content, object, setmetatable({}, {__index = function(self, id)
		local libPath = (object .. '-' .. id)
		
		local content = findContent(libPath) or findContent('content/' .. object .. '/' .. libPath)
		
		rawset(self, id, content)
		return rawget(self, id)
	end}))
	
	return rawget(Assets.content, object)
end})

local iniParser = require("utils.parser.ini")
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

Assets.backgrounds = setmetatable({}, {__index = function(_, id)
	local path = ("background2-" .. id .. ".ini")
	
	path = Files.resolve(path) or Files.resolve("config/background2/" .. path)
	
	if path then
		local data = iniParser.read(path)
		
		data.main = data['background2'] or data[""]
		data['background2'] = nil
		data[""] = nil
		
		data._layers = {}
		
		for layerName, layerData in pairs(data) do
			if layerName == 'background2' then
				table.insert(data._layers, layerData)
				data[layerName] = nil
			end
		end
		
		rawset(Assets.backgrounds, id, data)
		return rawget(Assets.backgrounds, id)
	end
end})

return Assets
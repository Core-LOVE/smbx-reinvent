local Audio = {}

local la = love.audio

local function createSource(file, type, isGME)
	if isGME then
		-- local gme = LoveGme()
		-- gme:loadFile(file)
		
		-- return gme.source
	else
		return la.newSource(file, type)
	end
end

function Audio.sfx(name, volume, pitch, loop)
	local volume = (volume or 1)
	local pitch = (pitch or 1)
	local source
	
	if tonumber(name) then
		local sfx = Assets.sounds[tonumber(name)]
		
		volume = sfx.volume or volume
		pitch = sfx.pitch or pitch
		
		local file, isGME = Files.resolveAudio(sfx.file)
		
		source = createSource(file, sfx.type or 'static', isGME)
	else
		local file, isGME = Files.resolveAudio(name)
		
		source = createSource(file, 'static', isGME)
	end
	
	if loop then
		source:setLooping(true)
	end
	
	source:setVolume(volume)
	source:setPitch(pitch)
	
	source:play()
	
	return source
end

return Audio
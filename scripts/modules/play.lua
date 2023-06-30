local Play = {}

local la = love.audio

function Play.sound(name, volume, pitch, loop)
	local volume = (volume or 1)
	local pitch = (pitch or 1)
	local source
	
	if tonumber(name) then
		local sfx = Assets.sounds[tonumber(name)]
		
		volume = volume or sfx.volume
		pitch = pitch or sfx.pitch
		
		local file = Files.resolveAudio(sfx.file)
		
		source = la.newSource(file, sfx.type or 'static')
	else
		local file = Files.resolveAudio(name)
		
		source = la.newSource(file, 'static')
	end
	
	if loop then
		source:setLooping(true)
	end
	
	source:setVolume(volume)
	source:setPitch(pitch)
	
	source:play()
	
	return source
end

return Play
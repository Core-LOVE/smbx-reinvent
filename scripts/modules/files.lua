local Files = {}

local lfs = love.filesystem

Files.read = lfs.read
Files.write = lfs.write
Files.lines = lfs.lines
Files.exists = lfs.getInfo
Files.iterate = lfs.getDirectoryItems

function Files.resolve(path)
	if Files.exists(path) then
		return path
	end
end

do
	local formats = {
		'.ogg',
		'.mp3',
		'.wav',
		'.flac',
		'.ogv',
		'.oga',
		'.699', '.amf', '.ams', '.dbm', '.dmf', '.dsm', '.far', '.it', '.j2b', '.mdl', '.med', '.mod', '.mt2', '.mtm', '.okt', '.psm', '.s3m', '.stm', '.ult', '.umx', '.xm',
	}
	
	local formatCount = #formats
	
	function Files.resolveAudio(path)
		for i = 1, formatCount do
			local form = formats[i]
			local path = Files.resolve(path .. form) or Files.resolve('sound/' .. path .. form)
			
			if path then return path end
		end
	end
end

do
	local formats = {
		'.png',
		'.jpg',
		'.jpeg',
		'.bmp',
		'.tga',
		'.hdr',
		'.plc',
		'.exr',
	}
	
	local formatCount = #formats
	
	function Files.resolveGraphic(path)
		for i = 1, formatCount do
			local form = formats[i]
			local path = Files.resolve(path .. form) or Files.resolve('graphics/' .. path .. form)
			
			if path then return path end
		end
	end
end

return Files
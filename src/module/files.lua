local Files = love.filesystem

function Files.noExtension(path)
	return path:match("(.+)%..+")
end

function Files.resolve(path)
	if Files.getInfo(path) then
		return path
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
			local path = Files.resolve(path .. form)
			
			if path then return path end
		end
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
		
		-- GME
		'.nsf',
		'.spc',
		'.gbs',
		'.gym',
		'.nsfe',
		'.vgm',
		'.vgz',
		
		-- Other
		'.699', '.amf', '.ams', '.dbm', '.dmf', '.dsm', '.far', '.it', '.j2b', '.mdl', '.med', '.mod', '.mt2', '.mtm', '.okt', '.psm', '.s3m', '.stm', '.ult', '.umx', '.xm',
	}
	
	local gmeFormats = {
		['.nsf'] = true,
		['.spc'] = true,
		['.gbs'] = true,
		['.gym'] = true,
		['.nsfe'] = true,
		['.vgm'] = true,
		['.vgz'] = true,
	}
	
	local formatCount = #formats
	
	function Files.resolveAudio(path)
		for i = 1, formatCount do
			local form = formats[i]
			local path = Files.resolve(path .. form) or Files.resolve('sound/' .. path .. form)
			
			if path then return path, gmeFormats[form] end
		end
	end
end

return Files
local LevelParser = {}

LevelParser.formats = {}

do
	local types = {}

	types['HEAD'] = function(settings)

	end

	types['SECTION'] = function(settings)
		local x = settings.L
		local y = settings.T
		
		local w = (settings.R - x)
		local h = (settings.B - y)
		
		local v = Section.spawn(x, y, w, h)
	end

	types['STARTPOINT'] = function(settings)
		local v = Player.spawn(1, settings.X, settings.Y)
		
		v.direction = settings.D
	end
	
	types['BLOCK'] = function(settings)
		local v = Block.spawn(settings.ID, settings.X, settings.Y)
		
		v.width = settings.W
		v.height = settings.H
	end

	types['NPC'] = function(settings)
		local v = NPC.spawn(settings.ID, settings.X, settings.Y)
		v.direction = settings.D
		v.dontMove = settings.NM or false
	end
	
	-- types['BGO'] = function(settings)
		-- local v = BGO.spawn(settings.ID, settings.X, settings.Y)
	-- end
	
	LevelParser.formats['.lvlx'] = function(path)
		local type
		
		for line in Files.lines(path) do
			local canParse = true
			
			if type == nil then
				type = line
				canParse = false
			else
				if line:match('END') then
					type = nil
				end
			end
			
			if not (type == nil or types[type] == nil) and canParse then	
				local settings = {}
				
				for key, val in line:gmatch("(%w+):([^%;]+)") do
					local val = val
					
					local tonum = tonumber(val)
					if (tonum ~= nil) then
						val = tonum
					end
					
					settings[key] = val
				end
				
				types[type](settings)
			end
		end
	end
end

function LevelParser.read(path)
	for format, f in pairs(LevelParser.formats) do
		if path:find(format) then
			return f(path)
		end
	end
end

return LevelParser
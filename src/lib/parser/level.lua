local LevelParser = {}

LevelParser.formats = {}

do
	local types = {}
	
	types.version = function(val)
		return "maxStars"
	end
	
	types.maxStars = function(val)
		return "levelName"
	end
	
	types.levelName = function(val)
		return "section", "x"
	end
	
	types.section = function(val, property)
		return "section"
	end
	
	local actions = {}
	
	-- LevelParser.formats['.lvl'] = function(path)
	-- 	local data = {}
		
	-- 	local currentType = "version"
	-- 	local currentProperty = {}
	-- 	local currentData = {}

	-- 	for line in Files.lines(path) do
	-- 		local changeInto = types[currentType](line, currentProperty)
			
	-- 		if changeInto then
	-- 			if actions[currentType] then
	-- 				actions[currentType](currentData)
	-- 			end
				
	-- 			currentType = changeInto
	-- 		end
	-- 	end
	-- end
end

do
	local types = {}

	types['HEAD'] = function(settings)

	end

	types['SECTION'] = function(settings)
		local x = settings.L
		local y = settings.T
		
		local w = (settings.R - x)
		local h = (settings.B - y)
		
		local v = Section:new(x, y, w, h)
	end

	types['STARTPOINT'] = function(settings)
		local v = Player:new('mario', settings.X, settings.Y)
		v.direction = settings.D
	end
	
	types['BLOCK'] = function(settings)
		local v = Block:new(settings.ID, settings.X, settings.Y)
		
		-- v:setSize(settings.W, settings.H)
	end

	types['NPC'] = function(settings)
		local v = NPC:new(settings.ID, settings.X, settings.Y)
		v.direction = settings.D
		v.dontMove = settings.NM or false
	end
	
	types['DOORS'] = function(settings)
		-- local id = settings.DT
		
		-- local ext = Warp.spawn(id, settings.OX, settings.OY)
		-- ext.direction = settings.OD
		
		-- local ent = Warp.spawn(id, settings.IX, settings.IY)
		-- ent.exit = ext
		-- ent.direction = settings.ID
		
		-- if settings.TW then
			-- ext.exit = ent
		-- end
	end
	
	types['BGO'] = function(settings)
		local v = BGO:new(settings.ID, settings.X, settings.Y)
	end
	
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
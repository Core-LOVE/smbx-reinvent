local Properties = require("utils.classproperties")
local Config = Class('Config')
Config:include(Properties)

local iniParser = require("utils.parser.ini")

function Config:initialize(name, id, args)
	for k,v in pairs(args) do
		self[k] = v
	end
	
	local path = (name .. '-' .. id .. '.txt')
	local full_path = Files.resolve(path) or Files.resolve('config/' .. name .. '/' .. path)
	
	if full_path then
		local data = iniParser.read(full_path)[""]
		
		for k,v in pairs(data) do
			self[k] = v
		end
	end
end

function Config.register(name, args)
	return setmetatable({}, {__index = function(self, id)
		rawset(self, id, Config:new(name, id, args))
		return rawget(self, id)
	end})
end

return Config
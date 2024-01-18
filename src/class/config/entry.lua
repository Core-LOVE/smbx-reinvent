-- local Properties = require("src.lib.classProperties")
local ConfigEntry = Class('ConfigEntry')
ConfigEntry:include{
	__index = function(self, k)
		local defaults = self.config.defaults
	    local fn = defaults['get_' .. k]
		
	    if fn then
	    	return fn(self)
	    else
	    	return defaults[k]
	    end
	end,

	__newIndex = function(self, k, v)
		local defaults = self.config.defaults
	    local fn = defaults['set_' .. k]
		
	    if fn then
	    	fn(self, v)
	    else
	    	rawset(self, k, v)
	    end
	end,
}

local iniParser = require("src.lib.parser.ini")

function ConfigEntry:loadData()
	local config = self.config
	local name, id = config.name, self.id
	
	local path = (name .. '-' .. id .. '.txt')
	local full_path = Files.resolve(path) or Files.resolve('config/' .. name .. '/' .. path)
	
	if full_path then
		local data = iniParser.read(full_path)[""]
		
		for k,v in pairs(data) do
			self[k] = v
		end
	end
end

local function tableclone(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = v
  end
  return t2
end

function ConfigEntry:initialize(config, id)
	self.config = config
	self.id = id
	
	self:loadData()
end

return ConfigEntry
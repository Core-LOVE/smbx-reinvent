local Config = Class('Config')
Config:include{
	__index = function(self, k)
	    rawset(self, k, ConfigEntry:new(self, k))
		return rawget(self, k)
	end
}

local Properties = require("src.lib.classProperties")

function Config:initialize(name, defaults)
	self.name = name
	self.defaults = defaults
end

function Config:replaceDefaults(...)
	-- body
end

return Config
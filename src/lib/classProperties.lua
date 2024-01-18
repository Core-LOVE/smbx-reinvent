-- properties.lua
local Properties = {}

function Properties:__index(k)
  return self['get_' .. k]
end

function Properties:__newIndex(k, v)
    local fn = self['set_' .. k]
	
    if fn then
      fn(self, v)
    else
      rawset(self, k, v)
    end
end

return Properties
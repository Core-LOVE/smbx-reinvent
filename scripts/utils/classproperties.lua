local Properties = {}

function Properties:__index(k)
	if self['get_' .. k] then
		return self['get_' .. k]
	end
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
-- Thanks to lukems and kikito
local Properties = {}

function Properties:__index(k)
    local getter = self.class.__instanceDict["get_" .. k]
    if getter ~= nil then
        return getter(self)
    end
end

function Properties:__newindex(k, v)
    local setter = self["set_" .. k]
    if setter ~= nil then
        setter(self, v)
    else
        rawset(self, k, v)
    end
end

return Properties
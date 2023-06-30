local Input = {}

local keyCache = {}

KEYS_UP = nil
KEYS_DOWN = true
KEYS_PRESSED = 1
KEYS_RELEASED = 0

Signal.register('onKeyUpdate', function()
	for key,val in pairs(keyCache) do
		if val == KEYS_RELEASED then
			keyCache[key] = nil
		elseif val == KEYS_PRESSED then
			keyCache[key] = KEYS_DOWN
		end
	end
end)

Signal.register('onKeyPressed', function(key)
	keyCache[key] = KEYS_PRESSED
end)

Signal.register('onKeyReleased', function(key)
	keyCache[key] = KEYS_RELEASED
end)

function Input.get(name)
	local key = keyCache[name]
	
	return (key == nil and KEYS_UP) or key
end

return Input
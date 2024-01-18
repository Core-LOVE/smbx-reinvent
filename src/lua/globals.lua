local old_type = type

_G.type = function(t)
	local _type = old_type(t)

	if _type == 'table' and t.class then
		return t.class.name
	end

	return _type
end
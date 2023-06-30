function pcallext(f, arg)
	local res
	
	if pcall(function() res = f(arg) end) then
		return res
	end
end

function hook(orig, new)
	return function(...)
		return new(orig, ...)
	end
end
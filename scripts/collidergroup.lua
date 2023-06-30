local ColliderGroup = Class('ColliderGroup')

function ColliderGroup:initialize(...)
	self.colliders = {...}
end

function ColliderGroup:update()	
	for k,collider in ipairs(self.colliders) do
		collider:update()
	end
end

function ColliderGroup:remove()
	for k,collider in ipairs(self.colliders) do
		Game:stage().world:remove(collider)
	end
end

function ColliderGroup:move()
	for k,collider in ipairs(self.colliders) do
		local xto, yto = collider:move()
		
		if xto ~= nil or yto ~= nil then
			return xto, yto
		end
	end
end

return ColliderGroup
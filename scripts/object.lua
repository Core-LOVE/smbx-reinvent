local Object = Class('Object')

function Object:initialize(x, y, width, height)
	self.active = true
	self.isHidden = false
	
	self.x = x or 0
	self.y = y or 0
	self.speedX = 0
	self.speedY = 0
	self.width = width or 0
	self.height = height or 0

	self.scale_x = 1
	self.scale_y = 1
	self.rotation = 0
	self.skew_x = 0
	self.skew_y = 0
	self.origin_x = 0
	self.origin_y = 0
	self.offset_x = 0
	self.offset_y = 0
	
	self.initX = self.x
	self.initY = self.y
	
    self.parent = nil
    self.children = {}
	self.children_hidden = false
	
	self.collidable = true
	self.transform = Transform:new(self.x, self.y, self.rotation, self.scale_x, self.scale_y, self.origin_x, self.origin_y, self.skew_x, self.skew_y)
end

function Object:postInitialize() end

function Object:getPriority()
	return -65
end

function Object:remove()
	for k,v in ipairs(self.children) do
		v:remove()
	end
	
	local parent = self.parent
	
	if parent then
		for k,v in ipairs(parent.children) do
			if v == self then
				table.remove(parent.children, k)
				break
			end
		end
	end
end

function Object:addChildren(child)
	child.parent = self
	return table.insert(self.children, child)
end

function Object:drawChildren()
	if self.children_hidden then return end
	
	for k,child in ipairs(self.children) do
		child:draw()
	end
end

function Object:updateChildren()
	for k,child in ipairs(self.children) do
		child:update()
	end
end

function Object:render() end

function Object:getZ()
	return 0
end

function Object:draw(cam) 
	if (self.isHidden) then return end
	
	Draw.push()
		
		Draw.translate(self.x + self.offset_x, self.y + self.offset_y)
		Draw.scale(self.scale_x, self.scale_y)
		Draw.rotate(self.rotation)
		Draw.skew(self.skew_x, self.skew_y)
		
		local oldZ = Draw.getZ()
		Draw.setZ(self:getZ())
		
		self:render(cam)
		
		-- if self.type ~= "Block" then 
			-- Draw.rectangle('line', 0, 0, self.width, self.height)
		-- end
		
		self:drawChildren()
		
		Draw.setZ(oldZ)
		
	Draw.pop()
end

function Object:update()
	self.transform:borrow(self)
	self:updateChildren()
end

function Object:collidesWith(other)
    -- if other and self.collidable and self.collider then
		-- return other.collidable and other.collider and self.collider:collidesWith(other.collider) or false
    -- end
	
    return false
end

return Object
local Object = Class('Object')

function Object:initialize(x, y, width, height)
	self.active = true
	self.isHidden = false
	
	self.x = x or 0
	self.y = y or 0
	self.speedX = 0
	self.speedY = 0
	self.gravity = 0
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
end

function Object:getGravity()
	return self.gravity
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

function Object:update()
	self:updateChildren()
	self:physics()
end

function Object:physics()
	self.speedY = self.speedY + self:getGravity()
	
	self.x = self.x + self.speedX
	self.y = self.y + self.speedY
end

function Object:draw(cam) 
	if (self.isHidden) then return end
	
	Graphics.push()
		
		Graphics.translate(self.x + self.offset_x, self.y + self.offset_y)
		Graphics.scale(self.scale_x, self.scale_y)
		Graphics.rotate(self.rotation)
		Graphics.skew(self.skew_x, self.skew_y)
		
		self:render(cam)
		
		-- if self.type ~= "Block" then 
			-- Draw.rectangle('line', 0, 0, self.width, self.height)
		-- end
		
		self:drawChildren()
		
	Graphics.pop()
end

function Object:render(cam) end
function Object:behave() end
function Object:animation() end

return Object
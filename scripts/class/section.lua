local Section, super = Class('Section', Object)

function Section.spawn(...)
	local self = Section:new(...)
	
	table.insert(Section, self)
	return self
end

function Section:bound(name)
	if name == 'left' then
		return self.x
	elseif name == 'top' then
		return self.y
	elseif name == 'bottom' then
		return self.y + self.height
	else
		return self.x + self.width
	end
end

function Section:initialize(x, y, w, h)
	super.initialize(self, x, y, w or 800, h or 600)
end

function Section:render(cam)
	-- Draw.setScissor(self.x, self.y, self.width, self.height)
	
	local r, g, b, a = Draw.color()
	
	Draw.color(0, 0, 0)
	Draw.rectangle('fill', 0, 0, self.width, self.height)
	Draw.color(r, g, b, a)
	
	Draw.background(1, self, cam)
	-- Draw.setScissor()
end

function Section:getZ()
	return LAYERS.BG_COLOR
end

function Section:draw(cam)
	if self.isHidden then return end
	
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
		
		Draw.setZ(oldZ)
		
		self:drawChildren()
		
	Draw.pop()
end

return Section
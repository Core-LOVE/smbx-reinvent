local Section = Class('Section')

function Section.spawn(...)
	local self = Section:new(...)
	
	table.insert(Section, self)
	return self
end

function Section:initialize(x, y, w, h)
	self.x = x or 0
	self.y = y or 0
	self.width = w or 800
	self.height = h or 600
end

return Section
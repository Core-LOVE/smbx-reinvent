local Section, super = Class('Section', Object)

function Section:initialize(x, y, w, h)
	super.initialize(self, x, y, w, h)
	
	table.insert(Section, self)
end

return Section
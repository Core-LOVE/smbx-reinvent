local Physics = {}

function Physics:collisions()
	local xto, yto = self.collider:move()

	if not self.collidesSlope then
		self.y = yto
	end
	
	self.x = xto
end

return Physics
local Keys = Class('Keys')

Keys[1] = {
	jump = 'z',
	altJump = 'a',
	
	run = 'x',
	altRun = 's',
	
	left = 'left',
	right = 'right',
	up = 'up',
	down = 'down',
}

function Keys:initialize(id)
	self.id = id or 1
end

function Keys:update()
	local map = Keys[self.id]
	
	for name, key in pairs(map) do
		self[name] = Input.get(key)
	end
end

return Keys
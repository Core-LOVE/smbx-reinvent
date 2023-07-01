local lg = love.graphics

local stack = {}
local stackDepth = 0

function love.graphics.getStackDepth()
	return stackDepth
end

function love.graphics.push()
	
end
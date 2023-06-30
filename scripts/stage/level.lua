local Level, super = Class('Level', Object)

local splash = require("utils.splash")

function Level:initialize(path)
	local camera = Camera.spawn(0, 0)
	
	-- camera.update = hook(camera.update, function(orig, self)
		-- orig(self)
		
		-- self.renderX = self.renderX + 1
		-- self.scale_x = self.scale_x + 0.001
		-- self.scale_y = self.scale_x
	-- end)
	
	-- self.camera2 = Camera.spawn(400, 0)
	
	self.isTitle = false
	self.world = splash.new()
end

function Level:update(dt)
	Block.animation.update()
	
	for _,obj in ipairs(NPC) do
		obj:update()
	end
	
	for _,obj in ipairs(Player) do
		obj:update()
	end
	
	for _, obj in ipairs(Camera) do
		obj:update()
	end
end

function Level:draw()
		-- local p = Player[1]
		
		-- if not p then return love.graphics.pop() end
		-- love.graphics.translate(p.x - 400, p.y - 300)
	for _, obj in ipairs(Camera) do
		obj:draw()
	end
	
	-- for _,obj in ipairs(NPC) do
		-- obj:draw()
	-- end
	
	-- for _,obj in ipairs(Block) do
		-- obj:draw()
	-- end
	
	-- for _,obj in ipairs(Player) do
		-- obj:draw()
	-- end
end

do
	local curtain = Assets.graphics.ui['MenuGFX1']
	local logo = Assets.graphics.ui['MenuGFX2']
	
	function Level:render_hud(camera)
		if not self.isTitle then return end
		
		Draw.push()
		
		local x = (camera.width * .5) - (logo:getWidth() * .5) 
		local y = curtain:getHeight() + 16
			
		Draw.texture(logo, x, y)
		Draw.texture(curtain, 0, 0)
		
		Draw.pop()
	end
end

function Level:render(camera)
	Draw.push()
	
	Draw.clear()
	
	Draw.translate(-camera.x, -camera.y)
	
	for _,obj in ipairs(BGO) do
		obj:draw()
	end
	
	for _,obj in ipairs(NPC) do
		obj:draw()
	end
	
	for _,obj in ipairs(Block) do
		obj:draw()
	end
	
	for _,obj in ipairs(Player) do
		obj:draw()
	end
	
	Draw.update()
	
	Draw.translate(camera.x, camera.y)
	Draw.pop()
end

return Level
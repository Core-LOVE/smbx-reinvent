local Block, super = Class('Block', Object)

local splash = require("utils.splash")

Block.type = "Block"

Block.static.config = Config.register("block", {
	width = 32,
	height = 32,
	
	frames = 1,
	framespeed = 0,
	
	floorslope = 0,
	ceilingslope = 0,
	semisolid = false,
	sizable = false,
	
	pswitch = false,
	
	smashable = false,
	bumpable = false,
})

Block.static.bumped = {}

Block.static.animation = setmetatable({
	update = function()
		for id, data in ipairs(Block.animation) do
			local cfg = Block.config[id]
			
			if cfg.frames > 1 then
				data.frameTimer = data.frameTimer + 1
				
				if data.frameTimer >= cfg.framespeed then
					data.frame = (data.frame + 1) % cfg.frames
					data.frameTimer = 0
				end
			end
		end
	end
}, {__index = function(_, id)
	local data = {
		frame = 0,
		frameTimer = 0,
	}
	
	rawset(Block.animation, id, data)
	return rawget(Block.animation, id)
end})

function Block:onConfigChange(name, old, new)
	
end

function Block.spawn(id, x, y)
	local class = Assets.content.block[id] or Block
	local self = class:new(id, x, y)
	
	self.idx = #Block + 1
	
	self:postInitialize()
	
	table.insert(Block, self)
	return self
end

function Block:defaultCollider()
	return Collider(self, 'box', self.x, self.y, self.width, self.height)
end

function Block:setSize(w, h)
	self.width = w
	self.height = h
	
	self.collider:remove()
	self.collider = self:defaultCollider()
end

function Block:initialize(id, x, y)
	self.id = id
	
	local cfg = Block.config[id]
	
	super.initialize(self, x, y, cfg.width, cfg.height)
	
	self.collider = self:defaultCollider()
end

HIT_UP = true
HIT_DOWN = false
HIT_LEFT = -1
HIT_RIGHT = 1

function Block:hit(side, culprit, hitcount)
	-- if true then
		-- return self:remove(true)
	-- end
	
	local side = side or HIT_DOWN
	
	Timer.tween(0.1, self, {offset_y = -16}, nil, function()
		Timer.tween(0.1, self, {offset_y = 0}, nil, function()
			for k,v in ipairs(Block.bumped) do
				if v == self then table.remove(Block.bumped, k) end
			end
		end)
	end)
	
	-- local cam = Camera[1]
	-- cam:tween(7, {render_scale_x = 0.5, render_scale_y = 0.5}, 'out-cubic')
	
	table.insert(Block.bumped, self)
end

function Block:remove(fx)
	super.remove(self)
	self.collider:remove()
	
	for k,v in ipairs(Block) do
		if v == self then
			return table.remove(Block, k)
		end
	end
	
	if fx then
		Play.sound(4)
		Effect.spawn(1, self.x, self.y)
	end
end

function Block:getZ()
	return LAYERS.BLOCK
end

function Block:render_sizable(cam)
	local texture = Assets.graphics.block[self.id]
	local bHeight = self.height / 32
	
	for B = 0, bHeight do
		local bWidth = self.width / 32
		
		for C = 0, bWidth do
			local pos = {
				x = C * 32,
				y = B * 32,
			}
			
			if cam:collidesWith(pos) then
				local D = C
				local E = B
				
				if D ~= 0 then
					if math.floor(D) == bWidth - 1 then
						D = 2
					else
						D = 1
					end
				end
				
				if E ~= 0 then
					if math.floor(E) == bHeight - 1 then
						E = 2
					else
						E = 1
					end
				end
				
				local quad = love.graphics.newQuad(D * 32, E * 32, 32, 32, texture:getDimensions())
				
				Draw.texture(texture, quad, pos.x, pos.y)
			end
		end
	end
end

function Block:render(cam)
	local id = self.id
	local cfg = Block.config[id]
	
	if cfg.sizable then self:render_sizable(cam) end
	
	local texture = Assets.graphics.block[id]
	local quad = love.graphics.newQuad(0, self.height * Block.animation[id].frame, self.width, self.height, texture:getDimensions())
	
	Draw.texture(texture, quad, 0, 0)
end

return Block
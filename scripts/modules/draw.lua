local Draw = {}

LAYERS = {
	BG_COLOR = -102,
	LEVEL_BG = -100,
	
	FAR_BGO = -95,
	BGO = -85,
	SPECIAL_BGO = -80,
	FOREGROUND_BGO = -20,
	
	SIZEABLE = -90,
	FOREGROUND_BLOCK = -10,
	BLOCK = -65,
	
	BG_NPC = -75,
	FROZEN_NPC = -50,
	NPC = -45,
	HELD_NPC = -30,
	FOREGROUND_NPC = -15,
	SPECIAL_NPC = -55,
	
	WARPING_PLAYER = -70,
	CLOWN_CAR = -35,
	PLAYER = -25,
	
	BG_EFFECT = -60,
	FOREGROUND_EFFECT = -5,
	
	DEFAULT = 1,
	TEXT = 3,
	MESSAGE_ICON = -40,
	HUD = 5,
}

local queue = {}
local queueCount = 0
local stack = {}
local stackDepth = 0
local z = 0

local tablesort = table.sort
local tableremove = table.remove

local lg = love.graphics
lg.setDefaultFilter("nearest", "nearest")
 
local function sort(a, b)
	return (a[2] > b[2])
end

local transform
	
local function drawMethod(method)
	return function(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
		local transform = Transform:new(0, 0, 0, 1, 1, 0, 0, 0, 0)
	
		for i = 1, stackDepth do
			transform:apply(stack[i].transform)
		end
		
		local z = z
		local sx, sy, sw, sh = lg.getScissor()
		local r, g, b, a = lg.getColor()
		
		queueCount = queueCount + 1
		queue[queueCount] = {function()
			lg.push()
			
			lg.setColor(r, g, b, a)
			lg.applyTransform(transform.transform)

			if sx then
				lg.setScissor(sx, sy, sw, sh)
			end
		
			method(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
			
			if sx then
				lg.setScissor()
			end
			
			lg.pop()
		end, z}
	end
end

Draw.texture = drawMethod(lg.draw)
Draw.rectangle = drawMethod(lg.rectangle)
Draw.circle = drawMethod(lg.circle)

function Draw.line(x, y, x2, y2)
	local transform = Transform:new(0, 0, 0, 1, 1, 0, 0, 0, 0)
	
	for i = 1, stackDepth do
		transform:apply(stack[i].transform)
	end
	
	local z = z
	local sx, sy, sw, sh = lg.getScissor()
	
	queueCount = queueCount + 1
	queue[queueCount] = {function()
		lg.push()
		
		lg.applyTransform(transform.transform)
		
		if sx then
			lg.setScissor(sx, sy, sw, sh)
		end
		
		lg.line(x, y, x2, y2)
		
		if sx then
			lg.setScissor()
		end
		
		lg.pop()
	end, z}
end

ALIGN = {
	BOTTOM = 1,
	TOP = 0,
	CENTER = 0.5,
	CENTRE = 0.5,
}

function Draw.background(id, sect, cam)
	local data = Assets.backgrounds[id]

	for idx = 1, #data.layers do
		local layer = data.layers[idx]
		local texture = layer.img
		
		for dx = 0, (layer.repeatX and sect.width) or 0, texture:getWidth() do
			for dy = 0, (layer.repeatY and sect.height) or 0, texture:getHeight() do
				Draw.push()
				
				local x = (sect:bound(string.lower(layer.alignX or 'LEFT')) - texture:getWidth() - cam.x) * layer.parallaxX
				local y = (sect:bound(string.lower(layer.alignY or 'BOTTOM')) - texture:getHeight() - cam.y) * layer.parallaxY
				x = x + layer.x
				y = y + layer.y
				
				local z = Draw.getZ()
				
				Draw.setZ(layer.priority)
				Draw.texture(texture, x + dx, y + dy)
				Draw.setZ(z)
				
				Draw.pop()
			end
		end
	end
end

function Draw.update()
	tablesort(queue, sort)
	
	-- lg.push()
	
	-- for i = 1, stackDepth do
		-- lg.applyTransform(stack[i].transform)
	-- end
	
	for i = queueCount, 1, -1 do
		queue[i][1]()
		tableremove(queue, i)
	end
	
	queueCount = 0
	-- queue = {}
end

function Draw.stack()
	return stack
end

function Draw.push()
	stackDepth = stackDepth + 1
	stack[stackDepth] = Transform:new(0, 0, 0, 1, 1, 0, 0, 0, 0)
end

function Draw.pop()
	stack[stackDepth] = nil
	stackDepth = stackDepth - 1
end

local function generateTransformMethod(name)
	Draw[name] = function(...)
		local transform = stack[stackDepth]
		
		transform[name](transform, ...)
	end
end

generateTransformMethod('translate')
generateTransformMethod('skew')
generateTransformMethod('rotate')
generateTransformMethod('scale')

Draw.rawPush = lg.push
Draw.rawPop = lg.pop
Draw.rawTranslate = lg.translate
Draw.rawSkew = lg.shear
Draw.rawRotate = lg.rotate
Draw.rawScale = lg.scale

Draw.clear = lg.clear

Draw.setScissor = lg.setScissor
Draw.getScissor = lg.getScissor

Draw.newQuad = lg.newQuad

function Draw.setZ(val)
	z = val
end

function Draw.getZ(val)
	return z
end

function Draw.color(...)
	if select('#', ...) == 0 then
		return lg.getColor()
	else
		return lg.setColor(...)
	end
end
 
return Draw
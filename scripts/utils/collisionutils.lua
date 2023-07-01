local CollisionUtils = {}

local splash = require("utils.splash")

local function clamp(val,min,max)
	return math.max(math.min(val,max),min)
end

local function getSlopeEjectionPosition(v,solid, floorslope, ceilingslope,slopeDirection)
	local vSide     = (v.x    +(v.width    *0.5))-((v.width    *0.5)*slopeDirection)
	local solidSide = (solid.x+(solid.width*0.5))+((solid.width*0.5)*slopeDirection)

	local distance = (solidSide-vSide)*slopeDirection

	if floorslope ~= 0 then
		return (solid.y+solid.height) - (clamp(distance/solid.width,0,1) * solid.height) - v.height
	elseif ceilingslope ~= 0 then
		return solid.y + (clamp(distance/solid.width,0,1) * solid.height)
	end
end

local function lazySlopes(v, solid, blockCfg)
	local blockCfg = blockCfg or Block.config[solid.id]
	
	local floorslope = blockCfg.floorslope
	local ceilingslope = blockCfg.ceilingslope
	
	local slopeDirection = (floorslope ~= 0 and floorslope) or ceilingslope
	local slopeEjectionPos = getSlopeEjectionPosition(v, solid, floorslope, ceilingslope, slopeDirection)
	
	-- if floorslope ~= 0 then
		-- if hitspot == COLLISION_BOTTOM then
			-- return
		-- end
		
		-- if (floorslope == -1 and hitspot == COLLISION_RIGHT) or (floorslope == 1 and hitspot == COLLISION_LEFT) then
			-- return
		-- end
		
		-- v.collidesBlockBottom = true
	-- else
		-- if hitspot == COLLISION_TOP then
			-- return
		-- end
		
		-- if (ceilingslope == 1 and hitspot == COLLISION_RIGHT) or (ceilingslope == -1 and hitspot == COLLISION_LEFT) then
			-- return
		-- end
		
		-- v.collidesBlockTop = true
	-- end
	
	v.y = slopeEjectionPos - 1
	v.speedY = 0
	v.collidesBlockBottom = true
	v.collidesSlope = solid
	
	return true
end

function CollisionUtils.slopes(self, other)
	return lazySlopes(self, other)
	-- local tempWorld = splash.new()
	
	-- local shape
	
	-- if other.id == 332 then
		-- shape = splash.seg(other.x + other.width, other.y - 1, -other.width, other.height)
	-- else
		-- shape = splash.seg(other.x, other.y - 1, other.width, other.height)
	-- end
	
	-- tempWorld:add({}, shape)
	
	-- if self.speedX < 0 then
		-- local x, y = (self.x + self.width), (self.y)
		-- local x2, y2 = x, y + self.height
		
		-- Draw.line(x, y, x2, y2)
		-- local thing, endx, endy, t1 = tempWorld:castRay(x, y, x2, y2)
		
		-- if thing then
			
		-- end
		
		-- local x, y = (self.x + self.width), (self.y) 
		-- local x2, y2 = x, y + self.height
		
		-- Draw.line(x, y, x2, y2)
		-- local thing, endx, endy, t1 = tempWorld:castRay(x, y, x2, y2)
		
		-- if thing then
			
		-- end	
	-- else
	
	-- end
	
	-- do
		-- local x, y = (self.x), (self.y)
		-- local x2, y2 = x, y + self.height
		
		-- local thing, endx, endy, t1 = tempWorld:castRay(x, y, x2, y2)
		
		-- if thing then
			-- return lazySlopes(self, other)
		-- end
	-- end
end

function CollisionUtils.simple(a, b)
   if ((b.x >= a.x + (a.width or 0)) or
		   (b.x + (b.width or 0) <= a.x) or
		   (b.y >= a.y + (a.height or 0)) or
		   (b.y + (b.height or 0) <= a.y)) then
			  return false 
	   else return true
           end
end

return CollisionUtils
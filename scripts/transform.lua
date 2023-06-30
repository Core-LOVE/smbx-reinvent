local Properties = require("utils.classproperties")
local Transform = Class('Transform'):include(Properties)

function Transform:initialize(x, y, angle, sx, sy, ox, oy, kx, ky)
	self._x, self._y = x, y
	self._angle = angle
	self._sx, self._sy = sx, dy
	self._ox, self._oy = ox, oy
	self._kx, self._ky = kx, ky
	
	self.transform = love.math.newTransform(x, y, angle, sx, sy, ox, oy, kx, ky)
end

function Transform:setTransformation(x, y, angle, sx, sy, ox, oy, kx, ky)
	local x = x or self.x
	local y = y or self.y
	local angle = y or self.rotation
	local sx = sx or self.scale_x
	local sy = sy or self.scale_y
	local ox = ox or self.origin_x
	local oy = oy or self.origin_y
	local kx = kx or self.skew_x
	local ky = ky or self.skew_y
	
	self.transform:setTransformation(x, y, angle, sx, sy, ox, oy, kx, ky)
end

local function generate(name, real)
	local real = (real or ("_" .. name))
	
	Transform['get_' .. name] = function(self)
		return self[real]
	end
	
	Transform['set_' .. name] = function(self, val)
		self[real] = val
		self:setTransformation()
	end
end

generate("x")
generate("y")
generate("rotation", "_angle")
generate("scale_x", "_sx")
generate("scale_y", "_sy")
generate("origin_x", "_ox")
generate("origin_y", "_oy")
generate("skew_x", "_kx")
generate("skew_y", "_ky")

local function generate2(name, fake)
	Transform[fake or name] = function(self, ...)
		return self.transform[name](self.transform, ...)
	end
end

generate2('apply')
generate2('clone')
generate2('getMatrix')
generate2('setMatrix')
generate2('transformPoint')
generate2('translate')
generate2('shear', 'skew')
generate2('rotate')
generate2('scale')
generate2('reset')
generate2('isAffine2DTransform')
generate2('inverseTransformPoint')
generate2('inverse')

function Transform:borrow(obj)
	self.x, self.y = obj.x or self.x, obj.y or self.y
	self.rotation = obj.rotation or self.rotation
	self.scale_x, self.scale_y = obj.scale_x or self.scale_x, obj.scale_y or self.scale_y
	self.skew_x, self.skew_y = obj.skew_x or self.skew_x, obj.skew_y or self.skew_y
	self.origin_x, self.origin_y = obj.origin_x or self.origin_x, obj.origin_y or self.origin_y
end

return Transform
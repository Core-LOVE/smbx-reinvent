local Pool = Class('Pool')

local tablesort = table.sort
local tableremove = table.remove
local tableinsert = table.insert

function Pool:initialize(sort)
	self._sort = sort
end

function Pool:add(obj)
	tableinsert(self, obj)
	self:sort()
end

function Pool:sort(f)
	local sort_f = f or self._sort

	if sort_f then return tablesort(self, sort_f) end
end

function Pool:find()

end

function Pool:remove(obj)
	for k,v in ipairs(self) do
		if v == obj then
			return tableremove(self, k)
		end
	end

	self:sort()
end

return Pool
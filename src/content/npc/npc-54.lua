local npc, super = NPC.create(ID, {

})

function npc:initializeData(data)
	data.timer = 0
end

function npc:animation()
	local custom = super.animation(self)

	if custom then return end

    if self.speedY == 0 or self.collidesSlope then
    	self.frameTimer = 0
    	self.frame = 0
    else
    	self.frameTimer = self.frameTimer + 1

    	if self.frameTimer >= 3 then
    		self.frame = self.frame + 1

    		if self.frame >= 2 then
    			self.frame = 0
    			self.frameTimer = 0
    		end
    	end
    end 
end

function npc:behave()
    local data = self.data

    if self.speedY == 0 or self.collidesSlope then
    	self.speedX = 0
    	data.timer = data.timer + 1

    	if data.timer == 30 then
    		data.timer = 0
    		self.y = self.y - 1
    		self.speedY = -6
    		self.speedX = 1.4 * self.direction
    	end
    end
end

return npc
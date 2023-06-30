local Walker = Class('Walker', NPC)

function walker:onUpdate()
    if self.forcedState ~= 0 or self.projectile or self.grabbingPlayer ~= nil then
        return
    end

    self.speedX = 1.2 * self.direction
end

return Walker
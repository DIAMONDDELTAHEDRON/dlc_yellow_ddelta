local AxisTurret, super = Class(LightBullet)

function AxisTurret:init(x, y, rot, dir, speed)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/axis/turret")

    self.rotation = math.rad(rot or 0)
    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir or 0
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed or 0

    self.destroy_on_hit = false
    self.sprite:setAnimation({"battle/bullets/axis/turret", 1/12, true})
    self:setScale(1, 1)
end

function AxisTurret:update()

    super.update(self)
end

return AxisTurret
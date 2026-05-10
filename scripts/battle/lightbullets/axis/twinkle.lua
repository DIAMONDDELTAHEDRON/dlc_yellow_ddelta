local AxisTwinkle, super = Class(LightBullet)

function AxisTwinkle:init(x, y, dir, speed)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/axis/twinkle")

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed

    self.destroy_on_hit = false
    self.sprite:setAnimation({"battle/bullets/axis/twinkle", 1/12, false})
    self:setScale(1, 1)
    Assets.playSound("axis_twinkle")
end

function AxisTwinkle:update()

    super.update(self)
end

return AxisTwinkle
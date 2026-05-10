local AxisBall, super = Class(LightBullet)

function AxisBall:init(x, y, dir, speed)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/axis/ball")

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed

    self.destroy_on_hit = false
    self.sprite:setAnimation({"battle/bullets/axis/ball", 1/14, true})
    self:setScale(1, 1)
end

function AxisBall:update()

    super.update(self)
end

return AxisBall
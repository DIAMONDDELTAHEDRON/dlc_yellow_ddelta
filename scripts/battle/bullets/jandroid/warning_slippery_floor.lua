local WarningSlipperyFloor, super = Class(Bullet)

function WarningSlipperyFloor:init(x, y)
    super.init(self, x, y, "battle/bullets/jandroid/warning_slippery_floor")
    self:setOriginExact(100, 50)
    self:setScale(1)
    self.sprite:play(1/2)
    self.sprite.alpha = 0
end

function WarningSlipperyFloor:update()
    if self.sprite.alpha < 0.99 then
        self.sprite.alpha = MathUtils.lerp(self.sprite.alpha, 1, 0.1*DTMULT)
    else
        self.sprite.alpha = 1
    end

    super.update(self)
end

return WarningSlipperyFloor
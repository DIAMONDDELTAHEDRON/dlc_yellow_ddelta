local SprayBottleSpray, super = Class(LightBullet)

function SprayBottleSpray:init(x, y)
    super.init(self, x, y, "battle/bullets/jandroid/spray_bottle_spray")
    self:setOriginExact(7, 7)
    self:setScale(1)
    self.sprite:play(1/10)

    self.destroy_on_hit = false

    self.physics.speed = 8

    self.sprite_changed = false
end

function SprayBottleSpray:update()
    self.physics.speed = MathUtils.lerp(self.physics.speed, 0, 0.05*DTMULT)
    if self.physics.speed < 2 and not self.sprite_changed then
        self:setSprite("battle/bullets/jandroid/spray_bottle_spray_disappear")
        self.sprite_changed = true
        self.sprite:play(1/10, false, function() self:remove() end)
        self.sprite:setFrame(1)
    end

    super.update(self)
end

return SprayBottleSpray
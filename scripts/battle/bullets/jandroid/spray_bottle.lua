local SprayBottle, super = Class(Bullet)

function SprayBottle:init(x, y)
    super.init(self, x, y, "battle/bullets/jandroid/spray_bottle")
    self:setOriginExact(32, 20)
    self:setScale(1)
    self.sprite:stop()
    self.sprite.alpha = 0

    self.rad_current = 0
    self.rad_inc = 0.05
    self.move_range = 30
    self.spray_interval = 20
    self.spray_amount = 4

    self.timer = 0
    self.timer2 = 0
    self.timer2_active = false
    self.timer2_target = 15
end

function SprayBottle:update()
    if self.timer >= 2 then
        if self.sprite.alpha < 1 then
            self.sprite.alpha = self.sprite.alpha + 0.2
            self.timer = 0
        else
            self.timer2_active = true
        end
    end

    if self.timer2 >= self.timer2_target then
        self.sprite:setFrame(1)
        self.sprite:play(1/10, false, function() self.sprite:setFrame(1) end)
        for i = 0, (self.spray_amount - 1) do
            local new_spray = self.wave:spawnBullet("jandroid/spray_bottle_spray", self.x - 8, self.y - 9)
            new_spray.layer = new_spray.layer - 0.1
            new_spray.physics.direction = -math.rad(135 + i * (90 / self.spray_amount))
        end
        self.timer2_target = self.spray_interval
        self.timer2 = 0
    end

    if self.rad_current < 360 then
        self.rad_current = self.rad_current + self.rad_inc * DTMULT
    else
        self.rad_current = 0
    end
    self.y = 300 + math.sin(self.rad_current) * self.move_range
    self.x = 400

    self.timer = self.timer + DTMULT
    if self.timer2_active then
        self.timer2 = self.timer2 + DTMULT
    end

    super.update(self)
end

return SprayBottle
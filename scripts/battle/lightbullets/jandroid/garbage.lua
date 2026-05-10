local Garbage, super = Class(LightBullet)

function Garbage:init(x, y)
    super.init(self, x, y, "battle/bullets/jandroid/garbage")
    self:setOriginExact(8, 10)
    self:setScale(0.5)
    self.sprite:stop()
    self.sprite:setFrame(MathUtils.randomInt(1, 4))

    self.destroy_on_hit = false
    self.collider = CircleCollider(self, 7, 8, 7)

    self.physics.gravity = 0.25

    self.bounce_noloop = false
    self.vspeed_max = 4
    self.fade_out = false
end

function Garbage:update()
    if self.physics.speed_y > self.vspeed_max then
        self.physics.speed_y = self.vspeed_max
    end
    local box = Game.battle.arena
    local bbox_bottom = self.y + (6 * 0.5)
    local bbox_left = self.x - (7 * 0.5)
    local bbox_right = self.x + (7 * 0.5)
    if (bbox_bottom + self.physics.speed_y) >= (box.bottom - 3) then
        self.y = box.bottom - 3 - 9 * 0.5 -- sprite_height * 0.5
        self.physics.speed_y = -self.physics.speed_y * 0.7
        if math.abs(self.physics.speed_y) < 0.15 then
            self.physics.speed_y = 0
        end
        if self.bounce_noloop == false then
            self.physics.speed_x = TableUtils.pick({-2, 2})
            self.bounce_noloop = true
        end
    end
    if (bbox_left + self.physics.speed_x) <= (box.left + 3) or (bbox_right + self.physics.speed_x) >= (box.right - 3) then
        self.physics.speed_x = -self.physics.speed_x * 0.8
        if math.abs(self.physics.speed_x) < 0.15 then
            self.physics.speed_x = 0
        end
    end
    if self.fade_out == true then
        if self.sprite.alpha > 0 then
            self.sprite.alpha = self.sprite.alpha - 0.1 * DTMULT
        else
            self:remove()
        end
    end

    super.update(self)
end

return Garbage
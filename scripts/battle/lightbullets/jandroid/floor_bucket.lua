local FloorBucket, super = Class(LightBullet)

function FloorBucket:init(x, y)
    super.init(self, x, y, "battle/bullets/jandroid/floor_bucket")
    self:setOriginExact(12, 9)
    self:setScale(1)

    self.destroy_on_hit = false

    self.slide_speed = 3
    if self.y > Game.battle.arena.top and self.y < Game.battle.arena.bottom then
        if self.x < 320 then
            self.physics.speed_x = self.slide_speed
        else
            self.physics.speed_x = -self.slide_speed
        end
    elseif self.y < 320 then
        self.physics.speed_x = self.slide_speed
    else
        self.physics.speed_x = -self.slide_speed
    end
end

return FloorBucket
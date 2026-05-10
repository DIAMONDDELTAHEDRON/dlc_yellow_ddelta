local AxisBallRed, super = Class(LightBullet)

function AxisBallRed:init(x, y, dir, speed)
    super.init(self, x, y, "battle/bullets/axis/ball_red")

    self.physics.direction = dir
    self.physics.speed = speed

    self.destroy_on_hit = false

    self.bounced = false
end

function AxisBallRed:onShieldCollision()
    if Game.battle.encounter.trash_meter then
        Game.battle.encounter.trash_meter = Utils.clamp(Game.battle.encounter.trash_meter + 10, 0, 100)
    end
    self.physics.direction = math.rad(-90)
    self.bounced = true
end

function AxisBallRed:update()
    if self.y < 200 and self.bounced then
        local axis = Game.battle:getEnemyBattler("axis")
        axis:addChild(Explosion(axis.width/2, axis.height/2))
        axis.hurt_timer = 1
        axis:onHurt()
        Game.battle.encounter.trash_meter = 0
        Game.battle.encounter.battery_meter.hit_count = Game.battle.encounter.battery_meter.hit_count - 1
        self.wave:clear()
        self.wave:remove()
    end

    super.update(self)
end

return AxisBallRed
local TakeAim, super = Class(LightWave)

function TakeAim:init()
    super.init(self)
    self:setArenaPosition(319, 320)
    self:setArenaSize(130, 130)
    self.time = (20 + 30 * 6) / 30

    self.starlo_take_aim_shots_current = 0
    self.starlo_take_aim_shots_max = 6
    self.starlo_take_aim_interval = 30
    self.starlo_take_aim_rope_hit = false

    self.timer = 0
end

function TakeAim:onStart()
    local starlo = Game.battle:getEnemyBattler("starlo")
    if starlo then
        starlo:getSpritePart("head").alpha = 0
        starlo.actor.do_body_stretch = false
        starlo:getSpritePart("body"):setSprite(starlo.actor.path.."/body_shoot")
        starlo:getSpritePart("body"):setOriginExact(54, 214)
        starlo:getSpritePart("body"):play(1/10, false)
    end
end

function TakeAim:onEnd()
    local starlo = Game.battle:getEnemyBattler("starlo")
    if starlo then
        starlo:getSpritePart("head").alpha = 1
        starlo.actor.do_body_stretch = true
        starlo:getSpritePart("body"):setSprite(starlo.actor.path.."/body_ready")
        starlo:getSpritePart("body"):setOriginExact(54, 154)
        starlo:getSpritePart("body"):play(1/10, true)
    end
end

function TakeAim:update()
    local timer_target = self.starlo_take_aim_shots_current == 0 and 20 or self.starlo_take_aim_interval
    if self.timer >= timer_target and self.starlo_take_aim_shots_current < self.starlo_take_aim_shots_max then
        self:spawnBullet("starlo/take_aim_target", Game.battle.soul.x + MathUtils.randomInt(-10, 11), Game.battle.soul.y + MathUtils.randomInt(-10, 11))
        self.starlo_take_aim_shots_current = self.starlo_take_aim_shots_current + 1
        self.timer = 0
    end

    self.timer = self.timer + DTMULT

    super.update(self)
end

return TakeAim
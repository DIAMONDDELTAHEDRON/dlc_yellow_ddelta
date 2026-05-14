local TakeAimOne, super = Class(LightWave)

function TakeAimOne:init()
    super.init(self)
    self:setArenaPosition(319, 320)
    self:setArenaSize(130, 130)
    self.time = 110/30

    self.starlo_take_aim_interval = 20
    self.starlo_take_aim_rope_hit = false

    self.timer = 0
    self.target_spawned = false
end

function TakeAimOne:onStart()
    local starlo = Game.battle:getEnemyBattler("starlo")
    if starlo then
        starlo:getSpritePart("head").alpha = 0
        starlo.actor.do_body_stretch = false
        starlo:getSpritePart("body"):setSprite(starlo.actor.path.."/body_shoot")
        starlo:getSpritePart("body"):setOriginExact(54, 214)
        starlo:getSpritePart("body"):play(1/10, false)
    end
end

function TakeAimOne:onEnd()
    local starlo = Game.battle:getEnemyBattler("starlo")
    if starlo then
        starlo:getSpritePart("head").alpha = 1
        starlo.actor.do_body_stretch = true
        starlo:getSpritePart("body"):setSprite(starlo.actor.path.."/body_ready")
        starlo:getSpritePart("body"):setOriginExact(54, 154)
        starlo:getSpritePart("body"):play(1/10, true)
    end
end

function TakeAimOne:update()
    if self.timer >= self.starlo_take_aim_interval and not self.target_spawned then
        self:spawnBullet("starlo/take_aim_target", Game.battle.soul.x + MathUtils.randomInt(-10, 11), Game.battle.soul.y + MathUtils.randomInt(-10, 11))
        self.target_spawned = true
    end

    self.timer = self.timer + DTMULT

    super.update(self)
end

return TakeAimOne
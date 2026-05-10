local AxisBall, super = Class(LightBullet)

function AxisBall:init(x, y, dir, speed, expl)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/axis/ball")

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed

    self.can_explode = expl or false

    self.destroy_on_hit = false
    self.sprite:setAnimation({"battle/bullets/axis/ball", 1/14, true})
    self:setScale(1, 1)
end

function AxisBall:onShieldCollision()
    if Game.battle.encounter.trash_meter then
        Game.battle.encounter.trash_meter = Utils.clamp(Game.battle.encounter.trash_meter + 10, 0, 100)
    end
    self:remove()
end

function AxisBall:update()
    if self:collidesWith(Game.battle.arena.collider.colliders[1]) then
        if self.physics.direction == -math.pi / 2 then
            Assets.playSound("ball_bounce")
            self.physics.direction = math.pi / 2
        elseif self.physics.direction == -math.pi * 0.25 then
            Assets.playSound("ball_bounce")
            self.physics.direction = math.pi * 0.25
        elseif self.physics.direction == -math.pi * 0.45 then
            Assets.playSound("ball_bounce")
            self.physics.direction = math.pi * 0.25
        elseif self.physics.direction == -math.pi * 0.75 then
            Assets.playSound("ball_bounce")
            self.physics.direction = math.pi * 0.75
        elseif self.physics.direction == math.pi then
            Assets.playSound("ball_bounce")
            self.physics.direction = -math.pi
        end
    end

    if self:collidesWith(Game.battle.arena.collider.colliders[2]) then
        if self.physics.direction == math.pi * 0.25 then
            Assets.playSound("ball_bounce")
            self.physics.direction = math.pi * 0.75
        elseif self.physics.direction == -math.pi * 0.25 then
            Assets.playSound("ball_bounce")
            self.physics.direction = -math.pi * 0.75
        elseif self.physics.direction == -math.pi * 0.05 then
            Assets.playSound("ball_bounce")
            self.physics.direction = -math.pi * 0.75
        elseif self.physics.direction == 0 then
            Assets.playSound("ball_bounce")
            self.physics.direction = math.pi
        end
    end

    if self:collidesWith(Game.battle.arena.collider.colliders[3]) then
        if self.can_explode then
            Assets.playSound("ceroba_boom")
            self.wave:spawnBulletTo(Game.battle.arena.mask, "axis/arenaflash", 0, 0)
            self:remove()
        else
            if self.physics.direction == math.pi / 2 then
                Assets.playSound("ball_bounce")
                self.physics.direction = -math.pi / 2
            elseif self.physics.direction == math.pi * 0.75 then
                Assets.playSound("ball_bounce")
                self.physics.direction = -math.pi * 0.75
            elseif self.physics.direction == math.pi * 0.25 then
                Assets.playSound("ball_bounce")
                self.physics.direction = -math.pi * 0.25
            end
        end
    end

    if self:collidesWith(Game.battle.arena.collider.colliders[4]) then
        if self.physics.direction == math.pi * 0.75 then
            Assets.playSound("ball_bounce")
            self.physics.direction = math.pi * 0.25
        elseif self.physics.direction == -math.pi * 0.75 then
            Assets.playSound("ball_bounce")
            self.physics.direction = -math.pi * 0.25
        elseif self.physics.direction == math.pi then
            Assets.playSound("ball_bounce")
            self.physics.direction = 0
        end
    end

    super.update(self)
end

return AxisBall
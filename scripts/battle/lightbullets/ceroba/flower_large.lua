local CerobaFlowerLarge, super = Class(LightBullet)

function CerobaFlowerLarge:init(x, y, dir, speed, grav, explodes, circle)
    super.init(self, x, y, "battle/bullets/ceroba/flower_large")

    self.physics.direction = dir or math.rad(0)
    self.physics.speed = speed or 0
    self.physics.gravity = grav or 0
    self.can_explode = explodes or false
    self.circle = circle or false
    self.immune = true

    self.remove_offscreen = false
    self.destroy_on_hit = false
    self.sprite:setAnimation({"battle/bullets/ceroba/flower_large", 1/6, true})
    self:setScale(1, 1)
end

function CerobaFlowerLarge:shootFlowers(silent)
    if not silent then
        Assets.playSound("ceroba_bullet_shot")
    end
    self.wave:spawnBullet("ceroba/flower", self.x, self.y, math.rad(315), 6) -- right up
    self.wave:spawnBullet("ceroba/flower", self.x, self.y, math.rad(0), 6) -- right
    self.wave:spawnBullet("ceroba/flower", self.x, self.y, math.rad(45), 6) -- right down
    self.wave:spawnBullet("ceroba/flower", self.x, self.y, math.rad(135), 6) -- left down
    self.wave:spawnBullet("ceroba/flower", self.x, self.y, math.rad(180), 6) -- left
    self.wave:spawnBullet("ceroba/flower", self.x, self.y, math.rad(225), 6) -- left up
end

function CerobaFlowerLarge:shootFlowersMore(silent)
    if not silent then
        Assets.playSound("ceroba_bullet_shot")
    end
    self.wave:spawnBullet("ceroba/flower", self.x, self.y, math.rad(0), 6)
    self.wave:spawnBullet("ceroba/flower", self.x, self.y, math.rad(30), 6)
    self.wave:spawnBullet("ceroba/flower", self.x, self.y, math.rad(60), 6)
    self.wave:spawnBullet("ceroba/flower", self.x, self.y, math.rad(90), 6)
    self.wave:spawnBullet("ceroba/flower", self.x, self.y, math.rad(120), 6)
    self.wave:spawnBullet("ceroba/flower", self.x, self.y, math.rad(150), 6)
    self.wave:spawnBullet("ceroba/flower", self.x, self.y, math.rad(180), 6)
    self.wave:spawnBullet("ceroba/flower", self.x, self.y, math.rad(210), 6)
    self.wave:spawnBullet("ceroba/flower", self.x, self.y, math.rad(240), 6)
    self.wave:spawnBullet("ceroba/flower", self.x, self.y, math.rad(270), 6)
    self.wave:spawnBullet("ceroba/flower", self.x, self.y, math.rad(300), 6)
    self.wave:spawnBullet("ceroba/flower", self.x, self.y, math.rad(330), 6)
end

function CerobaFlowerLarge:explodeFlower(BorO)
    self.wave:spawnBullet("ceroba/explosion", self.x, self.y)
    Game.battle.camera:shake(4, 2, 0.5)
    if self.circle then
        self.wave:spawnBullet("ceroba/ring_"..self.circle, self.x, self.y)
    elseif BorO then
        self.wave:spawnBullet("ceroba/ring_"..BorO, self.x, self.y)
    end
    self:remove()
end

function CerobaFlowerLarge:update()
    Game.battle.timer:after(1, function() self.immune = false end)
    if self:collidesWith(Game.battle.arena.collider.colliders[3]) then
        if self.can_explode and not self.immune then
            self:explodeFlower()
        end
    end

    super.update(self)
end

return CerobaFlowerLarge
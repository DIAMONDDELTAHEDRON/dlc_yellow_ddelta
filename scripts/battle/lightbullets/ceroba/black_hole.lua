local CerobaBlackHole, super = Class(LightBullet)

function CerobaBlackHole:init(x, y)
    super.init(self, x, y, "battle/bullets/ceroba/black_hole")

    self.collider = CircleCollider(self, 18, 22, 10)
    self.destroy_on_hit = false
    self.sprite:setAnimation({"battle/bullets/ceroba/black_hole", 1/10, true})
    self:setScale(1, 1)
end

function CerobaBlackHole:update()
    if Game.battle.soul.x > self.x then
        Game.battle.soul.x = Game.battle.soul.x - (2 * DTMULT)
    else
        Game.battle.soul.x = Game.battle.soul.x + (2 * DTMULT)
    end
    if Game.battle.soul.y > self.y then
        Game.battle.soul.y = Game.battle.soul.y - (2 * DTMULT)
    else
        Game.battle.soul.y = Game.battle.soul.y + (2 * DTMULT)
    end

    super.update(self)
end

return CerobaBlackHole
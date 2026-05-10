local CerobaExplosion, super = Class(LightBullet)

function CerobaExplosion:init(x, y)
    super.init(self, x, y, "battle/bullets/ceroba/explosion")

    self.collider = nil
    self.destroy_on_hit = false
    self.sprite:setAnimation({"battle/bullets/ceroba/explosion", 1/15, false})
    self:setScale(1, 1)
    Assets.playSound("ceroba_boom")
end

function CerobaExplosion:onCollide(soul) end

function CerobaExplosion:update()

    super.update(self)
end

return CerobaExplosion
local CerobaExplosion, super = Class(LightBullet)

function CerobaExplosion:init(x, y, isleft)
    if isleft then
        super.init(self, x, y, "battle/bullets/ceroba/pillar_left")
    else
        super.init(self, x, y, "battle/bullets/ceroba/pillar_right")
    end
    self.color = {128/255, 128/255, 128/255}
    self.collider = nil
    self.destroy_on_hit = false
    self:setScale(1, 1)
end

function CerobaExplosion:onCollide(soul) end

function CerobaExplosion:update()

    super.update(self)
end

return CerobaExplosion
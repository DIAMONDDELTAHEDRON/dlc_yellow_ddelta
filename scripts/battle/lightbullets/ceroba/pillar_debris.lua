local CerobaExplosion, super = Class(LightBullet)

function CerobaExplosion:init(x, y, type)
    if not type then
        type = 1
    end
    super.init(self, x, y, "battle/bullets/ceroba/pillar_debris_"..type)
    self.physics.direction = dir
    self.physics.speed = speed
    self.destroy_on_hit = false
    self:setScale(1, 1)
end

function CerobaExplosion:update()

    super.update(self)
end

return CerobaExplosion
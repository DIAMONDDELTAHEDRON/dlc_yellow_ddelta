local CerobaDiamond, super = Class(LightBullet)

function CerobaDiamond:init(x, y)
    super.init(self, x, y, "battle/bullets/ceroba/diamond")

    self.collider = nil
    self.can_graze = false
    self.destroy_on_hit = false
    self.sprite:play(1/15, false, function() self:fadeOutAndRemove(0.25) end)
    Assets.playSound("ceroba_trap")
end

function CerobaDiamond:onCollide(soul)
    if soul.stunned ~= true then
        soul.stunned = true
        local color = soul.color
        soul:setColor(1, 1, 1)
        Game.battle.soul.can_move = false
        soul.graphics.shake_x = 1
        soul.graphics.shake_y = 1
        Game.battle.timer:after(1, function()
            soul.stunned = false
            Game.battle.soul.can_move = true
            soul:setColor(color)
            soul.graphics.shake_x = 0
            soul.graphics.shake_y = 0
        end)
    end
end

function CerobaDiamond:update()
    if self.sprite.frame >= 8 and self.collider == nil then
        self.collider = PolygonCollider(self, {{24,4},{41,21},{24,38},{23,38},{6,21},{23,4}})
    end
    if self.alpha < 1 and self.collider ~= nil then
        self.collider = nil
    end

    super.update(self)
end

return CerobaDiamond
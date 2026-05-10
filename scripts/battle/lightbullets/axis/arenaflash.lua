local ArenaFlash, super = Class(LightBullet)

function ArenaFlash:init(x, y)
    super.init(self, x, y)

    self.destroy_on_hit = false
	self.collider = Hitbox(self, 0, 0, Game.battle.arena.width, Game.battle.arena.height)
    self.shield_immune = true
end

function ArenaFlash:update()
    super.update(self)
	Game.battle.timer:after(0.1, function() self:remove() end)
end

function ArenaFlash:draw()
    Draw.setColor({1, 1, 1})
	love.graphics.rectangle("fill", 0, 0, Game.battle.arena.width, Game.battle.arena.height)
    super.draw(self)
end

return ArenaFlash
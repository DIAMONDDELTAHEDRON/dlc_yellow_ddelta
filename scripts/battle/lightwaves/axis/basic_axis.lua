local Basic, super = Class(LightWave)

function Basic:init()
    super.init(self)
    self.time = 10
    self.soul_start_x = Game.battle.arena.x
    self.soul_start_y = Game.battle.arena.bottom - 4
end

function Basic:onStart()
    Game.battle:swapSoul(ShieldSoul())
    self.timer:every(1/2, function()

        local bullet = self:spawnBullet("axis/ball_bouncy", Utils.random(Game.battle.arena.left, Game.battle.arena.right), 0, math.rad(90), 6, true)

        bullet.remove_offscreen = false
    end)
end

function Basic:onEnd()
    Game.battle:swapSoul(LightSoul())
    super.onEnd(self)
end

function Basic:update()

    super.update(self)
end

return Basic
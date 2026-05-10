local Basic, super = Class(LightWave)

function Basic:init()
    super.init(self)
    self.time = -1
    self.soul_start_x = Game.battle.arena.x
    self.soul_start_y = Game.battle.arena.bottom - 4
    self.axis = Game.battle:getEnemyBattler("axis")
end

function Basic:onStart()
    Game.battle:swapSoul(ShieldSoul())
    self.timer:after(1, function()

        local bullet = self:spawnBullet("axis/ball_red", 318, 42, math.rad(90), 6)

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
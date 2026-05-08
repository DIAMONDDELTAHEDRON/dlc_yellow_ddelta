local GarbageCans, super = Class(LightWave)

function GarbageCans:init()
    super.init(self)
    self:setArenaPosition(319, 310)
    self:setArenaSize(80, 118)
    self.time = 7 -- room_speed * 7
    self.darken = true
end

function GarbageCans:onStart()
    self.timer:every(1/3, function()
        self:spawnBullet("jandroid/garbage", Game.battle.soul.x, Game.battle.arena.top - 80, math.rad(90), 4)
    end)
    self.timer:after(1.5, function()
        self:spawnBullet("jandroid/soap", Game.battle.soul.x, Game.battle.arena.top - 80, math.rad(90), 4)
    end)
end

function GarbageCans:update()

    super.update(self)
end

return GarbageCans
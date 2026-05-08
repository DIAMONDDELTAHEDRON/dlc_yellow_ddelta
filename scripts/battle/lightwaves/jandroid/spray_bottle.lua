local SprayBottle, super = Class(LightWave)

function SprayBottle:init()
    super.init(self)
    self:setArenaPosition(319, 310)
    self:setArenaSize(100, 118)
    self.time = 7 -- room_speed * 7
    self.darken = true
end

function SprayBottle:onStart()
    self:spawnBullet("jandroid/spray_bottle", 440, 300)
    self:spawnBullet("jandroid/warning_slippery_floor", (Game.battle.arena.left - 5) - 25, (Game.battle.arena.y + 10))
end

return SprayBottle
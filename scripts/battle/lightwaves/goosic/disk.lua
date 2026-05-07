local Aiming, super = Class(LightWave)

function Aiming:init()
    super.init(self)

    self.time = 300 / 30
end

function Aiming:onStart()
    self:spawnBullet("goosic/disk", 320, Game.battle.arena.top - 35)
end

return Aiming
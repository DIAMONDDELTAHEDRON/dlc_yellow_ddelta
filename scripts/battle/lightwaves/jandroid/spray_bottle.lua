local SprayBottle, super = Class(LightWave)

function SprayBottle:init()
    super.init(self)
    self:setArenaSize(100, 118)
    self:setArenaPosition(319, 310)
    self.time = 7 -- room_speed * 7
end

function SprayBottle:onStart()
    self:spawnBullet("jandroid/spray_bottle", 440, 300)
end

return SprayBottle
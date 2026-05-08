local SlipperyFloor, super = Class(LightWave)

function SlipperyFloor:init()
    super.init(self)
    self:setArenaPosition(319, 310)
    self:setArenaSize(150, 90)
    self.time = 7 -- room_speed * 7
    self.darken = true

    self.attack_interval = 40

    self.timer = 0
    self.timer_target = 15
    self.timer_times_looped = 0
end

function SlipperyFloor:onStart()
    if Game.battle:getEnemyBattler("goosic") then
        self:spawnBullet("jandroid/warning_slippery_floor", (Game.battle.arena.left - 5) - 90, (Game.battle.arena.y + 10))
    else
        self:spawnBullet("jandroid/warning_slippery_floor", (Game.battle.arena.left - 5) - 25, (Game.battle.arena.y + 10))
    end
end

function SlipperyFloor:spawnBullets(first)
    if first then
        self:spawnBullet("warning_exclamation_mark", (Game.battle.arena.left - 5) + 10, (Game.battle.arena.top + 5) + 24)
        self:spawnBullet("warning_exclamation_mark", (Game.battle.arena.right + 5) - 10, Game.battle.arena.y)
        self:spawnBullet("warning_exclamation_mark", (Game.battle.arena.left - 5) + 10, (Game.battle.arena.bottom + 6) - 24)
    else
        self:spawnBulletTo(Game.battle.mask, "jandroid/floor_bucket", (Game.battle.arena.left - 5) - 20, (Game.battle.arena.top - 5) + 20)
        self:spawnBulletTo(Game.battle.mask, "jandroid/floor_bucket", (Game.battle.arena.right + 5) + 20, Game.battle.arena.y)
        self:spawnBulletTo(Game.battle.mask, "jandroid/floor_bucket", (Game.battle.arena.left - 5) - 20, (Game.battle.arena.bottom + 5) - 20)
    end
end

function SlipperyFloor:update()
    if self.timer >= self.timer_target then
        if self.timer_times_looped == 0 then
            self:spawnBullets(true)
        else
            self:spawnBullets(false)
        end
        self.timer = 0
        if self.timer_times_looped < 1 then
            self.timer_target = 15
        else
            self.timer_target = self.attack_interval
        end
        self.timer_times_looped = self.timer_times_looped + 1
    end

    self.timer = self.timer + DTMULT

    super.update(self)
end

return SlipperyFloor
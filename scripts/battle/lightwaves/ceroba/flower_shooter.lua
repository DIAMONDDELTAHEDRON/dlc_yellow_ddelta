local Basic, super = Class(LightWave)

function Basic:init()
    super.init(self)
    self:setArenaSize(160, 160)
    self:setArenaPosition(319, 305) -- orig 320, 385
    self.type = Game.battle:getEnemyBattler("ceroba_geno").phase
    self.time = 10
    self.nextringcolor = 1
end

function Basic:onStart()
    self.elapsed_time = 0 --initialize the time this wave has existed
    local arena = Game.battle.arena
    self.timer:after(1/2, function()
        Assets.playSound("ceroba_bullet_rise", 1.5)
        self.bigflower_one = self:spawnBullet("ceroba/flower_large",
        math.sin((2 * math.pi)) * arena.width + arena.x,
        math.cos((2 * math.pi)) * arena.height + arena.y)

        self.timer:after(1/2, function()
            Assets.playSound("ceroba_bullet_rise", 1.5)
            self.bigflower_two = self:spawnBullet("ceroba/flower_large",
            math.sin((math.pi)) * arena.width + arena.x,
            math.cos((math.pi)) * arena.height + arena.y)
        end)
    end)
    self.timer:after(1.5, function()
        if self.type == 2 then
            self.timer:every(1/4, function()
                Assets.playSound("ceroba_bullet_shot")
                local angle1 = Utils.angle(self.bigflower_one.x, self.bigflower_one.y, Game.battle.soul.x, Game.battle.soul.y)
                local angle2 = Utils.angle(self.bigflower_two.x, self.bigflower_two.y, Game.battle.soul.x, Game.battle.soul.y)
                self:spawnBullet("ceroba/flower", self.bigflower_one.x, self.bigflower_one.y, angle1, 6)
                self:spawnBullet("ceroba/flower", self.bigflower_two.x, self.bigflower_two.y, angle2, 6)
            end)
        else
            self.timer:every(1/2, function()
                Assets.playSound("ceroba_bullet_shot")
                local angle1 = Utils.angle(self.bigflower_one.x, self.bigflower_one.y, Game.battle.soul.x, Game.battle.soul.y)
                local angle2 = Utils.angle(self.bigflower_two.x, self.bigflower_two.y, Game.battle.soul.x, Game.battle.soul.y)
                self:spawnBullet("ceroba/flower", self.bigflower_one.x, self.bigflower_one.y, angle1, 4)
                self:spawnBullet("ceroba/flower", self.bigflower_two.x, self.bigflower_two.y, angle2, 4)
            end)
        end
        if self.type == 2 then
            self.timer:every(2, function()
                if self.nextringcolor == 1 then
                    self.nextringcolor = 2
                    -- blue ring
                    self:spawnBullet("ceroba/ring_b", self.bigflower_two.x, self.bigflower_two.y)
                else
                    self.nextringcolor = 1
                    -- orange ring
                    self:spawnBullet("ceroba/ring_o", self.bigflower_one.x, self.bigflower_one.y)
                end
            end)
        end
    end)
end

function Basic:update()
    local arena = Game.battle.arena
    local w = 1 --angular speed. higher numbers spinny faster
    self.elapsed_time = self.elapsed_time + DT
    self.timer:after(1.5, function()
        if self.type == 1 then
            self.bigflower_one:setPosition(
                math.sin((2 * math.pi) + w*self.elapsed_time) * arena.width + arena.x,
                math.cos((2 * math.pi) + w*self.elapsed_time) * arena.height + arena.y
            )
            self.bigflower_two:setPosition(
                math.sin((1 * math.pi) + w*self.elapsed_time) * arena.width + arena.x,
                math.cos((1 * math.pi) + w*self.elapsed_time) * arena.height + arena.y
            )
        else
            self.bigflower_one:setPosition(
                math.sin((2 * math.pi) + w*-self.elapsed_time) * arena.width + arena.x,
                math.cos((2 * math.pi) + w*-self.elapsed_time) * arena.height + arena.y
            )
            self.bigflower_two:setPosition(
                math.sin((1 * math.pi) + w*-self.elapsed_time) * arena.width + arena.x,
                math.cos((1 * math.pi) + w*-self.elapsed_time) * arena.height + arena.y
            )
        end
    end)
    self.elapsed_time = self.elapsed_time + DT

    super.update(self)
end

return Basic
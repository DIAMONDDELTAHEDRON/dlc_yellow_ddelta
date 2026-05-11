local Basic, super = Class(LightWave)

function Basic:init()
    super.init(self)
    self:setArenaSize(200, 200)
    self:setArenaPosition(319, 285) -- orig 320, 385
    self.type = Game.battle:getEnemyBattler("ceroba_geno").phase
    self.time = 10
    self.nextbulletdir = 1
    self.bulletangle_one = 0
    self.bulletangle_two = 90
    self.bulletangle_three = 180
    self.bulletangle_four = 270
end

function Basic:onStart()
    self:spawnBullet("warning_exclamation_mark", Game.battle.arena.x, Game.battle.arena.y)
    self.timer:after(1, function()
        Assets.playSound("ceroba_bullet_rise", 1.5)
        self.bigflower = self:spawnBullet("ceroba/flower_large", Game.battle.arena.x, Game.battle.arena.y)
    end)
    self.timer:after(1.5, function()
        if self.type == 2 then
            self.timer:every(2, function()
                self:spawnBullet("ceroba/diamond", Game.battle.soul.x, Game.battle.soul.y)
            end)
            self.timer:every(1/10, function()
                Assets.playSound("ceroba_bullet_shot")
                self:spawnBullet("ceroba/flower", self.bigflower.x, self.bigflower.y, math.rad(self.bulletangle_one), 5)
                self:spawnBullet("ceroba/flower", self.bigflower.x, self.bigflower.y, math.rad(self.bulletangle_three), 5)
                if self.nextbulletdir == 12 then
                    self.nextbulletdir = 1
                    self.bulletangle_one = 0
                    self.bulletangle_two = 90
                    self.bulletangle_three = 180
                    self.bulletangle_four = 270
                else
                    self.nextbulletdir = self.nextbulletdir+1
                    self.bulletangle_one = self.bulletangle_one+15
                    self.bulletangle_three = self.bulletangle_three+15
                end
            end)
        else
            self.timer:every(1/6, function()
                Assets.playSound("ceroba_bullet_shot")
                self:spawnBullet("ceroba/flower", self.bigflower.x, self.bigflower.y, math.rad(self.bulletangle_one), 3)
                self:spawnBullet("ceroba/flower", self.bigflower.x, self.bigflower.y, math.rad(self.bulletangle_two), 3)
                self:spawnBullet("ceroba/flower", self.bigflower.x, self.bigflower.y, math.rad(self.bulletangle_three), 3)
                self:spawnBullet("ceroba/flower", self.bigflower.x, self.bigflower.y, math.rad(self.bulletangle_four), 3)
                if self.nextbulletdir == 6 then
                    self.nextbulletdir = 1
                    self.bulletangle_one = 0
                    self.bulletangle_two = 90
                    self.bulletangle_three = 180
                    self.bulletangle_four = 270
                else
                    self.nextbulletdir = self.nextbulletdir+1
                    self.bulletangle_one = self.bulletangle_one-15
                    self.bulletangle_two = self.bulletangle_two-15
                    self.bulletangle_three = self.bulletangle_three-15
                    self.bulletangle_four = self.bulletangle_four-15
                end
            end)
        end
    end)
end

function Basic:update()

    super.update(self)
end

return Basic
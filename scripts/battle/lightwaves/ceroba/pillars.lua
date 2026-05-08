local Basic, super = Class(LightWave)

function Basic:init()
    super.init(self)
    self:setArenaSize(350, 70)
    --self:setArenaPosition(319, 320) -- orig 320, 385
    self.type = Game.battle:getEnemyBattler("ceroba_geno").phase
    self.time = 6
    --[[local pillars = {1, 2, 3, 4} -- initial idea, full random
    local a = Utils.pick(pillars)    -- scrapped, too unpredictable
    Utils.removeFromTable(pillars, a)
    local b = Utils.pick(pillars)
    Utils.removeFromTable(pillars, b)
    local c = Utils.pick(pillars)
    Utils.removeFromTable(pillars, c)
    local d = Utils.pick(pillars)
    self.flash_order = {a, b, c, d}]]
    self.flash_order = {1, 4, 2, 3}
    if self.type == 2 then
        self.flash_order = {4, 1, 3, 2}
    end
    --[[local e = Utils.pick({"b", "o"})
    local f = Utils.pick({"b", "o"})
    local g = Utils.pick({"b", "o"})
    local h = Utils.pick({"b", "o"})
    self.flash_order_color = {e, f, g, h}]]
    self.flash_order_color = {"b", "b", "b", "b"}
end

function Basic:onStart()
    local pillars = {}
    local pillar1 = self:spawnBullet("ceroba/pillar", Game.battle.arena.x - 50, Game.battle.arena.y, true)
    local pillar2 = self:spawnBullet("ceroba/pillar", Game.battle.arena.x - 120, Game.battle.arena.y, true)
    local pillar3 = self:spawnBullet("ceroba/pillar", Game.battle.arena.x + 50, Game.battle.arena.y)
    local pillar4 = self:spawnBullet("ceroba/pillar", Game.battle.arena.x + 120, Game.battle.arena.y)
    table.insert(pillars, pillar1)
    table.insert(pillars, pillar2)
    table.insert(pillars, pillar3)
    table.insert(pillars, pillar4)
    local function pillarScript(num)
        Assets.playSound("bombfall")
        if self.type == 2 then
            if self.flash_order_color[num] == "b" then
                pillars[num]:setColor(0, 162/255, 232/255)
            elseif self.flash_order_color[num] == "o" then
                pillars[num]:setColor(254/255, 159/255, 64/255)
            end
        else
            pillars[num]:setColor(1, 0, 0)
        end
        self.timer:after(0.2, function()
            pillars[num]:setColor(128/255, 128/255, 128/255)
        end)
        self.timer:after(1, function()
            local bigflower = self:spawnBullet("ceroba/flower_large", pillars[num].x, -40)
            bigflower:slideTo(bigflower.x, Game.battle.arena.bottom, 1)
            self.timer:after(1, function()
                Assets.playSound("rock_break")
                local debris = self:spawnBullet("ceroba/pillar_debris", pillars[num].x, pillars[num].y - 20, 1)
                debris.physics.direction = math.rad(math.random(250, 290))
                debris.physics.speed = 6
                debris.physics.gravity = 0.5
                local debris2 = self:spawnBullet("ceroba/pillar_debris", pillars[num].x, pillars[num].y - 10, 2)
                debris2.physics.direction = math.rad(math.random(250, 290))
                debris2.physics.speed = 6
                debris2.physics.gravity = 0.5
                local debris3 = self:spawnBullet("ceroba/pillar_debris", pillars[num].x, pillars[num].y, 3)
                debris3.physics.direction = math.rad(math.random(250, 290))
                debris3.physics.speed = 6
                debris3.physics.gravity = 0.3
                pillars[num]:remove()
                self:spawnBullet("ceroba/explosion", bigflower.x, bigflower.y)
                Game.battle.camera:shake(4, 2, 0.5)
                if self.type == 2 then
                    self.timer:after(0.5, function()
                        self:spawnBullet("ceroba/ring_"..self.flash_order_color[num], bigflower.x, bigflower.y)
                    end)
                end
                bigflower:remove()
            end)
        end)
    end
    self.timer:after(0.5, function()
        pillarScript(self.flash_order[1])
    end)
    self.timer:after(1, function()
        pillarScript(self.flash_order[2])
    end)
    self.timer:after(1.5, function()
        pillarScript(self.flash_order[3])
    end)
    self.timer:after(2, function()
        pillarScript(self.flash_order[4])
    end)
    if self.type == 2 then
        self.timer:after(1, function()
            self:spawnBullet("warning_exclamation_mark", Game.battle.arena.x - 80, Game.battle.arena.y)
            self.timer:after(0.5, function()
                self:spawnBullet("warning_exclamation_mark", Game.battle.arena.x + 80, Game.battle.arena.y)
            end)
        end)
        self.timer:after(2, function()
            self:spawnBullet("ceroba/beam", Game.battle.arena.x - 80, Game.battle.arena.y, 90, 1)
            self.timer:after(0.5, function()
                self:spawnBullet("ceroba/beam", Game.battle.arena.x + 80, Game.battle.arena.y, 90, 1)
            end)
        end)
    else
        self.timer:after(1, function()
            self:spawnBullet("warning_exclamation_mark", Game.battle.arena.x, Game.battle.arena.y)
        end)
        self.timer:after(2, function()
            self:spawnBullet("ceroba/beam", Game.battle.arena.x, Game.battle.arena.y, 90, 1)
        end)
    end
end

function Basic:update()

    super.update(self)
end

return Basic
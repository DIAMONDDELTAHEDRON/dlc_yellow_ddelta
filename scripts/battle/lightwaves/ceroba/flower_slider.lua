local Basic, super = Class(LightWave)

function Basic:init()
    super.init(self)
    self:setArenaSize(260, 160)
    self:setArenaPosition(319, 305) -- orig 320, 385
    self.type = Game.battle:getEnemyBattler("ceroba_geno").phase
    self.time = 12
    self.isvertical = false
end

function Basic:onStart()
    local function warning(x, y, isvertical)
        Assets.playSound("bombfall")
        local rect
        if isvertical then
            rect = Rectangle(x-20, 0, 40, SCREEN_HEIGHT)
        else
            rect = Rectangle(0, y-20, SCREEN_WIDTH, 40)
        end
        rect.color = {1, 0, 0}
        rect.alpha = 0.2
        rect.layer = LIGHT_BATTLE_LAYERS["above_arena_border"]
        Game.battle:addChild(rect)
        Game.battle.timer:after(0.5, function() rect:remove() end)
    end
    local arena = Game.battle.arena
    self.timer:every(1.2, function()
        local x = arena.x + love.math.random(-120, 120)
        local y = arena.y + love.math.random(-60, 60)
        if self.type == 2 and self.isvertical then
            warning(x, 0, true)
        else
            warning(0, y)
        end
        self.timer:after(0.5, function()
            local bigflower_one
            local bigflower_two
            if self.type == 2 and self.isvertical then
                bigflower_one = self:spawnBullet("ceroba/flower_large", x, y-500)
                bigflower_two = self:spawnBullet("ceroba/flower_large", x, y+500)
                bigflower_one:slideTo(bigflower_one.x, y, 1)
                bigflower_two:slideTo(bigflower_two.x, y, 1)
                self.isvertical = false
            else
                bigflower_one = self:spawnBullet("ceroba/flower_large", x - 500, y)
                bigflower_two = self:spawnBullet("ceroba/flower_large", x + 500, y)
                bigflower_one:slideTo(x, bigflower_one.y, 1)
                bigflower_two:slideTo(x, bigflower_two.y, 1)
                if self.type == 2 then self.isvertical = true end
            end
            self.timer:after(1, function()
                bigflower_one:remove()
                if self.type == 2 then
                    bigflower_two:shootFlowersMore(true)
                else
                    bigflower_two:shootFlowers(true)
                end
                bigflower_two:explodeFlower()
            end)
        end)
    end)
end

function Basic:update()

    super.update(self)
end

return Basic
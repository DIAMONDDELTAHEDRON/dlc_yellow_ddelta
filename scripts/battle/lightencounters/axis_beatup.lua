local Axis, super = Class(LightEncounter)

function Axis:init()
    super.init(self)

    self.text = ""

    self.music = nil

    self:addEnemy("axis")

    self.background = false

    self.fast_transition = true

    self.can_flee = false

end

function Axis:onBattleStart()
    Game.battle:setState("ENEMYDIALOGUE")
    Game.battle:startCutscene(function(cutscene)
        local axis = Game.battle:getEnemyBattler("axis")
        local function makeSlash(rotation)
            local slash = Sprite("effects/lightattack/strike")
            local relative_pos_x, relative_pos_y = axis:getRelativePos(axis.width / 2, axis.height / 2)
            slash:setPosition(relative_pos_x, relative_pos_y)
            slash.layer = LIGHT_BATTLE_LAYERS["above_battlers"]
            slash.rotation = math.rad(rotation or 0)
            slash.color = {1, 105/255, 105/255}
            slash:setOrigin(0.5, 0.5)
            axis.parent:addChild(slash)
            Assets.playSound("laz_c")
            slash:play(1/12, false, function(this)
                this:remove()
            end)
        end
        cutscene:wait(0.2)
        makeSlash()
        cutscene:wait(0.2)
        makeSlash(90)
        cutscene:wait(0.2)
        makeSlash(270)
        cutscene:wait(0.5)
        Assets.playSound("damage")
        Assets.playSound("ut_explosion")
        axis:shake()
        axis:setSprite("axis_body_geno_hit_1")
        cutscene:wait(0.2)
        axis:setSprite("axis_body_geno_hit_2")
        cutscene:after(function()
            Game.battle:setState("TRANSITIONOUT")
        end, true)
    end)
end

return Axis
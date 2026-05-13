local Starlo, super = Class(LightEncounter)

function Starlo:init()
    super.init(self)

    self.text = "* Showdown."

    self.music = "GHOST_TOWN"

    self:addEnemy("starlo")

    self.background = false

    self.offset = 0

    self.can_flee = false

    self.intro_finished = false
	self.bg_state = 0
end

function Starlo:createBackground()
    local background = StarloBattleBackground()
    return Game.battle:addChild(background)
end

function Starlo:onBattleStart()
    Game.battle.music:stop()
    Game.battle:setState("ENEMYDIALOGUE")
    Game.battle.soul.can_move = false
    --self:onBattleStart()
    Game.battle:startCutscene("starlo", "intro")
end

function Starlo:update()
	super.update(self)
end

--[[function Starlo:beforeStateChange(old, new)
    local ceroba = Game.battle:getEnemyBattler("ceroba_geno")
    if ceroba then
        if old == "DEFENDINGEND" and new ~= "DEFENDINGEND" and not self.intro_finished then
            self.intro_finished = true
            Game.battle:setState("NONE")
            Game.battle:startCutscene("ceroba_geno", "intro")
        end
        if old == "ENEMYDIALOGUE" and new ~= "ENEMYDIALOGUE" and ceroba.health <= 500 and ceroba.phase == 1 then
            ceroba.phase = 2
            Game.battle:setState("NONE")
            Game.battle:startCutscene("ceroba_geno", "phase_switch")
        end
    end
end]]

return Starlo
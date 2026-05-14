local Starlo, super = Class(LightEncounter)

function Starlo:init()
    super.init(self)

    self.text = "* Showdown."

    self.music = "showdown"

    self:addEnemy("starlo", 318, 236)

    self.background = false

    self.can_flee = false

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

return Starlo
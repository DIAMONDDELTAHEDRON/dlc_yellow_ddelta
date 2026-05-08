local Ceroba, super = Class(LightEncounter)

function Ceroba:init()
    super.init(self)

    self.text = "* The atmosphere chills with\nire."

    self.music = "trial_by_fury"

    self:addEnemy("ceroba_geno")

    self.background = true

    self.offset = 0

    self.can_flee = false

    self.intro_finished = false
	
	self.is_ceroba = true
	self.arena_damage = false
end

function Ceroba:getNextWaves()
    local waves = {}
	if Game.battle:getEnemyBattler("ceroba_geno").phase == 2 then
		table.insert(waves, "ceroba/arena_damage")
	end
    for _,enemy in ipairs(Game.battle:getActiveEnemies()) do
        local wave = enemy:selectWave()
        if wave then
            table.insert(waves, wave)
        end
    end
    return waves
end

function Ceroba:onBattleInit()
	MagicalGlassLib.serious_mode = true
end

function Ceroba:setBattleState()
    local ceroba = Game.battle:getEnemyBattler("ceroba_geno")
    ceroba:toggleOverlay(true)
    ceroba:getActiveSprite():setSprite("animations/intro_1")
    Game.battle.music:play(self.music)
    Game.battle:setState("ENEMYDIALOGUE")
end

function Ceroba:update()
    super.update(self)
	if Game.battle.arena and self.arena_damage == true then
		local ceroba_part = Game.battle.enemies[1].actor:getLightBattlerPart("body")
		local cur_ceroba_col = 200 - (((ceroba_part.stretch - 1) / 0.1) * 200)
		local ceroba_color = {1, cur_ceroba_col/255, cur_ceroba_col/255, 1}
		Game.battle.arena.color = ceroba_color
	end
end

function Ceroba:createBackground()
    local background = CerobaBattleBackground()
    return Game.battle:addChild(background)
end

function Ceroba:beforeStateChange(old, new)
    local ceroba = Game.battle:getEnemyBattler("ceroba_geno")
    if ceroba then
        if old == "DEFENDING" and new ~= "DEFENDING" and not self.intro_finished then
            -- clears the wave if you skip it using debug
            for _,wave in ipairs(Game.battle.waves) do
                if not wave:onEnd(false) then
                    wave:clear()
                    wave:remove()
                end
            end
            self.intro_finished = true
            Game.battle:setState("DEFENDINGEND", "NONE")
            Game.battle.timer:afterCond(function() return Game.battle.substate == "ARENARESET" end, function()
                Game.battle:setSubState("NONE")
                Game.battle:startCutscene("ceroba_geno", "intro")
            end)
        end
        if old == "ENEMYDIALOGUE" and new ~= "ENEMYDIALOGUE" and ceroba.health <= 500 and ceroba.phase == 1 then
            ceroba.phase = 2
            Game.battle:setState("NONE")
            Game.battle:startCutscene("ceroba_geno", "phase_switch")
        end
    end
end

function Ceroba:getVictoryMoney(money)
	return 0
end

return Ceroba
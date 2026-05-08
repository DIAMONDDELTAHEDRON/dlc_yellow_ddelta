local Axis, super = Class(LightEnemyBattler)

function Axis:init()
    super.init(self)

    self.name = "Axis"
    self:setActor("axisboss")

    self.max_health = 750
    self.health = 750
    self.attack = 13
    self.defense = 12
    self.money = 0
    self.experience = 200
    self.spare_percentage = 0

    self.service_mercy = 0
    self.boss = true

    self.dialogue_bubble = "uty_large"
    self.dialogue_offset = {-30, 10}

    self.waves = {
        "axis/basic_axis"
    }

    --[[self.dialogue = {
        "[wave:3][speed:0.5]....."
    }]]

    self.check = "ATK "..self.attack.." DEF "..self.defense.."\n* Today means the Surface."

    self.text = {
        "* The air thickens.",
        "* Death by metal & magic.",
        "* You feel the furnace's heat\nwaves engulf you.",
        "* Smells like an unfortunate BBQ.",
        "* Axis seems on edge.",
        "* Axis is flipping through the\nRoyal Guard guide book... in his\nmind.",
        "* Axis is having trouble charging\nup his next attack.",
        "* Axis blows into one of his\nvents to clean some dust. You\ndon't know how.",
        "* Axis pinches the end of one of\nhis gloves and releases the air.\nHe finds it amusing.",
        "* Axis thinks this music is a bit\nintense for his tastes."
    }

    self.spareable_text = "* Axis has cooled off."

    self:registerAct("Brace")
    self:registerAct("Scrutinize")
    self:registerAct("Cool")
    --self:registerAct("Compliment")
	self:registerMarcyAct("Marcy's Idea")

    self.gauge_size = {250, 18}

    self.damage_offset = {0, 42}
end

function Axis:onDefeat(damage, battler)
    self.hurt_timer = -1
    local sprite = self:getActiveSprite()
    sprite:stopShake()
    if Game.battle.battle_ui.attacking then
        Game.battle.battle_ui:endAttack()
    end
    Game.battle:setState("NONE")
    Game.battle:startCutscene("axis", "death")
end

function Axis:onAct(battler, name)
    if name == "Check" then
        return "* AXIS -- "..self.check
    elseif name == "Brace" then
        return "* You ready your trusty shield\nfor whatever awaits."
    elseif name == "Scrutinize" then
        local rnd = math.random(1, 3)
        if rnd == 1 then
            return "* You tell Axis he's not great at\nhis job. If he could frown, he\nwould."
        elseif rnd == 2 then
            return "* You criticize Axis' attack\nstrategy. Steam shoots out of\nhis hearing ducts."
        else
            return "* You say something rude to Axis.\nHe \"HONESTLY DOES NOT APPRECIATE\nIT.\""
        end
    elseif name == "Cool" then
        return "* You pull on your shirt\nrepeatedly in hopes to beat the\nheat. Your effort fails."
    elseif name == "Marcy's Idea" then
        if not self.marcy_acted then
			Game.battle:startActCutscene(function(cutscene)
				cutscene:text("* Marcy has an idea...", "neutral", "marcy")
				cutscene:text("* Hey, Axis?", "neutral", "marcy")
				cutscene:battlerText(self, {
                    "WHAT IS IT.",
                    "IT BETTER BE\nIMPORTANT."
                })
				cutscene:text("* Y-you wouldn't h-hurt a poor child l-like Marcy, would you?", "frown", "marcy")
				cutscene:text("* M-Marcy just wants t-to go home...", "frown", "marcy")
				cutscene:battlerText(self, {
                    "SCANNING ENTITY...",
                    "FAKE TEARS DETECTED.\nRESUMING PROTOCOL.",
                })
				cutscene:text("* Drat...", "disturbed", "marcy")
			end)
			self.marcy_acted = true
			return
		else
			return "* Marcy seems to be out of ideas."
		end
    elseif name == "Standard" then
        if battler.chara.id == "susie" then
            if not self.susie_acted then
                Game.battle:startActCutscene(function(cutscene)
                    cutscene:text("* Susie tries to reason with Axis...")
                    cutscene:text("* Hey uhh...", "nervous_side", "susie")
                    cutscene:text("* I know we started off kinda badly...", "nervous", "susie")
                    cutscene:text("* When you tried to apprehend us and stuff...", "shy", "susie")
                    cutscene:text("* But how about you just let us go?", "neutral", "susie")
                    cutscene:text("* I can promise you we won't come back here if you do.", "nervous_side", "susie")
                    cutscene:battlerText(self, {
                        "YOU SHOULD'VE\nDONE THAT FROM\nTHE BEGINNING.",
                        "NOW IT'S TOO\nLATE FOR THAT.",
                        "MY PROTOCOL IS\nALREADY SET\nON YOUR\nAPPREHENSION."
                    })
                    cutscene:text("* Guess we'll have to do this the hard way then.", "annoyed", "susie")
                end)
                self.susie_acted = true
            else
                return "* Susie doesn't want to try to reason again."
            end
        elseif battler.chara.id == "noelle" then
            if not self.noelle_acted then
                Game.battle:startActCutscene(function(cutscene)
                    cutscene:text("* Noelle thinks about the situtaion...")
                    cutscene:text("* (I'm actually not sure if we can convince him like that.)", "frown", "noelle")
                    cutscene:text("* (He seems to be pretty angry right now...)", "confused", "noelle")
                    cutscene:text("* (So reasoning might not work.)", "confused_surprise", "noelle")
                    cutscene:text("* (Maybe we could tire him out?)", "confused", "noelle")
                    cutscene:text("* (Wait,[wait:5] robots can't get tired,[wait:5] can they?)", "what_smile", "noelle")
                end)
                self.noelle_acted = true
                return
            else
                return "* Noelle doesn't have anything more to say."
            end
        elseif battler.chara.id == "jamm" then
            if not self.jamm_acted then
                Game.battle:startActCutscene(function(cutscene)
                    cutscene:text("* Alright,[wait:5] let me think...", "look_left", "jamm")
                    cutscene:text("* Hmm...[wait:5] How would one go about dealing with an aggressive robot?", "suspicious", "jamm")
                    cutscene:text("* Oh![wait:5] I know.", "smug", "jamm")
                    cutscene:text("* Hey,[wait:5] Axis!", "smirk", "jamm")
                    cutscene:battlerText(self, {
                        "WHAT IS IT.",
                        "IT BETTER BE\nIMPORTANT."
                    })
                    cutscene:text("* This sentence is false!", "smirk", "jamm")
                    cutscene:battlerText(self, {
                        ".  .  .",
                        "[color:FF00FF]PARADOX\nDETECTED.",
                        "[color:FF00FF]ERASING THE\nMEMORY ABOUT\nRECIEVING THE\nPARADOX."
                    })
                    cutscene:text("* Damn it.[wait:5] His creator was smart...", "suspicious", "jamm")
                end)
                self.jamm_acted = true
                return
            else
                Game.battle:startActCutscene(function(cutscene)
                    cutscene:text("* Sorry.[wait:5] Outta ideas.", "look_left", "jamm")
                end)
                return
            end
        else
            return "* But "..battler.chara:getName().." didn't know what to do."
        end
    end

    return super.onAct(self, battler, name)
end

function Axis:getAttackDamage(damage, lane, points, stretch)
    if self.axis_protected == true then
        return 0
    elseif self.battle_phase == 9 then
        return self.health
    else
        return super.getAttackDamage(self, damage, lane, points, stretch)
    end
end

function Axis:onDodge(battler, attacked)
    if self.axis_protected == true then
        if attacked == true then
            Assets.playSound("bell")
        end
    end
end

function Axis:getEncounterText()
    local has_spareable_text = self.spareable_text and self:canSpare()

    if has_spareable_text then
        return self.spareable_text
    elseif self.battle_phase == 9 then
        return "* Axis is staring at you blankly\nuntil you do something."
    end

    return Utils.pick(self.text)
end

function Axis:onHurtEnd()
    self:getActiveSprite():stopShake()
    if self.health > 0 or not self.exit_on_defeat then
        self:toggleOverlay(false, true)
    end

    --[[if self.health <= 50 and self.battle_phase < 9 and self.health > 0 then
        self.battle_phase = 9
        if Game.battle.battle_ui.attacking then
            Game.battle.battle_ui:endAttack()
        end
        Game.battle:startCutscene("axis", "out_of_power")
    elseif self.health <= 150 and self.battle_phase < 8 then
        self.battle_phase = 8
        self.dialogue_override = {
            "DoPDzzzZ_//",
            "GAH. ",
            "YOU WOULD NOT\nLIKE ME AT LOW\nBATTERY.",
            "I AM WARNING YOU\nTO NOT DRAIN\nMY BATTERY."
        }
    elseif self.health <= 450 and self.battle_phase < 5 then
        self.battle_phase = 5
        self.dialogue_override = {
            "ZBsssZ t-t-D\n? d",
            "THAT IS ENOUGH.",
            "UNBEKNOWNST TO\nYOU, I BROUGHT\nA BACKUP PLAN.",
            "PORTABLE\nGENERATORS\n=\nINFINITE BATTERY.",
            "GOOD LUCK."
        }
        self.axis_protected = true
    elseif self.health <= 500 and self.battle_phase < 4 then
        self.battle_phase = 4
        self.dialogue_override = {
            "AZ_a_D?f\nF . .",
            "I A-AM ST_ARTING\nTO REGRET GIVING\nYOU THAT LID.",
            "COULD YOU PLEASE\nDROP IT?",
            "JUST KICK IT\nINTO THE FIERY\nPIT BELOW US.\nSIMPLE."
        }
    elseif self.health <= 600 and self.battle_phase < 3 then
        self.battle_phase = 3
        self.dialogue_override = {
            "BZZT_Zz\nPRpP /",
            "I DID IT AGAIN.\nHOW.",
            "WAIT. THIS IS\nYOUR DOING. OF\nCOURSE IT IS.",
            "DO NOT SHOCK\nME AGAIN, OKAY?"
        }
    elseif self.health <= 700 and self.battle_phase < 2 then
        self.battle_phase = 2
        self.dialogue_override = {
            "ZzzZZKKZ\nDPPP-D_-A - _",
            "WHAT WAS THAT?\nWHAT DID I SAY?",
            "\"ZzzZKKZ\nDPPP-D_-A - _\"\nIS NOT A WORD.",
            "WHY DID I SAY\nTHAT?"
        }
    end]]
end

function Axis:getNextWaves()
    if self.battle_phase == 9 then
        return nil
    else
        return self.waves
    end
end

return Axis
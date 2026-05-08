local Goosic, super = Class(LightEnemyBattler)

function Goosic:init()
    super.init(self)

    self.name = "Goosic"
    self:setActor("goosic_b")

    self.max_health = 160
    self.health = 160
    self.attack = 12
    self.defense = 8
    self.money = 18
    self.experience = 0

    self.dialogue_bubble = "uty_large"
    self.dialogue_offset = {-30, 10}

    self.waves = {
        --"goosic/eq_visualizer",
        "goosic/disk",
        --"goosic/speaker"
    }

    self.dialogue = {
        "bzt- YOU'RE\nLISTENING TO\nD-E-A-T-H\nRADIO-O-o !",
        "TH-TH-THIS ONE\nGOES OUT TO ALL\nTHE HUMANS\nOUT THERE !",
        "LOUDER !\nLOUDER !\nLOUDER !",
        "I'M G-GIVING AWAY\nONE FREE TICKET\nTO THE A-A-AFTERLIFE !",
        "bzt- AND NOW A WORD\nFROM OUR SPONSOR:\nBULLET-PATTERNS ! "
    }

    self.calm_dialogue = {
        "This is\nn-nice :)",
        "Mhm,\nyeah :)"
    }

    self.dialogue_with_jandroid = {
        "THREE'S A CROWD !\nIT'S CONCERT\nTIME !",
        "I SEE YOUR MOVES !\nGET IT GET IT !"
    }

    self.low_health_dialogue = {
        "D-DOn'T HATE\nON MY m/MusIC\nTASTES_",
        "BiT OF A\nH-H-HARSH nOISE\nCOMPLAINT/ /"
    }

    self.check = "ATK "..self.attack.." DEF "..self.defense.."\n* Music drives the mood."

    self.text = {
        "* Goosic slowly scratches a\nrecord with its needle.[wait:10] The\nsound is unbearable.",
        "* Goosic begins spinning in\ncircles.",
        "* Goosic blasts battle music from\nits beak.",
        "* Your eardrums do not appreciate\nthe current situation.",
        "* Goosic does a little two-step\nlike it's nothing."
    }

    self.spareable_text = "* Goosic is lost in the music."
    self.low_health_text = {
        "* Goosic struggles to keep\ndancing.",
        "* Goosic's music bends in and out\nof tune."
    }

    self.low_health = false
    self.track_changed = false

    self:registerAct("Vibe")
    self:registerAct("Ignore")
    self:registerAct("Needle")

    --self.gauge_size = {250, 20}

    self.damage_offset = {0, 80}
end

function Goosic:getDamageVoice()
    return "hurt_robot"
end

function Goosic:onAct(battler, name)
    if name == "Check" then
        return "* GOOSIC -- "..self.check
    elseif name == "Vibe" then
        if self.low_health then
            return "* You calm yourself in the midst\nof the battle."
        else
            if not self.track_changed then
                local rnd = Utils.pick({1, 2})
                if rnd == 1 then
                    self.dialogue_override = "KEEP UP !\nKEEP UP !"
                else
                    self.dialogue_override = "IF YOU CAN'T\nV-VIBE TO IT,\nGIVE IT U-U-UP !"
                end
                return "* You try to enjoy the music but\ncan't keep up."
            else
                self:addMercy(50)
                local rnd = Utils.pick({1, 2})
                if rnd == 1 then
                    self.dialogue_override = "Okay, yeah !\nI see you !"
                else
                    self.dialogue_override = "Oh, now THIS\nis groovy !"
                end
                return "* You close your eyes and tap\nyour foot to the music.[wait:10] Goosic\njoins you."
            end
        end
    elseif name == "Ignore" then
        if self.low_health then
            return "* You tune Goosic out."
        else
            if not self.track_changed then
                local rnd = Utils.pick({1, 2})
                if rnd == 1 then
                    self.dialogue_override = "WHAT'S THAT ?\nMORE VOLUME ?"
                else
                    self.dialogue_override = "D-D-DISRESPECTFUL !"
                end
                return "* You plug your ears in hopes to\nblock the noise.[wait:10] Goosic just\nturns it up."
            else
                local rnd = Utils.pick({1, 2})
                if rnd == 1 then
                    self.dialogue_override = "Come o-on,\nrelax a\nl-l-little ."
                else
                    self.dialogue_override = "N-No need to\nbe bashful,\nbuddy ."
                end
                return "* You try not to get wrapped up\nin the music."
            end
        end
    elseif name == "Needle" then
        if self.low_health then
            return "* You try to move Goosic's needle\nbut it shocks you."
        else
            if not self.track_changed then
                self.track_changed = true
                self:addMercy(50)
                local rnd = Utils.pick({1, 2})
                if rnd == 1 then
                    self.dialogue_override = "HEY W-W-what\nis... this ?"
                else
                    self.dialogue_override = "WAIT !\nI... Oh ?"
                end
                return "* You move Goosic's needle to a\nnew,[wait:5] calmer record."
            else
                local rnd = Utils.pick({1, 2})
                if rnd == 1 then
                    self.dialogue_override = "Don't k-kill\nthe mood :)"
                else
                    self.dialogue_override = "I like\nth-this one :)"
                end
                return "* Goosic seems to be calming\ndown.[wait:10] Shouldn't change the song\nnow."
            end
        end
    elseif name == "Standard" then
        if self.low_health then
			if battler.chara.id == "jamm" and Game:getFlag("marcy_joined") then
				return "* Jamm and Marcy calm themselves in the midst of battle."
            else
                return "* "..battler.chara:getName().." calms themselves in the\nmidst of the battle."
			end
        else
            if not self.track_changed then
                if battler.chara.id == "susie" then
                    return "* Susie is annoyed by the loud music."
                elseif battler.chara.id == "noelle" then
                    return "* Noelle can't keep up with the music."
                elseif battler.chara.id == "dess" then
                    if not self.dess_acted_1 then
                        Game.battle:startActCutscene(function(cutscene)
                            cutscene:text("* Hell yeah that's what I call good music.", "swag", "dess")
                            if #Game.party > 1 then
                                if #Game.party == 2 then
                                    cutscene:text("* You just have bad taste.", "heckyeah", "dess")
                                else
                                    cutscene:text("* Y'all just have bad taste.", "heckyeah", "dess")
                                end
                            end
                        end)
                        self.dess_acted_1 = true
                        return
                    else
                        return "* Dess is still somehow enjoying the music."
                    end
                elseif battler.chara.id == "jamm" then
					if Game:getFlag("marcy_joined") then
                        return "* Jamm and Marcy don't enjoy the music."
                    else
                        return "* Jamm doesn't enjoy the music."
                    end
				else
                    local rnd = Utils.pick({1, 2})
                    if rnd == 1 then
                        self.dialogue_override = "KEEP UP !\nKEEP UP !"
                    else
                        self.dialogue_override = "IF YOU CAN'T\nV-VIBE TO IT,\nGIVE IT U-U-UP !"
                    end
                    return "* "..battler.chara:getName().." tries to enjoy the music\nbut can't keep up."
                end
            else
                if battler.chara.id == "susie" then
                    if not self.susie_acted then
                        Game.battle:startActCutscene(function(cutscene)
                            cutscene:text("* Hm...[wait:5] Nice music for some dance moves.", "closed_grin", "susie")
                            cutscene:text("* Susie shows off her dancing skills.")
                            cutscene:text("* Heh,[wait:5] how's that?", "smile", "susie")
                        end)
                        self:addMercy(50)
                        self.dialogue_override = "Nice dance there :)"
                        self.susie_acted = true
                        return
                    else
                        return "* Susie has already danced enough."
                    end
                elseif battler.chara.id == "noelle" then
                    if not self.noelle_acted then
                        self.dialogue_override = "T-thanks deer girl!"
                        Game.battle:startActCutscene(function(cutscene)
                            cutscene:text("* Noelle compliments Goosic's music taste.")
                            cutscene:text("* That melody seems nice...", "smile_closed", "noelle")
                        end)
                        self:addMercy(50)
                        self.noelle_acted = true
                        return
                    else
                        return "* Noelle enjoys the music."
                    end
                elseif battler.chara.id == "dess" then
                    if not self.dess_acted_2 then
                        Game.battle:startActCutscene(function(cutscene)
                            cutscene:text("* It was better before.", "eyebrow", "dess")
                        end)
                        self.dess_acted_2 = true
                        return
                    else
                        return "* Dess is not enjoying the music."
                    end
                elseif battler.chara.id == "jamm" then
                    if Game:getFlag("marcy_joined") then
                        Game.battle:startActCutscene(function(cutscene)
                            cutscene:text("* Papa,[wait:5] Marcy is enjoying the music.", "happy", "marcy")
                            cutscene:text("* Me too,[wait:5] Marcy...[wait:10] Me too.", "happy", "jamm")
                        end)
                        self:addMercy(50)
                        return
                    else
                        Game.battle:startActCutscene(function(cutscene)
                            cutscene:text("* Now that's what I'm talking about.", "smug", "jamm")
                            cutscene:text("* This new track is quite enjoyable.", "smirk", "jamm")
                        end)
                        self:addMercy(50)
                        return
                    end
				else
                    local rnd = Utils.pick({1, 2})
                    if rnd == 1 then
                        self.dialogue_override = "Okay, yeah !\nI see you !"
                    else
                        self.dialogue_override = "Oh, now THIS\nis groovy !"
                    end
                    return "* "..battler.chara:getName().." closes their eyes and taps\ntheir foot to the music.[wait:10] Goosic\njoins them."
                end
            end
        end
    end

    return super.onAct(self, battler, name)
end

function Goosic:onDefeat(damage, battler)
    Game.battle.encounter.goosic_kill_reaction = true
    Game.battle.encounter.kill_count = Game.battle.encounter.kill_count + 1

    self.hurt_timer = -1
    local sprite = self:getActiveSprite()
    sprite:stopShake()
    sprite:setAnimation("lightbattle_spared")
    self:defeat("KILLED", true)

    Game:setFlag("steamworks_kills", Game:getFlag("steamworks_kills") + 1)
    if Game:getFlag("steamworks_kills") == 20 then
        Game:setFlag("EMPTIED_STEAMWORKS", true)
        MUSIC_PITCHES["steamworks_overworld"] = 0.25
    elseif Game:getFlag("steamworks_kills") > 13 and Game:getFlag("steamworks_kills") < 20 and #Game.battle:getActiveEnemies() > 0 then
        Game.battle.timer:after(1, function()
            local enemies_left = 20 - Game:getFlag("steamworks_kills")
            local mus_pitch = 1
            if enemies_left > 0 then
                mus_pitch = (enemies_left / 7)
            end
            Game.battle.music:setPitch(mus_pitch)
        end)
    elseif Game:getFlag("steamworks_kills") == 13 and #Game.battle:getActiveEnemies() > 0 then
        Game.battle.music:stop()
        Game.battle.timer:after(1, function()
            Game.battle.music:play("genobattle_yellow")
        end)
    end

    Game.battle.timer:after(0.8, function()
        self.alpha = 0
        Assets.playSound("ut_explosion")
        Game.battle:addChild(RobotDestroyExplosion(self.x, self.y-self.height/2))
        self:explodeParts()
    end)
end

function Goosic:explodeParts()
    local x, y = self:getRelativePos(self.width / 2, self.height / 2)
    local path = "battle/lightenemies/goosic/explosion_parts/"
    Game.battle:addChild(RobotDestroyPartParent(path.."leg_back", x - 25, y + 42, 13, 19))
    Game.battle:addChild(RobotDestroyPartParent(path.."body",     x,      y,      33, 34))
    Game.battle:addChild(RobotDestroyPartParent(path.."leg",      x + 16, y + 44, 16, 21))
    Game.battle:addChild(RobotDestroyPartParent(path.."neck",     x - 39, y + 21, 9,  9))
    Game.battle:addChild(RobotDestroyPartParent(path.."neck",     x - 52, y + 9,  9,  9))
    Game.battle:addChild(RobotDestroyPartParent(path.."neck",     x - 57, y - 9,  9,  9))
    Game.battle:addChild(RobotDestroyPartParent(path.."neck",     x - 57, y - 25, 9,  9))
    Game.battle:addChild(RobotDestroyPartParent(path.."neck",     x - 48, y - 43, 9,  9))
    Game.battle:addChild(RobotDestroyPartParent(path.."crown",    x - 48, y - 90, 22, 19))
    Game.battle:addChild(RobotDestroyPartParent(path.."head",     x - 33, y - 66, 21, 21))
    Game.battle:addChild(RobotDestroyPartParent(path.."mouth",    x + 10, y - 70, 35, 42))
end

function Goosic:getEncounterText()
    local has_spareable_text = self.spareable_text and self:canSpare()

    if Game.battle.encounter.jandroid_kill_reaction then
        Game.battle.encounter.jandroid_kill_reaction = false
        return "* Goosic instantly forgets about\nJandroid."

    elseif self.low_health_text and self.health <= (self.max_health * self.low_health_percentage) then
        return Utils.pick(self.low_health_text)

    elseif self.tired_text and self.tired then
        return self.tired_text

    elseif has_spareable_text then
        return self.spareable_text
    end

    return Utils.pick(self.text)
end

function Goosic:getEnemyDialogue()
    if Game.battle.encounter.jandroid_kill_reaction then
        return "TA-TA-TAKE\nA CHILL PILL\nBUDDY !"
    end
    if self.dialogue_override then
        local dialogue = self.dialogue_override
        self.dialogue_override = nil
        return dialogue
    end
    if self.low_health_dialogue and self.health <= (self.max_health * self.low_health_percentage) then
        return Utils.pick(self.low_health_dialogue)
    end
    if self.track_changed then
        return Utils.pick(self.calm_dialogue)
    end
    if Game.battle:getEnemyBattler("jandroid") then
        return Utils.pick(self.dialogue_with_jandroid)
    end

    return Utils.pick(self.dialogue)
end

function Goosic:onHurtEnd()
    self:getActiveSprite():stopShake()
    if self.health > 0 or not self.exit_on_defeat then
        self:toggleOverlay(false, true)
    end
    if self.low_health == false and self.health <= (self.max_health * self.low_health_percentage) then
        self.low_health = true
        self:setActor("goosic_b_hurt")
    end
end

return Goosic
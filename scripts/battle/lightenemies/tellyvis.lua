local TellyVis, super = Class(LightEnemyBattler)

function TellyVis:init()
    super.init(self)

    self.name = "Telly-Vis"
    self:setActor("tellyvis_b")

    self.max_health = 160
    self.health = 160
    self.attack = 12
    self.defense = 12
    self.money = 25
    self.experience = 0

    self.dialogue_bubble = "uty_2"
    self.dialogue_offset = {-30, 10}

    self.waves = {
        "basic"
    }

    self.dialogue = {
        "Don't touch that\ndial! Seriously,\nI'll hurt you.",
        "I live life in\nglorious standard\ndefinition!\nNothing better!",
        "Never take\nadvice from\nVis. He's\na mouthful!",
        "Network TV? Yeah,\nI do the work,\nand they net\nthe profits!"
    }

    self.low_health_dialogue = {
        "T/Time to;?\nGo on coMmercial\nbreak. ... ."
    }

    self.check = "ATK "..self.attack.." DEF "..self.defense.."\n* Can't live with or without\none another."

    self.text = {
        "* Telly-Vis are debating which\nseason of the news is superior.",
        "* Telly pushes Vis' mouth-flap\nback and forth for amusement.\nVis isn't having it.",
        "* Vis reminds Telly what time his\nfavorite show airs but she only\nmakes fun of him.",
        "* The sound of TV static fills\nyour head.",
        "* Telly starts to sing an anime\nopening. Vis begs her to stop.",
        "* You wonder where the mute\nbutton is."
    }

    self.spareable_text = "* Telly-Vis hope you enjoyed the\nprogram."
    self.low_health_text = {
        "* Telly is frantically flipping\nchannels.",
        "* Vis spits out a broken video\ncassette."
    }

    self.low_health = false
    self.switched_channel = false

    self:registerAct("Watch")
    self:registerAct("Nap")
    self:registerAct("Signal")

    --self.gauge_size = {250, 20}

    self.damage_offset = {0, 80}
end

function TellyVis:onAct(battler, name)
    if name == "Check" then
        return "* TELLYVIS -- "..self.check
    elseif name == "Watch" then
        if self.low_health then
            self.dialogue_override = "Th.i>s is- my\nf-f-favorite shoOw/"
            return "* Nothing on."
        else
            if not self.switched_channel then
                local rnd = Utils.pick({1, 2})
                if rnd == 1 then
                    self.dialogue_override = "What are you\nstaring at?"
                else
                    self.dialogue_override = "There's nothing\non yet!"
                end
                return "* While this IS your favorite\nchannel,[wait:5] Telly-Vis don't look\namused."
            else
                self:addMercy(50)
                local rnd = Utils.pick({1, 2})
                if rnd == 1 then
                    self.dialogue_override = "Oh![wait:5] Check\nthis out!"
                else
                    self.dialogue_override = "Here comes the\nbest part!"
                end
                return "* Telly finds a show she thinks\nyou'll love."
            end
        end
    elseif name == "Nap" then
        if self.low_health then
            return "* You couldn't sleep if you\nwanted to."
        else
            local rnd = Utils.pick({1, 2})
            if rnd == 1 then
                self.dialogue_override = "Am...[wait:5] Am I\nboring you?"
            else
                self.dialogue_override = "Hey,[wait:5] buddy![wait:5]\nI'm still here!"
            end
            return "* You begin to drift off to the\ndismay of Telly.. "
        end
    elseif name == "Signal" then
        if self.low_health then
            self.dialogue_override = "/NeEd s[ome\nMaint/enan-ce . ,,"
            return "* You see if Telly's antennas\nstill function.[wait:5] They do not."
        else
            if not self.switched_channel then
                self:addMercy(50)
                self.switched_channel = true
                local rnd = Utils.pick({1, 2})
                if rnd == 1 then
                    self.dialogue_override = "Just what\nI needed!"
                else
                    self.dialogue_override = "Whoa,[wait:5] hey![wait:5]\nI'm picking\nsomething up!"
                end
                return "* You help Telly finagle her\nantennas to find some\nprogramming."
            else
                local rnd = Utils.pick({1, 2})
                if rnd == 1 then
                    self.dialogue_override = "They're good\nwhere they are!"
                else
                    self.dialogue_override = "Hey, don't ruin\nmy electrical\nflow!"
                end
                return "* You attempt to touch Telly's\nantennas again but she motions\nyou away."
            end
        end
    elseif name == "Standard" then
        if self.low_health then
            self.dialogue_override = "Th.i>s is- my\nf-f-favorite shoOw/"
            return "* Nothing on."
        else
            if not self.switched_channel then
                if battler.chara.id == "susie" then
                    Game.battle:startActCutscene(function(cutscene)
                        cutscene:text("* Hm...", "neutral_side", "susie")
                        cutscene:text("* Maybe a good slap on the side will make them work better!", "smile", "susie")
                        self:addMercy(50)
                        Assets.playSound("damage")
                        self:shake(4)
                        cutscene:wait(0.5)
                    end)
                    self.dialogue_override = "O-ow.[wait:5] Well,[wait:5] at least that helped."
                    self.switched_channel = true
                elseif battler.chara.id == "noelle" then
                    if not self.noelle_acted then
                        self.dialogue_override = "N-no! Don't turn me off!"
                        Game.battle:startActCutscene(function(cutscene)
                            cutscene:text("* Usually when our TV doesn't work...", "frown", "noelle")
                            cutscene:text("* Mom just turns it off and on.", "confused", "noelle")
                        end)
                        self.noelle_acted = true
                        return
                    else
                        return "* Noelle doesn't think she can help Telly-Vis."
                    end
                else
                    local rnd = Utils.pick({1, 2})
                    if rnd == 1 then
                        self.dialogue_override = "What are you\nstaring at?"
                    else
                        self.dialogue_override = "There's nothing\non yet!"
                    end
                    return "* While this IS "..battler.chara:getName().."'s favorite\nchannel,[wait:5] Telly-Vis don't look\namused."
                end
            else
                self:addMercy(50)
                if battler.chara.id == "susie" then
                    return "* Susie watches the new program and finds it pretty entertaining."
                elseif battler.chara.id == "noelle" then
                    return "* Noelle enjoys the program."
                else
                    local rnd = Utils.pick({1, 2})
                    if rnd == 1 then
                        self.dialogue_override = "Oh![wait:5] Check\nthis out!"
                    else
                        self.dialogue_override = "Here comes the\nbest part!"
                    end
                    return "* Telly finds a show she thinks\n"..battler.chara:getName().." will love."
                end
            end
        end
    end

    return super.onAct(self, battler, name)
end

function TellyVis:onDefeat(damage, battler)
    Game.battle.encounter.kill_count = Game.battle.encounter.kill_count + 1

    self.hurt_timer = -1
    local sprite = self:getActiveSprite()
    sprite:stopShake()
    self:toggleOverlay(false)
    self:defeat("KILLED", true)

    Game:setFlag("steamworks_kills", Game:getFlag("steamworks_kills") + 1)
    if Game:getFlag("steamworks_kills") == 20 then
        Game:setFlag("EMPTIED_STEAMWORKS", true)
        MUSIC_PITCHES["steamworks_overworld"] = 0.25
    end

    Game.battle.timer:after(0.8, function()
        self:toggleOverlay(true)
        self.alpha = 0
        Assets.playSound("ut_explosion")
        Game.battle:addChild(RobotDestroyExplosion(self.x, self.y-self.height/2))
        self:explodeParts()
    end)
end

function TellyVis:explodeParts()
    local x, y = self:getRelativePos(self.width / 2, self.height / 2)
    local path = "battle/lightenemies/tellyvis/explosion_parts/"
    Game.battle:addChild(RobotDestroyPartParent(path.."body", x - 2, y - 72, 78, 68))
    local lefth = Game.battle:addChild(RobotDestroyPartParent(path.."hand", x - 64, y - 60, 27, 38))
    lefth.scale_x = -1
    Game.battle:addChild(RobotDestroyPartParent(path.."hand", x + 64, y - 60, 27, 38))
    local leftl = Game.battle:addChild(RobotDestroyPartParent(path.."leg", x - 24, y - 15, 16, 11))
    leftl.scale_x = -1
    Game.battle:addChild(RobotDestroyPartParent(path.."leg", x + 23, y - 15, 16, 11))
end

function TellyVis:getEncounterText()
    local has_spareable_text = self.spareable_text and self:canSpare()

    local priority_spareable_text = Game:getConfig("prioritySpareableText")
    if priority_spareable_text and has_spareable_text then
        return self.spareable_text
    end

    if self.low_health_text and self.health <= (self.max_health * self.low_health_percentage) then
        return Utils.pick(self.low_health_text)

    elseif self.tired_text and self.tired then
        return self.tired_text

    elseif has_spareable_text then
        return self.spareable_text
    end

    return Utils.pick(self.text)
end

function TellyVis:getEnemyDialogue()
    if self.dialogue_override then
        local dialogue = self.dialogue_override
        self.dialogue_override = nil
        return dialogue
    end
    if self.low_health_dialogue and self.health <= (self.max_health * self.low_health_percentage) then
        return Utils.pick(self.low_health_dialogue)
    end
    return Utils.pick(self.dialogue)
end

function TellyVis:onHurtEnd()
    self:getActiveSprite():stopShake()
    if self.health > 0 or not self.exit_on_defeat then
        self:toggleOverlay(false, true)
    end
    if self.low_health == false and self.health <= (self.max_health * self.low_health_percentage) then
        self.low_health = true
        self:setActor("tellyvis_b_hurt")
    end
end

return TellyVis
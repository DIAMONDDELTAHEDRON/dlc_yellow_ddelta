local Frostermit, super = Class(LightEnemyBattler)

function Frostermit:init()
    super.init(self)

    self.name = "Frostermit"
    self:setActor("frostermit_b")

    self.max_health = 90
    self.health = 90
    self.attack = 6
    self.defense = 6
    self.money = 5
    self.experience = 20

    self.dialogue_bubble = "uty_2"
    self.dialogue_offset = {10, 10}

    self.revealed = false
    self.dance = 0

    self.waves = {
        "basic"
    }

    self.dialogue = {
        "Igloo igloo.",
        "Igloo noises."
    }
    self.dialogue_revealed = {
        "*tap tap*",
        "*pinch pinch*",
        "*snap snap*",
        "You like to\ngroove?",
        "I know some\nsick scuttles."
    }

    self.dialogue_with_know_cone = {
        "I-Igloo?",
        "Repelling\nigloo sounds!"
    }
    self.dialogue_with_know_cone_revealed = {
        "*shudder shudder*",
        "I was not\nprepared for this."
    }

    self.low_health_dialogue = {
        "IGLOO IGLOO ! !",
        "Ow... I mean-\nIGLOO NOISES ! !"
    }
    self.low_health_dialogue_revealed = {
        "Looks like I'm\nin a bit of a\npinch...",
        "My home..."
    }

    self.check = "ATK "..self.attack.." DEF "..self.defense.."\n* A suspicious igloo."
    self.check_revealed = "ATK "..self.attack.." DEF "..self.defense.."\n* Always right at home."

    self.text = {
        "* You think you see the igloo\nmove a bit..",
        "* The igloo towers over you\nmenacingly.\n* Kidding. It's just an igloo.",
        "* There is an igloo here.",
        "* Something smells fishy."
    }
    self.text_revealed = {
        "* Frostermit seems to be\ncontemplating hiding again.",
        "* Frostermit is coming out of its\nshell a bit.",
        "* Frostermit is tapping out a\nrhythm with his pincers.",
        "* Frostermit is doing a\ncrusta-shuffle.",
        "* Frostermit is considering a\nrenovation."
    }

    self.spareable_text = "* Frostermit is ready to scuttle\non its way."
    self.low_health_text = {
        "* The igloo does not appear to be\nstructurally sound anymore.",
        "* The igloo is making distressed\nnoises."
    }
    self.low_health_text_revealed = {
        "* Frostermit is looking a bit\ncrabby with you.",
        "* Frostermit retreats inside for a\nmoment to address a possible\ncave in."
    }

    self.low_health = false

    self:registerAct("Inspect")
    self:registerAct("Dance")
    self:registerAct("Compliment")

    --self.gauge_size = {250, 20}

    self.damage_offset = {0, 80}
end

function Frostermit:getDamageVoice()
    return "flowey_hurt"
end

function Frostermit:onAct(battler, name)
    if name == "Check" then
        if self.revealed then
            return "* FROSTERMIT -- "..self.check_revealed
        else
            return "* FROSTERMIT -- "..self.check
        end
    elseif name == "Inspect" then
        if self.revealed then
            if self.low_health then
                self.dialogue_override = "You better watch\nout. My pinchers\nare fierce."
                return "* You stare at Frostermit."
            else
                local rnd = Utils.pick({1, 2})
                if rnd == 1 then
                    self.dialogue_override = "There's nothing\nto stare at...\nis there?"
                else
                    self.dialogue_override = "That's a little\nrude ya know..."
                end
                return "* You begin giving Frostermit a\ndiscerning once-over.\n* It looks uncomfortable."
            end
        else
            if self.low_health then
                self.dialogue_override = "I-Igloo."
                return "* You look over the damaged igloo."
            else
                local rnd = Utils.pick({1, 2})
                if rnd == 1 then
                    self.dialogue_override = "It's just an\nigloo! Wait,\ndid you say\nthat already?"
                else
                    self.dialogue_override = "Yep, nothing to\nsee here!"
                end
                return "* It's just an igloo."
            end
        end
    elseif name == "Dance" then
        self.dance = self.dance + 1
        if self.revealed then
            if self.low_health then
                self.dialogue_override = "Wannabe."
                return "* You mimic Frostermit's crab\nmoves.\n* It isn't pleased."
            else
                local rnd = Utils.pick({1, 2})
                if rnd == 1 then
                    self.dialogue_override = "Next time I'll\nlead!"
                else
                    self.dialogue_override = "Can you come\ndance with me\nmore often?"
                end
                if self.dance >= 2 then
                    return "* You try to do the worm.\n* You fall flat on the snow, but\nFrostermit is impressed anyway."
                else
                    return "* You start doing a crab walk\ndance.\n* Frostermit jumps in."
                end
            end
        else
            if self.low_health then
                self.dialogue_override = "What even is\nthat? I mean-IGLOO ! !"
                return "* You wiggle around in front of\nthe igloo.\n* Nothing happens."
            else
                self:setActor("frostermit_b_revealed")
                self.revealed = true
                self.dialogue_override = "Um, hi... Can I\njoin?"
                return "* You do a little dance.\n* Someone has come out to\ninvestigate."
            end
        end
    elseif name == "Compliment" then
        if self.revealed then
            if self.low_health then
                self.dialogue_override = "..."
                return "* You commend Frostermit's sharp\nskill."
            else
                self.dialogue_override = "Really?!\nNinja-like?!"
                return "* You compliment Frostermit's\nhiding skills."
            end
        else
            if self.low_health then
                self.dialogue_override = "You don't mean\ntha-IGLOO IGLOO ! !"
                return "* You marvel at how it hasn't\ncrumbled."
            else
                local rnd = Utils.pick({1, 2})
                if rnd == 1 then
                    self.dialogue_override = "Appreciative\nigloo noise!"
                else
                    self.dialogue_override = "Thanks- I mean\nigloO !"
                end
                return "* You comment on the igloo's fine\ncraftsmanship.\n* It's an igloo."
            end
        end
    elseif name == "Standard" then
        if self.low_health == true then
            self.dialogue_override = ""
            return "* Cleaning Frostermit wouldn't\ndo any good at this point."
        else
            self.dialogue_override = ""
			if battler.chara.id == "jamm" and Game:getFlag("marcy_joined") then
				return "* Jamm and Marcy offer to give Frostermit a scrub. They seem offended."
			end
            return "* "..battler.chara:getName().." offers to give Frostermit\na scrub. They seem offended."
        end
    end

    return super.onAct(self, battler, name)
end

function Frostermit:onDefeat(damage, battler)
    super.onDefeat(self, damage, battler)
    Game.battle.encounter.frostermit_kill_reaction = true
    Game.battle.encounter.kill_count = Game.battle.encounter.kill_count + 1

    Game:setFlag("snowdin_yellow_kills", Game:getFlag("snowdin_yellow_kills") + 1)
    if Game:getFlag("snowdin_yellow_kills") == 20 then
        Game:setFlag("EMPTIED_SNOWDIN_YELLOW", true)
        MUSIC_PITCHES["snowfall"] = 0.25
        MUSIC_PITCHES["vigorous_terrain"] = 0.5
    elseif Game:getFlag("snowdin_yellow_kills") > 13 and Game:getFlag("snowdin_yellow_kills") < 20 and #Game.battle:getActiveEnemies() > 0 then
        Game.battle.timer:after(1, function()
            local enemies_left = 20 - Game:getFlag("snowdin_yellow_kills")
            local mus_pitch = 1
            if enemies_left > 0 then
                mus_pitch = (enemies_left / 7)
            end
            Game.battle.music:setPitch(mus_pitch)
        end)
    elseif Game:getFlag("snowdin_yellow_kills") == 13 and #Game.battle:getActiveEnemies() > 0 then
        Game.battle.music:stop()
        Game.battle.timer:after(1, function()
            Game.battle.music:play("genobattle_yellow")
        end)
    end
end

function Frostermit:getEncounterText()
    local has_spareable_text = self.spareable_text and self:canSpare()

    if Game.battle.encounter.know_cone_kill_reaction then
        Game.battle.encounter.know_cone_kill_reaction = false
        return "* Frostermit doesn't know what to do."

    elseif self.low_health_text and self.health <= (self.max_health * self.low_health_percentage) then
        if self.revealed then
            return Utils.pick(self.low_health_text_revealed)
        else
            return Utils.pick(self.low_health_text)
        end

    elseif self.tired_text and self.tired then
        return self.tired_text

    elseif has_spareable_text then
        return self.spareable_text
    end

    if self.revealed then
        return Utils.pick(self.text_revealed)
    else
        return Utils.pick(self.text)
    end
end

function Frostermit:getEnemyDialogue()
    if Game.battle.encounter.know_cone_kill_reaction then
        return "H-he wasn't\nthat annoying..."
    end
    if self.dialogue_override then
        local dialogue = self.dialogue_override
        self.dialogue_override = nil
        return dialogue
    end
    if self.low_health_dialogue and self.health <= (self.max_health * self.low_health_percentage) then
        if self.revealed then
            return Utils.pick(self.low_health_dialogue_revealed)
        else
            return Utils.pick(self.low_health_dialogue)
        end
    end
    if Game.battle:getEnemyBattler("know_cone") then
        if self.revealed then
            return Utils.pick(self.dialogue_with_know_cone_revealed)
        else
            return Utils.pick(self.dialogue_with_know_cone)
        end
    end

    if self.revealed then
        return Utils.pick(self.dialogue_revealed)
    else
        return Utils.pick(self.dialogue)
    end
end

function Frostermit:onHurtEnd()
    self:getActiveSprite():stopShake()
    if self.health > 0 or not self.exit_on_defeat then
        self:toggleOverlay(false, true)
    end
    if not self.low_health and self.health <= (self.max_health * self.low_health_percentage) then
        self.low_health = true
        if self.revealed then
            self:setActor("frostermit_b_revealed_hurt")
        else
            self:setActor("frostermit_b_hurt")
        end
    end
end

function Frostermit:update()
    super.update(self)
    local head = self:getSpritePart("head")
    if self.revealed then
        if self.bubble and self.bubble:isTyping() then
            if not head.playing then
                head:play(4/30, true)
            end
        elseif head.playing then
            head:stop()
        end
    end
end

return Frostermit
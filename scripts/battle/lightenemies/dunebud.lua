local Dunebud, super = Class(LightEnemyBattler)

function Dunebud:init()
    super.init(self)

    self.name = "Dunebud"
    self:setActor("dunebud_b")

    self.max_health = 115
    self.health = 115
    self.attack = 8
    self.defense = 7
    self.money = 8
    self.experience = 57

    self.dialogue_bubble = "uty_large"
    self.dialogue_offset = {10, 10}

    self.jiggled = false
    self.shoos = 0

    self.waves = {
        "basic"
    }

    self.dialogue = {
        "Swip\nSwap~",
        "Gwob\nGwub~",
        "Awoooo~",
        "Wiggle\nWoggle~"
    }

    self.low_health_dialogue = {
        "Bwaa~",
        "Grrr~"
    }

    self.spareable_dialogue = "heHe~"

    self.check = "ATK "..self.attack.." DEF "..self.defense.."\n* Looking for some fun."
    self.check_low_health = "ATK "..self.attack.." DEF "..self.defense.."\n* Wondering."

    self.text = {
        "* Dunebud shifts this way and\nthat.",
        "* Dunebud is getting antsy.",
        "* Dunebud begins to gargle a song.",
        "* Smells like sandpaper."
    }

    self.spareable_text = "* Dunebud is giggling."
    self.low_health_text = {
        "* Dunebud is dazed.",
        "* Sand is spilling everywhere."
    }

    self.low_health = false

    self:registerAct("Pat")
    self:registerAct("Jiggle")
    self:registerAct("Shoo")
    self:registerMarcyAct("Build")

    --self.gauge_size = {250, 20}

    self.damage_offset = {0, 80}
end

function Dunebud:getDamageVoice()
    return "hurtsmall"
end

function Dunebud:onAct(battler, name)
    if name == "Check" then
        if self.low_health then
            return "* DUNEBUD -- "..self.check_low_health
        else
            return "* DUNEBUD -- "..self.check
        end
    elseif name == "Pat" then
        if self.low_health then
            return "* You attempt to pat Dunebud.\n* They slink away."
        else
            if self.jiggled then
                self:addMercy(50)
                return "* You give Dunebud a few loving\npats.\n* They nuzzle your hand."
            else
                self.dialogue_override = "Oo??"
                return "* You cautiously pat the top of\nDunebud.\n* They seem confused."
            end
        end
    elseif name == "Jiggle" then
        if self.low_health then
            return "* You reach out to Dunebud but\nthey back up."
        else
            if not self.jiggled then
                self:addMercy(50)
            end
            self.jiggled = true
            self.dialogue_override = "Awawa~"
            return "* You shake Dunebud back and\nforth.\n* They giggle at you."
        end
    elseif name == "Build" then
        self:addMercy(100)
        self.jiggled = true
        return "* Marcy shapes Dunebud into a sandcastle.\n* They feel strong."
    elseif name == "Shoo" then
        if self.low_health then
            return "* You take a step at Dunebud to\nintimidate them.\n* They flinch a little."
        else
            self.dialogue_override = "Uuuu~"
            if self.shoos >= 1 then
                return "* You make an angry face at Dunebud.\n* They get scared."
            else
                self.shoos = self.shoos + 1
                return "* You wave your hand dismissively\nat Dunebud.\n* They don't understand."
            end
        end
    elseif name == "Standard" then
        if self.low_health then
            if battler.chara.id == "jamm" and Game:getFlag("marcy_joined") then
				return "* Jamm and Marcy attempt to pat Dunebud.\n* They slink away."
			end
            return "* "..battler.chara:getName().." attempts to pat Dunebud.\n* They slink away."
        else
            self.dialogue_override = "Oo??"
			if battler.chara.id == "jamm" and Game:getFlag("marcy_joined") then
				return "* Jamm and Marcy cautiously pat the top of Dunebud.\n* They seem confused."
			end
            return "* "..battler.chara:getName().." cautiously pat the top of\nDunebud.\n* They seem confused."
        end
    end

    return super.onAct(self, battler, name)
end

function Dunebud:onDefeat(damage, battler)
    super.onDefeat(self, damage, battler)
    Game.battle.encounter.dunebud_kill_reaction = true
    Game.battle.encounter.kill_count = Game.battle.encounter.kill_count + 1

    Game:setFlag("dunes_kills", Game:getFlag("dunes_kills") + 1)
    if Game:getFlag("dunes_kills") == 20 then
        Game:setFlag("EMPTIED_DUNES", true)
        MUSIC_PITCHES["vigorous_terrain"] = 0.25
        MUSIC_PITCHES["steamworks_overworld"] = 0.5
    elseif Game:getFlag("dunes_kills") > 13 and Game:getFlag("dunes_kills") < 20 and #Game.battle:getActiveEnemies() > 0 then
        Game.battle.timer:after(1, function()
            local enemies_left = 20 - Game:getFlag("dunes_kills")
            local mus_pitch = 1
            if enemies_left > 0 then
                mus_pitch = (enemies_left / 7)
            end
            Game.battle.music:setPitch(mus_pitch)
        end)
    elseif Game:getFlag("dunes_kills") == 13 and #Game.battle:getActiveEnemies() > 0 then
        Game.battle.music:stop()
        Game.battle.timer:after(1, function()
            Game.battle.music:play("genobattle_yellow")
        end)
    end
end

function Dunebud:getEncounterText()
    local has_spareable_text = self.spareable_text and self:canSpare()

    if Game.battle.encounter.dunebud_kill_reaction then
        Game.battle.encounter.dunebud_kill_reaction = false
        return "* The remaining Dunebud glances\naround, looking for their\npartner."

    elseif self.low_health_text and self.health <= (self.max_health * self.low_health_percentage) then
        return Utils.pick(self.low_health_text)

    elseif self.tired_text and self.tired then
        return self.tired_text

    elseif has_spareable_text then
        return self.spareable_text
    end

    return Utils.pick(self.text)
end

function Dunebud:getEnemyDialogue()
    if Game.battle.encounter.dunebud_kill_reaction then
        return "?~"
    end
    if not self.low_health and self:canSpare() then
        return self.spareable_dialogue
    end
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

function Dunebud:onHurtEnd()
    self:getActiveSprite():stopShake()
    if self.health > 0 or not self.exit_on_defeat then
        self:toggleOverlay(false, true)
    end
    if not self.low_health and self.health <= (self.max_health * self.low_health_percentage) then
        self.low_health = true
        self:setActor("dunebud_b_hurt")
    end
end

return Dunebud
local Starlo, super = Class(LightEnemyBattler)

function Starlo:init()
    super.init(self)

    self.name = "North Star"
    self:setActor("starlo_b")
    self:setScale(1)

    self.max_health = 600
    self.health = 600
    self.attack = 14
    self.defense = 12
    self.money = 50
    self.experience = 500
    self.spare_percentage = 0

    self.phase = 1
    self.attack_cycle = 0

    self.dialogue_bubble = "ut_wide"
    self.dialogue_offset = {20, -30}

    self.waves = {
        "starlo/take_aim"
    }

    self.check = "ATK "..self.attack.." DEF "..self.defense.."\n* The almighty Sheriff."

    self.text = {
        "* He keeps two steady eyes\non you.",
        "* His fingers itch for his\nsix-shooter.",
        "* Smells like leather boots and\nbroken dreams.",
        "* A tension in the air grows."
    }

    self:registerAct("Focus")

    self.large_dust = true

    self.gauge_size = {250, 18}

    self.damage_offset = {0, 30}
end

function Starlo:onDefeat(damage, battler)
    self.hurt_timer = -1
    if Game.battle.battle_ui.attacking then
        Game.battle.battle_ui:endAttack()
    end
    Game.battle:setState("NONE")
    Game.battle:startCutscene("starlo", "death")
end

function Starlo:onAct(battler, name)
    if name == "Check" then
        return "* NORTH STAR -- "..self.check
    elseif name == "Focus" then
        return "* You take a deep breath to\nprepare for the next attack."
    elseif name == "Standard" then
		if battler.chara.id == "jamm" and Game:getFlag("marcy_joined") then
			return "* But there was nothing Jamm and Marcy could do."
		end
        return "* But there was nothing "..battler.chara:getName().."\ncould do."
    end

    return super.onAct(self, battler, name)
end

function Starlo:onHurt(damage, battler)
    self.hurt_timer = 1
    if battler then
        Game:giveTension(MathUtils.round(self:getAttackTension(battler.tp_gain or 0)))
        battler.tp_gain = 0
    end
    self.actor.do_body_stretch = false
    self:getSpritePart("head"):setSprite("battle/lightenemies/starlo/head_hurt")

    if self.can_shake then
        self:getActiveSprite():shake(6, 0, 0.4, 2 / 30)
    end

    if self.health <= (self.max_health * self.tired_percentage) then
        -- If `tired_percentage` is set to 0 (or less?), treat that as an indication to hide the message.
        self:setTired(true, self.tired_percentage <= 0)
    end

    if self.health <= (self.max_health * self.spare_percentage) then
        self.mercy = 100
    end
end

function Starlo:onHurtEnd()
    if self.can_shake then
        self:getActiveSprite():stopShake()
    end
    if self.health > 0 or not self.exit_on_defeat then
        self.actor.do_body_stretch = true
        self:getSpritePart("head"):setSprite("battle/lightenemies/starlo/head")
    end
end

--[[function Starlo:getNextWaves()
    if self.attack_cycle == 0 then
        self.attack_cycle = 1
        return {"Starlo/flower_shooter"} -- Opening Attack
    elseif self.health <= 500 and self.phase == 1 then
        if self.attack_cycle == 9 then
            self.attack_cycle = 1
        else
            self.attack_cycle = self.attack_cycle + 1
        end
        return {"Starlo/flower_spiral"} -- Phase Switch Attack
    elseif self.attack_cycle == 1 then
        self.attack_cycle = 2
        return {"Starlo/flower_shooter"} -- Attack 1
    elseif self.attack_cycle == 2 then
        self.attack_cycle = 3
        return {"Starlo/flower_spiral"} -- Attack 2
    elseif self.attack_cycle == 3 then
        self.attack_cycle = 4
        return {"Starlo/flower_shooter"} -- Attack 3
    elseif self.attack_cycle == 4 then
        self.attack_cycle = 5
        return {"Starlo/flower_spiral"} -- Attack 4
    elseif self.attack_cycle == 5 then
        self.attack_cycle = 6
        return {"Starlo/flower_shooter"} -- Attack 5
    elseif self.attack_cycle == 6 then
        self.attack_cycle = 7
        return {"Starlo/flower_spiral"} -- Attack 6
    elseif self.attack_cycle == 7 then
        self.attack_cycle = 8
        return {"Starlo/flower_shooter"} -- Attack 7
    elseif self.attack_cycle == 8 then
        self.attack_cycle = 9
        return {"Starlo/flower_spiral"} -- Attack 8
    elseif self.attack_cycle == 9 then
        self.attack_cycle = 1
        return {"Starlo/flower_shooter"} -- Attack 9
    end
    return super.getNextWaves(self)
end]]

function Starlo:update()
    super.update(self)
    local head = self:getSpritePart("head")
    if self.emotion ~= self.last_emotion then
        self.last_emotion = self.emotion
        if self.emotion == "covered" then
            head:setSprite("battle/lightenemies/starlo/head_covered")
        elseif self.emotion == "crying" then
            head:setSprite("battle/lightenemies/starlo/head_crying")
        elseif self.emotion == "hurt" then
            head:setSprite("battle/lightenemies/starlo/head_hurt")
        elseif self.emotion == "normal" then
            head:setSprite("battle/lightenemies/starlo/head")
        end
    end
    if self.bubble and self.bubble:isTyping() then
        if self.predead then
            if not self.overlay_sprite.playing then
                self.overlay_sprite:play(4/30, true)
            end
        else
            if not head.playing then
                head:play(4/30, true)
            end
        end
    elseif head.playing or self.overlay_sprite.playing then
        if self.predead then
            self.overlay_sprite:stop()
        else
            head:stop()
        end
    end
end

return Starlo
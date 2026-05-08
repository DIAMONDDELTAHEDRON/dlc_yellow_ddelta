local Ceroba, super = Class(LightEnemyBattler)

function Ceroba:init()
    super.init(self)

    self.name = "Ceroba"
    self:setActor("cerobaboss")
    self.color = {215/255, 166/255, 166/255}

    self.max_health = 1000
    self.health = 1000
    self.attack = 13
    self.defense = 21
    self.money = 50
    self.experience = 800
    self.spare_percentage = 0

    self.service_mercy = 0
    self.boss = true

    self.phase = 1
    self.attack_cycle = 0
    self.low_health = false

    self.dialogue_bubble = "uty_largest"
    self.dialogue_offset = {-40, 20}

    self.waves = {
        "ceroba/flower_shooter",
        "ceroba/flower_spiral"
    }

    self.check = "ATK "..self.attack.." DEF "..self.defense.."\n* Nothing left."

    self.text = {
        "* There is no hope.",
        "* She wipes sweat from\nher brow.",
        "* The petals swirl around you.",
        "* She stares into your SOUL.",
        "* The fight rages.",
        --"* The atmosphere chills with\nire.",
        --"* No mercy."
    }

    --self.low_health_text = "* The dummy looks like it's\nabout to fall over."

    self:registerAct("Resist")
    self:registerAct("Calm")
    self:registerAct("Mock")

    self.large_dust = true

    self.gauge_size = {250, 18}

    self.damage_offset = {0, 30}
end

function Ceroba:onDefeat(damage, battler)
    self.hurt_timer = -1
    if Game.battle.battle_ui.attacking then
        Game.battle.battle_ui:endAttack()
    end
    Game.battle:setState("NONE")
    Game.battle:startCutscene("ceroba_geno", "death_fake")
end

function Ceroba:onAct(battler, name)
    if name == "Check" then
        return "* CEROBA -- "..self.check
    elseif name == "Resist" then
        return "* You hold your ground against\nthe magic."
    elseif name == "Calm" then
        return "* You take a moment to breathe,\npreparing for what's to come."
    elseif name == "Mock" then
        return "* You attempt to belittle your\nopponent but she's in another\nworld."
    elseif name == "Standard" then
		if battler.chara.id == "jamm" and Game:getFlag("marcy_joined") then
			return "* But there was nothing Jamm and Marcy could do."
		end
        return "* But there was nothing "..battler.chara:getName().."\ncould do."
    end

    return super.onAct(self, battler, name)
end

function Ceroba:onHurtEnd()
    self:getActiveSprite():stopShake()
    if self.health > 0 or not self.exit_on_defeat then
        self:toggleOverlay(false, true)
    end
    if not self.low_health and self.health <= 250 and self.health > 0 then
        self.low_health = true
        self.tired = true
        self:setActor("cerobaboss_p2_hurt")
    end
end

function Ceroba:spare(pacify)
    if pacify then
        self.done_state = nil
        self.pacified = true
        self:toggleOverlay(true)
        self:getActiveSprite():setSprite("animations/death_1")
        Game.battle:startCutscene("ceroba_geno", "pacify")
    end
end

function Ceroba:getNextWaves()
    if self.final_attack then
        return {"ceroba/finale"} -- Final Attack
    elseif self.attack_cycle == 0 then
        self.attack_cycle = 1
        return {"ceroba/intro_attack"} -- Opening Attack
    elseif self.switch_attack then
        self.switch_attack = false
        if self.attack_cycle == 9 then
            self.attack_cycle = 1
        else
            self.attack_cycle = self.attack_cycle + 1
        end
        return {"ceroba/flower_spiral"} -- Phase Switch Attack
    elseif self.attack_cycle == 1 then
        self.attack_cycle = 2
        return {"ceroba/flower_shooter"} -- Attack 1
    elseif self.attack_cycle == 2 then
        self.attack_cycle = 3
        return {"ceroba/beams"} -- Attack 2
    elseif self.attack_cycle == 3 then
        self.attack_cycle = 4
        return {"ceroba/black_hole"} -- Attack 3
    elseif self.attack_cycle == 4 then
        self.attack_cycle = 5
        return {"ceroba/flower_slider"} -- Attack 4
    elseif self.attack_cycle == 5 then
        self.attack_cycle = 6
        return {"ceroba/movingarena"} -- Attack 5
    elseif self.attack_cycle == 6 then
        self.attack_cycle = 7
        return {"ceroba/flower_spiral"} -- Attack 6
    elseif self.attack_cycle == 7 then
        self.attack_cycle = 8
        return {"ceroba/flower_shooter"} -- Attack 7
    elseif self.attack_cycle == 8 then
        self.attack_cycle = 9
        return {"ceroba/flower_spiral"} -- Attack 8
    elseif self.attack_cycle == 9 then
        self.attack_cycle = 1
        return {"ceroba/pillars"} -- Attack 9
    end
    return super.getNextWaves(self)
end

return Ceroba
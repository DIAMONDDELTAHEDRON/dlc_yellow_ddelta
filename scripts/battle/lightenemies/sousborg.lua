local Sousborg, super = Class(LightEnemyBattler)

function Sousborg:init()
    super.init(self)

    self.name = "Sousborg"
    self:setActor("sousborg_b")

    self.max_health = 180
    self.health = 180
    self.attack = 12
    self.defense = 12
    self.money = 30
    self.experience = 0

    self.dialogue_bubble = "uty_large"
    self.dialogue_offset = {-70, 10}

    self.waves = {
        "basic"
    }

    self.dialogue = {
        "If you can't\nstand ze heat...\ngood!",
        "Natural\ningredients!\nNever\nsubstitute!",
        "A bit of zis...\na bit of zat...",
        "C'est croquant,\nc'est fondant...",
        "Réjouis-toi!\nI am only going\nto bring you to a\nlight boil!",
        "Longue vie au\nroi, courte vie\nà l'humain!",
        "Your complexion...\nun poulet cru.\nSome food will\nhelp!"
    }

    self.low_health_dialogue = {
        "D../inner _:wiLl\nbe <r-Ready .>\nSoon.",
        "Sw/>.eet _or\nSAVory?"
    }

    self.check = "ATK "..self.attack.." DEF "..self.defense.."\n* A recipe for disaster."

    self.text = {
        "* Looks like you're on the\nchopping block!",
        "* Sousborg is juggling cleavers.",
        "* Sousborg cooks you some\nspaghetti![wait:5] ...without water.",
        "* Smells like...[wait:5] food?[wait:5] Nice!",
        "* Sousborg preheats his next\nattack.",
        "* Sousborg stares down a frozen\nTV dinner with great malice."
    }

    self.spareable_text = "* Sousborg bows to your culinary\nmastery!"
    self.low_health_text = {
        "* Sousborg pours onion powder on\nhis wounds.",
        "* Sousborg is leaking oil.\nVegetable oil."
    }

    self.low_health = false
    self.sparing_stage = 1

    self:registerAct("Crack")
    self:registerAct("Criticize")

    --self:registerAct("Boil")
    --self:registerAct("Fry")
    --self:registerAct("Bake")

    --self:registerAct("Refrigerate")
    --self:registerAct("Pet")
    --self:registerAct("Season")

    --self.gauge_size = {250, 20}

    self.damage_offset = {0, 80}
end

function Sousborg:onAct(battler, name)
    if name == "Check" then
        return "* SOUSBORG -- "..self.check
    elseif name == "Crack" then
        if self.low_health then
            return "* You toss Sousborg's cooking\ninto the garbage."
        else
            self.dialogue_override = "Ah yes![wait:5] Just a\nlight tap on ze\nedge!"
            self:addMercy(35)
            self.sparing_stage = 2
            self:removeAct("Crack")
            self:removeAct("Criticize")
            self:registerAct("Boil")
            self:registerAct("Fry")
            self:registerAct("Bake")
            return "* You tell Sousborg to take the\negg and crack it over a pan."
        end
    elseif name == "Criticize" then
        if self.low_health then
            return "* You wash Sousborg's oil off of\nyour hands."
        else
            local rnd = math.random(1, 2)
            if rnd == 1 then
                self.dialogue_override = "Underground?[wait:5]\nUndercooked![wait:5]\nWhat ez ze issue?"
            else
                self.dialogue_override = "Quelle\nimpolitesse!"
            end
            return "* You accuse Sousborg of\nundercooking his food."
        end
    elseif name == "Boil" then
        local rnd = math.random(1, 2)
        if rnd == 1 then
            self.dialogue_override = "Water?[wait:5] Pah![wait:5]\nI cannot touch such\na zing!"
        else
            self.dialogue_override = "No![wait:5] Ze egg ez\nalready out of\nits casing!"
        end
        return "* You tell Sousborg to fill the\npan with water and turn up the\nheat."
    elseif name == "Fry" then
        self.dialogue_override = "Oui![wait:5] Turn up\nze heat!"
        self:addMercy(35)
        self.sparing_stage = 3
        self:removeAct("Boil")
        self:removeAct("Fry")
        self:removeAct("Bake")
        self:registerAct("Refrigerate")
        self:registerAct("Pet")
        self:registerAct("Season")
        return "* You tell Sousborg to heat the\nstove until the egg begins to\nsizzle."
    elseif name == "Bake" then
        local rnd = math.random(1, 2)
        if rnd == 1 then
            self.dialogue_override = "What ez going on\ninside your tiny\nhead?[wait:5] Non!"
        else
            self.dialogue_override = "We are not making\npie![wait:5] Get it\ntogezer!"
        end
        return "* You tell Sousborg to throw that\npuppy into the oven!"
    elseif name == "Refrigerate" then
        local rnd = math.random(1, 2)
        if rnd == 1 then
            self.dialogue_override = "Ze meal ez not\neven done and\nyou want\nleftovers?"
        else
            self.dialogue_override = "Hopeless![wait:5]\nUnprofessional!"
        end
        return "* You tell Sousborg to wrap the\negg in plastic and let it chill\nout."
    elseif name == "Pet" then
        local rnd = math.random(1, 2)
        if rnd == 1 then
            self.dialogue_override = "It accomplished\ngiving me joy...[wait:5]\nbut I cannot eat\njoy!"
        else
            self.dialogue_override = "Ze egg is not\nalive![wait:5] Well...[wait:5]\nnot anymore :/"
        end
        return "* You tell Sousborg to pet the\negg.[wait:5] He does.[wait:5] This accomplished\nnothing."
    elseif name == "Season" then
        self.dialogue_override = "Of course!\nI must sow ze\nseeds of flavour!"
        self:addMercy(35)
        self.sparing_stage = 4
        self:removeAct("Refrigerate")
        self:removeAct("Pet")
        self:removeAct("Season")
        return "* You tell Sousborg to grab some\npepper and sprinkle it over the\negg."
    elseif name == "Standard" then
        if self.low_health then
            return "* "..battler.chara:getName().." washes Sousborg's oil off of\ntheir hands."
        else
			if battler.chara.id == "susie" then
                if not self.susie_acted then
                    Game.battle:startActCutscene(function(cutscene)
                        cutscene:text("* Oh man,[wait:5] a cooking robot?", "surprise_smile", "susie")
                        cutscene:text("* Nice,[wait:5] I'd like to try some of that food he makes.", "smile", "susie")
                        cutscene:text("* I hope it has some...[wait:5] Chalk,[wait:5] or moss...", "smirk", "susie")
                        cutscene:battlerText(self, "What are you saying![wait:5] Such ingredients don't belong on ze kitchen!")
                        cutscene:text("* [speed:0.1]...[speed:1]nevermind.", "annoyed", "susie")
                    end)
                    self.susie_acted = true
			    	return
                else
                    return "* Susie doesn't want Sousborg's cooking."
                end
            elseif battler.chara.id == "noelle" then
                if not self.noelle_acted then
                    Game.battle:startActCutscene(function(cutscene)
                        cutscene:text("* Uhh,[wait:5] I'm not really a good cook...", "what_smile", "noelle")
                        cutscene:text("* But I can always try to help-[wait:5]", "smile_closed", "noelle", {auto=true})
                        cutscene:battlerText(self, "No![wait:5] If you can't cook,[wait:5] don't stand near ze stove!")
                        cutscene:text("* Oh.", "what_smile", "noelle")
                    end)
                    self.noelle_acted = true
			    	return
                else
                    return "* Noelle already tried to offer her help."
                end
            elseif battler.chara.id == "dess" then
                if not self.dess_acted then
                    Game.battle:startActCutscene(function(cutscene)
                        cutscene:text("* Oh,[wait:5] oh,[wait:5] chef bot!", "eurika", "dess")
                        cutscene:text("* Cook me some nuts.", "smug", "dess")
                        cutscene:battlerText(self, "Nuts?")
                        cutscene:text("* DEEZ NUTS.", "swag", "dess")
                        cutscene:battlerText(self, "[speed:0.1].....")
                    end)
                    self.dess_acted = true
                    return
                else
                    Game.battle:startActCutscene(function(cutscene)
                        cutscene:text("* Nah,[wait:5] even robots are not stupid enough to fall for that twice.", "neutral_b", "dess")
                    end)
                    return
                end
			elseif battler.chara.id == "jamm" and Game:getFlag("marcy_joined") then
                self.dialogue_override = "No![wait:5] You doing it all wrong!"
				return "* Jamm and Marcy try to help Sousborg\nwith cooking.[wait:5] They fail."
            else
                self.dialogue_override = "No![wait:5] You doing it all wrong!"
                return "* "..battler.chara:getName().." tries to help Sousborg\nwith cooking.[wait:5] They fail."
            end
        end
    end

    return super.onAct(self, battler, name)
end

function Sousborg:onDefeat(damage, battler)
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
    end

    Game.battle.timer:after(0.8, function()
        self.alpha = 0
        Assets.playSound("ut_explosion")
        local explosion = Sprite("battle/lightenemies/robot_destroy_explosion")
        explosion:setPosition(self:getRelativePos(self.width / 2, self.height / 2))
        explosion.layer = LIGHT_BATTLE_LAYERS["above_battlers"]
        explosion:setOrigin(0.5, 0.5)
        explosion:setScale(2, 2)
        Game.battle:addChild(explosion)
        Game.battle.timer:after(1, function()
            explosion:fadeOutAndRemove(1)
        end)
        self:explodeParts()
    end)
end

function Sousborg:explodeParts()
    local function makeSprite(spritepath, x, y)
        local sprite = Sprite(spritepath)
        sprite:setPosition(x or self.x, y or self.y)
        sprite.layer = LIGHT_BATTLE_LAYERS["above_battlers"] + 1
        sprite:setOrigin(0.5, 0.5)
        sprite:setScale(2, 2)
        Game.battle:addChild(sprite)
        sprite.physics.direction = math.rad(Utils.random(360))
        sprite.physics.speed = 7
        sprite.physics.gravity = 0.2
    end
    local relative_pos_x, relative_pos_y = self:getRelativePos(self.width / 2, self.height / 2)
    local path = "battle/lightenemies/sousborg/explosion_parts/"
    makeSprite(path.."body_bottom", relative_pos_x, relative_pos_y)
    makeSprite(path.."body_top", relative_pos_x, relative_pos_y)
    makeSprite(path.."cleaver", relative_pos_x, relative_pos_y)
    makeSprite(path.."glass", relative_pos_x, relative_pos_y)
    makeSprite(path.."hand", relative_pos_x, relative_pos_y)
    makeSprite(path.."hat", relative_pos_x, relative_pos_y)
    makeSprite(path.."head", relative_pos_x, relative_pos_y)
    makeSprite(path.."left_arm_1", relative_pos_x, relative_pos_y)
    makeSprite(path.."left_arm_2", relative_pos_x, relative_pos_y)
    makeSprite(path.."plate_1", relative_pos_x, relative_pos_y)
    makeSprite(path.."plate_2", relative_pos_x, relative_pos_y)
    makeSprite(path.."salt", relative_pos_x, relative_pos_y)
    makeSprite(path.."shard_1", relative_pos_x, relative_pos_y)
    makeSprite(path.."shard_2", relative_pos_x, relative_pos_y)
    makeSprite(path.."shard_3", relative_pos_x, relative_pos_y)
    makeSprite(path.."spoon", relative_pos_x, relative_pos_y)
end

function Sousborg:getEncounterText()
    local has_spareable_text = self.spareable_text and self:canSpare()

    if self.low_health_text and self.health <= (self.max_health * self.low_health_percentage) then
        return Utils.pick(self.low_health_text)

    elseif has_spareable_text then
        return self.spareable_text
    end

    return Utils.pick(self.text)
end

function Sousborg:getEnemyDialogue()
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

function Sousborg:onHurtEnd()
    self:getActiveSprite():stopShake()
    if self.health > 0 or not self.exit_on_defeat then
        self:toggleOverlay(false, true)
    end
    if not self.low_health and self.health <= (self.max_health * self.low_health_percentage) then
        if self.sparing_stage == 2 then
            self.sparing_stage = 0
            self:removeAct("Boil")
            self:removeAct("Fry")
            self:removeAct("Bake")
        elseif self.sparing_stage == 3 then
            self.sparing_stage = 0
            self:removeAct("Refrigerate")
            self:removeAct("Pet")
            self:removeAct("Season")
        end
        self.low_health = true
        self:setActor("sousborg_b_hurt")
    end
end

function Sousborg:onHurt(damage, battler)
    super.onHurt(self, damage, battler)
    Assets.stopAndPlaySound("hurt_robot"):setPitch(0.5)
end

return Sousborg
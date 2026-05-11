return {
    intro = function(cutscene, battler, enemy)
        local starlo = Game.battle:getEnemyBattler("starlo")
        cutscene:wait(1)
        starlo.emotion = "normal"
        cutscene:wait(1)
        local dialogue = {
            "Never thought I'd\nhave to do this ever\nagain.",
            "But it seems I was\nwrong.",
            "Well,[wait:5] enough talking.[wait:10]\nLet's get this over\nwith."
        }
        cutscene:battlerText(starlo, dialogue)
        starlo.emotion = "covered"

        Game.battle:setState("DEFENDINGEND")
        cutscene:wait(0.5)
        cutscene:after(function()
            Game.battle.encounter.background = true
            Game.battle.encounter.bg_state = 1
            Game.battle.seen_encounter_text = false
            Game.battle:setState("ACTIONSELECT")
        end, true)
    end,
    death = function(cutscene, battler, enemy)
        Game.battle.music:stop()
        local starlo = Game.battle:getEnemyBattler("starlo")
        starlo:toggleOverlay(true)
        starlo:getActiveSprite():setSprite("body_dead")
        starlo.predead = true
        cutscene:wait(1)
        local speech = {
            "Ah...",
            "Guess I had\nthis coming.",
            "If only I wore\nmy safety goggles,\nheh...",
            "...",
            "I...",
            "I can't lie...",
            "I'm not ready...",
            "...",
            "Let my parents\nknow...",
            "...I'll be away for\na while.",
            "See you around,\nkid."
        }
        cutscene:battlerText(starlo, speech)

        starlo:onDefeatVaporized(damage, battler)
        cutscene:after(function()
            Game.battle:setState("VICTORY")
        end, true)
    end,
    battle_outro = function(cutscene, battler, enemy)
        local starlo = Game.battle:getEnemyBattler("starlo")
        local body_sprite = starlo:getSpritePart("body")

        starlo.emotion = "covered"
        cutscene:battlerText(starlo, {"...", "One...", "I have one left\nin my\nchamber..."})
        starlo.emotion = "normal"

        body_sprite:setAnimation({"npcs/starlo/lightbattle/shoot_outro", 1/8, false})
        body_sprite:setPosition(body_sprite.x + 10, body_sprite.y)
        cutscene:wait(2)

        starlo.emotion = "crying"
        cutscene:battlerText(starlo, "I'll make this count.")
    end
}
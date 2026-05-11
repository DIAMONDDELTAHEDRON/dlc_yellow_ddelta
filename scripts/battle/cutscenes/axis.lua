return {
    floweysave = function(cutscene, battler, enemy)
        local axis = Game.battle:getEnemyBattler("axis")
        cutscene:wait(1)
        Assets.playSound("spearappear")
        axis:setAnimation("charge")
        local bigredball = Sprite("battle/bullets/axis/ball_red")
        bigredball:setPosition(318, 42)
        bigredball.layer = LIGHT_BATTLE_LAYERS["above_arena_border"]
        bigredball:setOrigin(0.5, 0.5)
        bigredball:setScale(2, 2)
        Game.battle:addChild(bigredball)
        cutscene:wait(2)
        axis:setAnimation("charge_release")
        bigredball:slideTo(Game.battle.soul.x, Game.battle.soul.y-50, 0.5)
        local pellet = Sprite("battle/bullets/flowey/spinbullet_outline")
        pellet:play(1/10, true)
        pellet:setPosition(Game.battle.soul.x, 450)
        pellet.layer = Game.battle.soul.layer + 1
        pellet:setOrigin(0.5, 0.5)
        pellet:setScale(2, 2)
        Game.battle:addChild(pellet)
        pellet:slideTo(Game.battle.soul.x, Game.battle.soul.y-50, 0.5)
        cutscene:wait(0.5)
        pellet:remove()
        bigredball:slideTo(axis.x, axis.y-120, 0.3)
        Assets.playSound("damage")
        cutscene:wait(0.3)
        bigredball:remove()
        Assets.playSound("axis_energy_ball_explode")
        local explosion = Sprite("battle/bullets/ceroba/explosion")
        explosion:setPosition(axis.x, axis.y-120)
        explosion.layer = LIGHT_BATTLE_LAYERS["above_arena_border"]
        explosion:setOrigin(0.5, 0.5)
        Game.battle:addChild(explosion)
        explosion:play(1/12, false, function(this) this:remove() end)
        axis:setAnimation("hurt")
        axis:shake(6, 0, 0.2)
        cutscene:wait(0.5)
        axis:setAnimation("idle_body")

        Game.battle.encounter:addEnemy("flowey", 140, 240)
        local flowey = Game.battle:getEnemyBattler("flowey")
        flowey.animation_state=true
        flowey:setAnimation("riseanim")
        cutscene:wait(1)
        flowey.animation_state=false
        cutscene:battlerText(flowey, "Howdy there!")
        flowey:setSprite("smirk")
        cutscene:battlerText(flowey, "Gee,[wait:5] I leave for\n5 seconds and\nyou're already\nin danger?")
        cutscene:wait(1)
        cutscene:battlerText(axis, "WHAT.[wait:5] WHO ARE\nYOU?")
        flowey:setSprite("niceside")
        cutscene:battlerText(flowey, "Oh,[wait:5] yeah,[wait:5] I'm Flowey.")
        flowey:setSprite("wink")
        cutscene:battlerText(flowey, "Nice to meet ya.")
        flowey:setSprite("worried")
        cutscene:battlerText(flowey, "Anyways,[wait:5] it just seemed like you were in danger.")
        flowey:setSprite("niceside")
        cutscene:battlerText(flowey, "So hey,[wait:5] I got\nyou a little\ngift to protect yourself.")
        flowey:setSprite("nice")
        cutscene:battlerText(flowey, "Catch!")
        flowey:setSprite("niceside")
        Assets.playSound("swoosh")
        local lid = Sprite("battle/lightenemies/axis/lid")
        lid:setPosition(320, -50)
        lid.layer = Game.battle.soul.layer + 1
        lid:setOrigin(0.5, 0.5)
        lid:setScale(2, 2)
        Game.battle:addChild(lid)
        lid:slideTo(lid.x, 530, 1)
        cutscene:wait(1)
        Assets.playSound("grab")
        cutscene:wait(0.5)
        lid:remove()
        flowey:setSprite("nice")
        cutscene:battlerText(flowey, "Good one!")
        cutscene:battlerText(flowey, "Now go get him!")
        flowey.animation_state=true
        flowey:setAnimation("sinkanim")
        cutscene:wait(1)
        flowey:defeat("SPARED", false)
        flowey:remove()
        Game.battle:setState("DEFENDINGEND")
        cutscene:wait(0.5)
        cutscene:after(function()
			Game.battle.music:play(Game.battle.encounter.music)
            Game.battle.seen_encounter_text = false
            Game.battle:setState("ACTIONSELECT")
        end, true)
    end,
    death = function(cutscene, battler, enemy)
        Game.battle.music:stop()
        local axis = Game.battle:getEnemyBattler("axis")
        axis:getActiveSprite():setSprite("nocharge")
        cutscene:wait(1)
        --axis:toggleOverlay(false)
        local speech = {
            "BzZT-Z// z. ._ .",
            ". . . W-wW-",
            "-WHA_T HAS H/APPENeD\nTO M..E?",
            "[color:FF00FF]D-D-DAMAGE CRITICAL_",
            "[color:FF00FF]Se-EK R/ePAI'RS IM\nEDIATELY_",
            "I S_EE .  . .",
            "[color:FF00FF]CALLInG MR. ChUJIN_",
            "CREaTOR. .. ?",
            "[color:FF00FF]CALLInG MR. ChUJIN_",
            "CRE_TO R, I NEED\nASSIST//ANCE_",
            "[color:FF00FF]CALLInG MR. Ch , . _",
            "[color:FF00FF]/CrEAt.. ,..",
            "[color:FF00FF]CAL-L , , i n g _",
            "CRe. ...",
            ".",
            "creator."
        }
        cutscene:battlerText(axis, speech)

        Assets.playSound("vaporized")
        axis:defeat("KILLED", true)
        Game:setFlag("axis_dead", true)
        cutscene:after(function()
            Game.battle:setState("VICTORY")
        end, true)
    end,
    out_of_power = function(cutscene, battler, enemy)
        local axis = Game.battle:getEnemyBattler("axis")
        cutscene:wait(0.3)
        Game.battle.music:stop()
        Assets.playSound("ut_explosion")
        cutscene:battlerText(axis, "ZzzzzBBZzzzz\nAooaaaA- _- .  .", {wait=false, auto=true, skip=false})
        cutscene:fadeOut(1, {color={1, 1, 1}})
        cutscene:wait(2.5)
        cutscene:fadeIn(0.1, {color={1, 1, 1}})
        axis:getActiveSprite():setSprite("nocharge")
        cutscene:wait(1)
        local speech = {
            "[color:FF00FF]*BEEP BEEP*",
            "[color:FF00FF]SHUTTING OFF\nSTRENUOUS\nEMOTIONS\nTO SAVE POWER.",
            "AH.",
            "WHAT DID YOU\nDO TO ME?",
            "I DON'T FEEL AN\nUTTER MURDEROUS\nRAGE ANYMORE.",
            "I... DO NOT\nKNOW WHAT TO\nDO WITH MYSELF.",
            "SUPPOSE I WILL\nSTARE AT YOU\nBLANKLY UNTIL\nYOU DO SOMETHING."
        }
        cutscene:battlerText(axis, speech)

        cutscene:after(function()
            Game.battle:setState("ACTIONSELECT")
        end, true)
    end
}
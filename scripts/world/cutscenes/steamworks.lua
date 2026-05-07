return {
    axis_meeting = function(cutscene, event)
        local axis = cutscene:getCharacter("axis")
        Assets.playSound("alert")
        axis:setAnimation("left")
        cutscene:wait(1)
        cutscene:text("* HALT.", "normal", "axis")
        cutscene:text("* STATE YOUR PURPOSE.", "normal", "axis")
        Game:setFlag("axis_met", true)
    end,
    axis_meeting_alt = function(cutscene, event)
        cutscene:text("* STOP RIGHT THERE.", nil, "axis")
        Game.world:spawnNPC("axis", 820, 320)
        local axis = cutscene:getCharacter("axis")
        axis:setAnimation("left")
        cutscene:wait(cutscene:slideTo(axis, axis.x-140, axis.y, 0.5))
        cutscene:text("* OH WAIT YOU CAN GO BEACUSE THAT CUTSCENE IS NOT DONE.", "normal", "axis")
        Game:setFlag("axis_met", true)
    end,
    axis_second_meeting = function(cutscene, event)
        local noel_data = Noel:loadNoel()

        local leader = Game.world.player
        local dess = cutscene:getCharacter("dess")
        local axis = cutscene:getCharacter("axis")
        local function openTrapdoor(x, y)
            local trapdoor = Sprite("world/maps/steamworks/small_objects/12_trapdoor", x, y)
            trapdoor:setScale(2)
            trapdoor:setOrigin(0.5, 0.5)
            trapdoor.layer = Game.world.player.layer - 0.1
            Game.world:addChild(trapdoor)
            trapdoor:play(1/15, false)
        end

        Game.world.music:stop()
        cutscene:detachFollowers()

        cutscene:walkTo(leader, event.x + event.width, event.y + event.height/2, 0.5, "left")
        for i = 2, #Game.party do
            local offset = (i - 1) * 60
            local member = Game.party[i].id
            cutscene:walkTo(cutscene:getCharacter(member), event.x + event.width + offset, event.y + event.height / 2, 0.5, "left")
        end

        cutscene:wait(1)
        cutscene:detachCamera()
        cutscene:panTo(Game.world.camera.x - 150, Game.world.camera.y)
        cutscene:wait(1.5)
		Assets.playSound("spearappear")
        axis:fadeTo(1, 0.5)
        cutscene:wait(1)
        cutscene:wait(cutscene:slideTo(axis, axis.x, leader.y, 0.2))
        cutscene:wait(0.1)
        cutscene:setAnimation(axis, "right")
        cutscene:wait(cutscene:slideTo(axis, axis.x + 100, leader.y, 0.2))
        if Game:isDessMode() then
            Game.world.music:play("enter_axis")
            cutscene:showNametag("Axis")
            cutscene:text("* FOUND YOU.", "normal", "axis")
            cutscene:showNametag("Dess")
            cutscene:text("* dang not you again.", "angry", "dess")
            cutscene:showNametag("Axis")
            cutscene:text("* YES IT IS ME AGAIN.", "normal", "axis")
            cutscene:text("* AND I SHALL PUT YOU UNDER ARREST.", "normal", "axis")
            cutscene:showNametag("Dess")
            if Game:getFlag("some_dessimation_condition") then
                cutscene:text("* yeah no ain't no way", "angry", "dess")
            else
                cutscene:text("* what did I even do bruh.", "eyebrow", "dess")
                cutscene:hideNametag()

                Game.world.music:stop()
                openTrapdoor(580, 340)
                Assets.playSound("trapdoor_open")
                cutscene:wait(1.1)
                dess:setFacing("down")
                cutscene:showNametag("Dess")
                cutscene:text("* shit", "wtf_b", "dess")
                cutscene:hideNametag()
                Game.world.camera.keep_in_bounds = false
                Assets.playSound("fall_trapdoor")

                dess.alpha = 0.75
                cutscene:slideTo(dess, dess.x, dess.y + 800, 1)
                cutscene:wait(2)
                cutscene:detachCamera()
                cutscene:slideTo(dess, dess.x, dess.y + 800, 1)
                cutscene:mapTransition("steamworks/13")
                Game:setFlag("stw_basement_trapped", true)
            end
        else
            if Game:getFlag("EMPTIED_DUNES") then
                cutscene:showNametag("Axis")
                cutscene:text("* FOUND YOU[wait:5]", "normal", "axis", {auto=true})
                cutscene:hideNametag()
                cutscene:wait(cutscene:walkTo(leader, axis.x + 40, leader.y, 0.2, "left"))
                cutscene:startLightEncounter("axis_beatup")
                axis:setSprite("redeyes/flyback")
                cutscene:wait(cutscene:slideTo(axis, 151, axis.y, 0.4))
                axis:setAnimation("redeyes_shot_slam")
                Assets.playSound("impact")
                Game.world.camera:shake(6, 2)
                cutscene:wait(4)
                axis:setAnimation("redeyes_shot_end")
                cutscene:wait(1.5)
                cutscene:showNametag("Axis")
                cutscene:text("* AH.. .", "damaged", "axis")
                cutscene:text("[color:FF00FF]* DAMAGE CRITICAL_", nil, "axis")
                cutscene:text("[color:FF00FF]* t-zzz THReAT . ..", nil, "axis")
                cutscene:text("[color:FF00FF]* thReat L-LeVEL 99;99\n9999 99_9. .", nil, "axis")
                cutscene:text("* . . .", "damaged", "axis")
                cutscene:hideNametag()
                cutscene:walkTo(leader, leader.x - 120, leader.y, 2, "left")
                if #Game.world.followers >= 1 then
                    for _,follower in ipairs(Game.world.followers) do
                        cutscene:walkTo(follower, follower.x - 200, follower.y, 2, "left")
                    end
                end
                cutscene:wait(2.5)
            else
                Game.world.music:play("enter_axis")
                cutscene:showNametag("Axis")
                if cutscene:getCharacter("susie_lw") then
                    cutscene:text("* FOUND YOU.[react:1]", "normal", "axis", {reactions={
						{"(Great. Just great.)", "mid", "bottom", "annoyed", "susie"}
					}})
                else
                    cutscene:text("* FOUND YOU.", "normal", "axis")
                end
                cutscene:text("* YOUR CRIMES ARE AS\nFOLLOWS:", "normal", "axis")
                cutscene:text("* - TRESPASSING ON\nPRIVATE PROPERTY.", "normal", "axis")
                cutscene:text("* - RESISTING ARREST.", "normal", "axis")
                if cutscene:getCharacter("kris") or cutscene:getCharacter("hero") or cutscene:getCharacter("jamm_lw") or cutscene:getCharacter("jammarcy_light") then
                    cutscene:text("* - HUMAN.", "normal", "axis")
                    if cutscene:getCharacter("jamm_lw") or cutscene:getCharacter("jammarcy_light") then
                        cutscene:showNametag("Jamm")
                        cutscene:text("* Since when is being a human a crime?", "determined", "jamm")
                        cutscene:showNametag("Axis")
                        cutscene:text("[color:FF00FF]* ACCESSING MEMORY BANK_", nil, "axis")
                        cutscene:hideNametag()
                        Assets.playSound("uty_cant_select", 2)
                        cutscene:wait(1)
                        cutscene:showNametag("Axis")
                        cutscene:text("[color:FF00FF]* MEMORY BANK BLOCKED_", nil, "axis")
                        cutscene:text("* SORRY,[wait:5] BUT I AM UNABLE TO PROVIDE THE EXACT DATE.", "normal", "axis")
                        cutscene:showNametag("Jamm")
                        cutscene:text("* That was a rethorical question.", "nervous_left", "jamm")
                        cutscene:showNametag("Axis")
                        cutscene:text("* . . .", "normal", "axis")
                        cutscene:text("* ANYWAYS.", "normal", "axis")
                    end
                end
                cutscene:showNametag("Axis")
                local opinion = cutscene:textChoicer("* HOW TO YOU PLEAD TO\nTHESE ACCUSATIONS?", {"Not guilty", "Guilty"}, "normal", "axis")
                if opinion == 1 then
                    cutscene:text("* PLAYING TOUGH ARE WE?", "normal", "axis")
                    cutscene:text("* THAT IS NO MATTER.", "normal", "axis")
                    cutscene:text("* I WILL SCAN YOUR FACE\nWITH MY LIE DETECTOR.", "normal", "axis")
                    cutscene:hideNametag()
		    		local src = Assets.playSound("elevator")
		    		src:setPitch(2)
		    		leader:addFX(AxisScanFX({1,1,1}, leader.sprite.height), "axis_scan")
		    		while leader:getFX("axis_scan"):isActive() do
		    			leader:getFX("axis_scan"):addScanProgress()
		    			Assets.playSound("spearappear")
		    		    cutscene:wait(2/30)
		    		end
		    		leader:removeFX("axis_scan")
                    cutscene:wait(0.5)
                    cutscene:showNametag("Axis")
                    if Game.party[1].id == "hero" or Game.party[1].id == "kris" then
                        cutscene:text("* INCREDIBLE.", "normal", "axis")
                        cutscene:text("* YOU HAVE THE MOST\nEMOTIONLESS FACE I HAVE\nEVER SEEN.", "normal", "axis")
                        cutscene:text("* I WILL JUST HAVE TO GO\nWITH MY NON-EXISTENT GUT\nAND SAY YOU WERE LYING.", "normal", "axis")
                    else
                        cutscene:text("* AHA.[wait:5] I SEE NERVOUSNESS IN YOUR FACE.", "normal", "axis")
						if Game.party[1].id == "jamm" then
							cutscene:text("* THAT MEANS YOU WERE LYING.[react:1]", "normal", "axis", {reactions={
								{"(Stay quiet,\nLuthane...)", 352, 61, "nervous_left", "jamm"}
							}})
						else
							cutscene:text("* THAT MEANS YOU WERE LYING.", "normal", "axis")
						end
                        cutscene:text("* OH WELL THEN.", "normal", "axis")
                    end
                elseif opinion == 2 then
                    if cutscene:getCharacter("susie_lw") then
                        cutscene:text("* REALLY?[react:1]", "normal", "axis", {reactions={
							{"(WHY'D YOU SAY THAT!?)", "mid", "bottom", "teeth", "susie"}
						}})
                    else
                        cutscene:text("* REALLY?", "normal", "axis")
                    end
                    cutscene:text("* THAT WAS EASY.", "normal", "axis")
                    cutscene:text("* YOUR CRIMES WILL BE\nREPORTED TO AN\nAUTHORITY.", "normal", "axis")
                    cutscene:text("* OH WAIT,[wait:5] THAT IS ME.", "normal", "axis")
                end
                if cutscene:getCharacter("kris") or cutscene:getCharacter("hero") or cutscene:getCharacter("jamm_lw") or cutscene:getCharacter("jammarcy_light") then
                    cutscene:text("* ENJOY YOUR ISOLATION,[wait:5]\nHUMAN.", "normal", "axis")
                else
                    cutscene:text("* ENJOY YOUR ISOLATION.", "normal", "axis")
                end
                cutscene:hideNametag()

                local noel_not_fall
                if noel_data and noel_data.steamworks and noel_data.steamworks.fallen == 1 then
                    local can_go = true
                    for i = 1, #Game.party do
                        if Game.party[i].id == "noel" then
                            if Game.party[i+1] then
                                can_go = false
                            end
                        end
                    end
                    if can_go == true then
                        cutscene:wait(cutscene:walkTo(cutscene:getCharacter("noel"), event.x + event.width + 120, event.y + event.height / 2, 0.5, "left"))
                        noel_not_fall = true
                    end
                end

                Game.world.music:stop()
                openTrapdoor(590, 340)
                if #Game.party > 2 then
                    openTrapdoor(712, 340)
                end
                Assets.playSound("trapdoor_open")
                cutscene:wait(1.1)

                for _,member in ipairs(Game.party) do
                    local chara = Game.world:getCharacter(member.id)
                    if chara then
                        if member.id == "noel" and noel_not_fall == true then
                        else
                            chara.sprite:setFacing("down")
                        end
                    end
                end

                cutscene:wait(0.1)
                cutscene:attachCamera()
                cutscene:wait(1)

                local noel_umbrella
                if cutscene:getCharacter("noel") then
                    if noel_data and not noel_not_fall == true then
                        if noel_data.steamworks and noel_data.steamworks.fallen == 1 then
                            Assets.playSound("wing")
                            cutscene:getCharacter("noel"):setSprite("brella")
                            cutscene:wait(0.5)
                            noel_umbrella = true
                        else
                            local noel = cutscene:getCharacter("noel")
                            local save = {steamworks = {fallen = 1,},}
                            Noel:saveNoel(save)
                        end
                    end
                end
                Game.world.camera.keep_in_bounds = false
                Assets.playSound("fall_trapdoor")

                if cutscene:getCharacter("susie_lw") then
                    cutscene:getCharacter("susie_lw"):setSprite("fall")
                    Assets.playSound("sussurprise")
                end

                if cutscene:getCharacter("noelle_lw") then
                    cutscene:getCharacter("noelle_lw"):setSprite("shocked")
                    Assets.playSound("noelle_scared")
                end

                if dess then
                    dess:setSprite("beatbox")
                    --Game.world.timer:tween(1, dess, {rotation = math.rad(90)}, "in-bounce")
                end

                for _,member in ipairs(Game.party) do
                    local chara = Game.world:getCharacter(member.id)
                    if chara then
                        chara.alpha = 0.75
                        if member.id == "noel" then
                            if noel_not_fall == true then
                            elseif noel_umbrella == true then
                                cutscene:slideTo(chara, chara.x, chara.y + 400, 1)
                            else
                                chara:setOrigin(0.5, 0.5)
                                chara:setPosition(chara.x, chara.y-chara.height/2)
                                Game.world.timer:tween(2, chara, {rotation = math.rad(90)})
                                cutscene:slideTo(chara, chara.x, chara.y + 800, 1)
                            end
                        else
                            chara:setOrigin(0.5, 0.5)
                            chara:setPosition(chara.x, chara.y-chara.height/2)
                            Game.world.timer:tween(4, chara, {rotation = math.rad(90)})
                            cutscene:slideTo(chara, chara.x, chara.y + 800, 1)
                        end
                    end
                end
                cutscene:wait(2)
                cutscene:detachCamera()
                for _,member in ipairs(Game.party) do
                    local chara = Game.world:getCharacter(member.id)
                    if chara then
                        if member.id ~= "noel" then
                            cutscene:slideTo(chara, chara.x, chara.y + 800, 1)
                        end
                    end
                end
                cutscene:mapTransition("steamworks/13")
                Game:setFlag("stw_basement_trapped", true)
            end
        end
        Game:setFlag("axis_second_met", true)
    end,
    basement_door = function(cutscene, event)
        if Game:getFlag("stw_basement_trapped") and Game:getFlag("axis_basement_caught") ~= 2 then
            Game.world:mapTransition("steamworks/13b")
        else
            cutscene:text("* (The door is locked.)")
        end
    end,
    basement_axis = function(cutscene, event)
        local axis = cutscene:getCharacter("axis")
        cutscene:wait(cutscene:walkTo(axis, axis.x, event.y - 80, 0.5, "down"))

        cutscene:showNametag("Axis")
        if Game:getFlag("axis_basement_caught") ~= 1 then
            cutscene:text("* I CANNOT BELIEVE YOU\nFELL FOR THAT.", "normal", "axis")
            cutscene:text("* I AM SMART, THEREFORE I\nPREDICTED YOUR ESCAPE.", "normal", "axis")
            cutscene:text("* NOW,[wait:5] BACK YOU GO.", "normal", "axis")
            Game:setFlag("axis_basement_caught", 1)
        else
            cutscene:text("* WHAT.[wait:5] WHY.", "normal", "axis")
            cutscene:text("* DID YOU THINK I WOULD\nJUST LEAVE AFTER ONE\nATTEMPT?", "normal", "axis")
            cutscene:text("* ... I WAS ABOUT TO,[wait:5]\nACTUALLY.[wait:5] THAT WAS\nCLOSE.", "normal", "axis")
            cutscene:text("* I WILL LOCK THE DOOR\nFROM NOW ON.", "normal", "axis")
            cutscene:text("* BYE NOW.", "normal", "axis")
            Game:setFlag("axis_basement_caught", 2)
        end
        cutscene:hideNametag()

        cutscene:walkTo(axis, axis.x, axis.y + 200, 2, "down")
        Game.world:mapTransition("steamworks/13", "door")
    end,
    vent = function(cutscene, event)
        cutscene:text("* A slightly open vent.")
        local opinion = cutscene:textChoicer("* Go inside?\n", {"Yes", "No"})
        if opinion == 1 then
            Game.world:mapTransition("steamworks/13", "vent")
        end
    end,
    basement_out = function(cutscene, event) -- WIP
        cutscene:wait(1)
        --[[cutscene:showNametag("Hero")
        cutscene:text("* Finally we're out.", nil, "hero")
        cutscene:hideNametag()
        cutscene:wait(1)]]
    end,
    grandfather_clock = function(cutscene, event)
        if not Game:getFlag("stw_grandfather_clock_talk") then
            cutscene:showNametag("Clock")
            cutscene:text("* Tick-tock - tick-tock -\ntick-tock...", nil, event)
            cutscene:text("* The current time is 6:26,\nMonday morning!", nil, event)
            cutscene:text("* You may have noticed the\napple trees outside the\nSteamworks are blooming.", nil, event)
            cutscene:text("* That means Spring is upon us!", nil, event)
            cutscene:text("* This time of year, my creator\nrecommends a picnic by the\nriver just south of here!", nil, event)
            cutscene:hideNametag()
            Game:setFlag("stw_grandfather_clock_talk", 1)
        elseif Game:getFlag("stw_grandfather_clock_talk") == 1 then
            cutscene:showNametag("Clock")
            cutscene:text("* Why the puzzled look? Have we\nnot met before?", nil, event)
            cutscene:showNametag("Grandfather Clock")
            cutscene:text("* I am the Grandfather Clock of\nthe Underground!", nil, event)
            cutscene:text("* It is my responsibility to\nkeep the standard time for all\nmonsters.", nil, event)
            cutscene:text("* However, I cannot help but\nfeel there is a miscalculation\nin my tick-tocking.", nil, event)
            cutscene:text("* It is simply driving me mad!", nil, event)
            cutscene:hideNametag()
            Game:setFlag("stw_grandfather_clock_talk", 2)
        elseif Game:getFlag("stw_grandfather_clock_talk") == 2 then
            cutscene:showNametag("Grandfather Clock")
            cutscene:text("* I do not sense the gears\nturning within these walls.", nil, event)
            cutscene:text("* Hm, yes, I believe the main\nclock face outside has stalled!", nil, event)
            cutscene:text("* An engineer should arrive to\nfix it soon.", nil, event)
            cutscene:text("* Do not worry, I will continue\nto keep the time!", nil, event)
            cutscene:hideNametag()
            Game:setFlag("stw_grandfather_clock_talk", 3)
        elseif Game:getFlag("stw_grandfather_clock_talk") == 3 then
            cutscene:showNametag("Grandfather Clock")
            cutscene:text("* Tick-tock - tick-tock -\ntick-tock...", nil, event)
            cutscene:hideNametag()
        end
    end,
    note_17 = function(cutscene, event)
        if Game:getFlag("stw_note_17") == 1 then
            Game:setFlag("stw_note_17", 0)
            cutscene:text("* (The paper underneath reads:)	")
            cutscene:text("* Project:[wait:5] Metal & Magic:	")
            cutscene:text("* Effective immediately,[wait:5] cease\nhome utility production at the\nFactory-	")
            cutscene:text("* (The rest of the page is\nredacted.)")
        else
            Game:setFlag("stw_note_17", 1)
            cutscene:text("* (The topmost paper is a\nhandwritten letter.)	")
            cutscene:text("* To:[wait:5] King ASGORE.	")
            cutscene:text("* This project,[wait:5] while exciting,[wait:5]\nwill be quite the undertaking.	")
            cutscene:text("* We will need Mining Co. to\nwork overtime to provide the\nnecessary materials.	")
            cutscene:text("* Furthermore, a meeting was\nconducted at the Factory.	")
            cutscene:text("* I'm happy to report that\neveryone is on board!	")
            cutscene:text("* There already are many great\nrobot ideas floating about.	")
            cutscene:text("* Cooking,[wait:5] cleaning,[wait:5] recreation;[wait:5]\nthe motivation is through the\nroof!	")
            cutscene:text("* Though...[wait:5] one engineer\nsuggested we take this further\nwith a \"protection bot.\"	")
            cutscene:text("* I am quite unsure about that\nproposition but you have the\nfinal say.	")
            cutscene:text("* In any case,[wait:5] we will see this\ncompleted.	")
            cutscene:text("* - Prof. Z.")
        end
    end,
    boba_npc = function(cutscene, event)
        if not Game:getFlag("stw_boba_npc_talk") then
            cutscene:showNametag("Robot")
            cutscene:text("* (Slurp slurrrrp)", nil, event)
            cutscene:text("* Ahhhh!", nil, event)
            cutscene:text("* Nothing like Steamworks\nBoba-Soup (TM) to fuel the\nengine!", nil, event)
            cutscene:text("* What? Don't act like you've\nnever heard of it.", nil, event)
            cutscene:hideNametag()
            Game:setFlag("stw_boba_npc_talk", 1)
        elseif Game:getFlag("stw_boba_npc_talk") == 1 then
            cutscene:showNametag("Robot")
            cutscene:text("* Did you know that humans also\nrun on a liquid? It's called\n\"blood.\"", nil, event)
            cutscene:text("* Apparently it doesn't taste\nany good, which is like, a\ntotal shame.", nil, event)
            cutscene:hideNametag()
            Game:setFlag("stw_boba_npc_talk", 2)
        elseif Game:getFlag("stw_boba_npc_talk") == 2 then
            cutscene:showNametag("Robot")
            cutscene:text("* I'd let you try this stuff but\nit's total poison to\nnon-robots.", nil, event)
            cutscene:text("* How do I know that? I don't.", nil, event)
            cutscene:text("* I just wanna deter you from\ndraining my sweet sweet lake.", nil, event)
            cutscene:hideNametag()
            Game:setFlag("stw_boba_npc_talk", 3)
        elseif Game:getFlag("stw_boba_npc_talk") == 3 then
            cutscene:showNametag("Robot")
            cutscene:text("* (Slurp slurrrp)", nil, event)
            cutscene:hideNametag()
        end
    end,
    burned_stand = function(cutscene, event) -- no Roba gotta change that
        --[[cutscene:showNametag("Ceroba")
        cutscene:text("* Oh,[wait:5] yeah,[wait:5] this...[wait:10] Thing.", "alt", "ceroba")
        cutscene:text("* It's WIP.", "irked", "ceroba")
        cutscene:hideNametag()]]
    end,
    noel_06 = function(cutscene, event) -- okay now you are
        if Game.world:getCharacter("noel") then
            cutscene:text("* Oh,[wait:5] I'm pink now.", "neutral", "noel")
        end
    end,
    manta = function(cutscene, event) -- manta cutscene WIP
        local manta = Game.world.map:getEvent("stw_manta")
		Game.world.music:fade(0, 0.25)
		Assets.playSound("manta_startup")
		manta.x = 2200
		manta.y = 960
		manta:moveInDirection("right")
		cutscene:wait(function() return manta:isStopped() end)
		cutscene:wait(0.25)
		Game.world.music:fade(1, 0.75)
        cutscene:showNametag("Manta")
		if #Game.party == 1 then
			cutscene:text("* The-The-The floor is lava,\ntraveler!")
		else
			cutscene:text("* The-The-The floor is lava,\ntravelers!")
		end
        cutscene:text("* I am sorry to say I failed the\ngame some time ago-bzzt. ")
        cutscene:text("* H-However-r, you do not have\nto! I will ferry you across the\nlake-bzzt!")
        cutscene:hideNametag()
        Game:setFlag("manta_met", true)
        Game:setFlag("manta_spawn_id", 1)
    end,
    split_path = function(cutscene, event)
        cutscene:wait(cutscene:walkTo(Game.world.player, 700, Game.world.player.y, 1.5, "left"))
        cutscene:wait(1)
        Game.world.player:setFacing("up")
        cutscene:wait(1)
        if cutscene:getCharacter("susie_lw") then
            cutscene:showNametag("Susie")
            cutscene:text("* Huh.[wait:5] A split path.", "neutral_side", "susie")
            cutscene:text("* I'd say we should go into the opened door.", "small_smile", "susie")
            cutscene:text("* Cuz if it's open...[wait:5] This means that someone has already been there.", "closed_grin", "susie")
            cutscene:text("* And they probably did all the puzzles and stuff there.", "smile", "susie")
            cutscene:text("* So it'll be an easy route.", "small_smile", "susie")
            if cutscene:getCharacter("jamm_lw") or cutscene:getCharacter("jammarcy_light") then
                cutscene:showNametag("Jamm")
                cutscene:text("* I wouldn't be so sure,[wait:5] Susie.", "look_left", "jamm")
                cutscene:showNametag("Susie")
                cutscene:text("* Why's that?", "nervous_side", "susie")
                cutscene:showNametag("Jamm")
                cutscene:text("* That opened path might be a trap set up by Axis.", "nervous_left", "jamm")
                cutscene:text("* Maybe he expects us to go there so he could ambush us.", "determined", "jamm")
                cutscene:showNametag("Susie")
                cutscene:text("* Dang,[wait:5] you might be right.", "nervous_side", "susie")
                cutscene:text("* But I suppose the choice is still up to the leader.", "neutral_side", "susie")
            end
            cutscene:hideNametag()
        elseif cutscene:getCharacter("jamm_lw") or cutscene:getCharacter("jammarcy_light") then
            cutscene:showNametag("Jamm")
            cutscene:text("* I'd say we should go into the upper path.", "neutral", "jamm")
            cutscene:text("* Because that opened path is kind of suspicious...", "nervous_left", "jamm")
            cutscene:text("* It might be a trap set up by Axis.", "look_left", "jamm")
            cutscene:hideNametag()
        end
    end,
    chem_door = function(cutscene, event)
        cutscene:wait(1)
        Game.world.map:getEvent("stw_chem_door"):setSprite("world/maps/steamworks/small_objects/31_door", 1/10)
        Assets.playSound("sliding_door_open")
        cutscene:wait(0.5)
        Game.world.map:getEvent("stw_chem_door"):setSprite("world/maps/steamworks/small_objects/31_door_5")
        cutscene:wait(1)
        Game:setFlag("31_chem_door_opened", true)
    end,
}

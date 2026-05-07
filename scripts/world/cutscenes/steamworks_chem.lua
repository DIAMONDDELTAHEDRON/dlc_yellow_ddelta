return {
    reception = function(cutscene, event)
        if Game:getFlag("got_steamworks_id") then
            cutscene:text("* (You notice a sign in the\nreceptionist office.)")
            cutscene:text("* Do not eat the writing\nutensils! Not again...")
            cutscene:text("* (You wonder what tragic event\nwarranted this sign.)")
        else
            cutscene:text("* (The receptionist is\nunreceptive.)")
            cutscene:text("* (They seemed to be in the\nmiddle of creating a new\nSteamworks ID.)")
            local opinion = cutscene:textChoicer("* (Finish their work?)\n", {"Yes", "No"})
            if opinion == 1 then
                Game.world.music:fade(0, 10/30)
				local cursor_hack = Kristal.Config["alwaysShowCursor"] -- God damn it
				Kristal.Config["alwaysShowCursor"] = false
                local minigame = Game.world:spawnObject(DrawingMinigame("id_minigame/crayon_id", "stworks_id"), WORLD_LAYERS["ui"])
                minigame.alpha = 0
                cutscene.world.timer:tween(10/30, minigame, {alpha = 1})
                cutscene:wait(1/30)
                local mus = Music("build_a_bot")
                minigame.active_fake = true

                cutscene:wait(function() return minigame.done end)
                minigame:fadeOutAndRemove(10/30)
                mus:fade(0, 1)
                cutscene:wait(1)
                mus:remove()
                Game.world.music:fade(1, 1)
				Kristal.Config["alwaysShowCursor"] = cursor_hack
                Game.inventory:addItem("steamworks_id")
                Game:setFlag("got_steamworks_id", true)
                cutscene:wait(0.75)
                cutscene:walkTo(Game.world.player, 300, Game.world.player.y, 0.5, "up")
                cutscene:wait(1)
                Assets.playSound("sliding_door_open")
                Game.world.map:getTileLayer("door_closed").visible = false
                cutscene:wait(1)
            end
        end
    end,
    cake = function(cutscene, event)
        if Game:getFlag("chem_got_cake") then
            cutscene:text("* (It's empty now.)")
        else
            cutscene:text("* (You would like some Cake but\nyou'd rather not alert Axis.)")
            local outcome = cutscene:textChoicer("* (Risk it?)\n", {"Yes", "No"})
            if outcome == 1 then
                if Game.inventory:tryGiveItem("uty_items/cake") then
                    Game.world.music:fade(0, 10/30)
                    Assets.playSound("chem_cake_take")
                    cutscene:wait(3.5)
                    Game.world.map:getEvent("stw_cake"):setSprite("world/events/steamworks/chem_03_cake_2")
                    Game:setFlag("chem_got_cake", true)
                    Game.world.music:fade(1, 10/30)
                    cutscene:text("* (...Phew.)")
                else
                    cutscene:text("* (Not enough space.)")
                end
            else
                cutscene:text("* (Better safe than sorry.)")
            end
        end
    end,
    cabinet_04 = function(cutscene, event)
        if Game:getFlag("chem_got_water") then
            cutscene:text("* (Nothing inside but\noddly-shaped glass.)")
        else
            cutscene:text("* (You open the storage cabinet\nand find some Dihydrogen\nMonoxide.)")
            local outcome = cutscene:textChoicer("* (Take it?)\n", {"Yes", "No"})
            if outcome == 1 then
                if Game.inventory:tryGiveItem("uty_items/dihydrogen_monoxide") then
                    Game:setFlag("chem_got_water", true)
                    cutscene:text("* (You got Dihydrogen Monoxide!)")
                else
                    cutscene:text("* (Not enough inventory space.)")
                end
            else
                cutscene:text("* (Could be expired.)")
            end
        end
    end,
    hermit = function(cutscene, event)
        if not Game:getFlag("steamworks_hermit_talk") then
            cutscene:text("* Oh my![wait:5] You startled me!")
            cutscene:text("* I know my eyes aren't what they\nused to be but...")
            local choice = cutscene:textChoicer("* ...You aren't a machine,[wait:5]\ncorrect?", {"Correct", "No, I am"})
            if choice == 1 then
                cutscene:text("* I can't believe it.[wait:5] Another\nmonster in the Steamworks? ")
                cutscene:text("* Thought I was the only one.")
                cutscene:text("* I'm not incredibly social but\nyou're welcome to rest up here.")
            else
                cutscene:text("* Hm?[wait:5] You look nothing like the\nothers.")
                cutscene:text("* Don't pull my leg now.[wait:5] At my\nage,[wait:5] it might break off.")
            end
            Game:setFlag("steamworks_hermit_talk", 1)
        else
            cutscene:text("* This facility used to be the\nepicenter for innovation back\nin the day.")
            cutscene:text("* In my prime I was a chemist.[wait:5]\nA pretty good one too.")
            cutscene:text("* That is...[wait:5] until they let\neveryone go.")
            cutscene:text("* Said there were too many cooks\nin the kitchen,[wait:5] wanted to focus\nin.")
            cutscene:text("* Couldn't let my passion go that\neasily so I hid away when they\nlocked up. ")
            cutscene:text("* Now I have the freedom to\nexperiment whenever and however\nI please.")
            cutscene:text("* Though...[wait:5] no one is around to\nwitness my efforts.")
        end
    end,
    hermit_bookshelf = function(cutscene, event)
        cutscene:text("* (You examine the\nbookshelf...)")
        cutscene:text("* (A title called \"Mysteries of\nthe Underground\" catches your\neye.)")
        local choice = cutscene:textChoicer("* (Read it?)\n", {"Yes", "No"})
        if choice == 1 then
            cutscene:text("* Chapter One:[wait:5] Blunko's\nBlunder.")
            cutscene:text("* Located in Oasis Valley,[wait:5] in a\nmodern cafe you can't miss,[wait:5]\nlies an arcade cabinet.")
            cutscene:text("* Painted blue and coated with a\nthick layer of dust,[wait:5] it sits\nthere,[wait:5] out of order.")
            cutscene:text("* Few monsters recall seeing it\nup and running and that might\nbe on purpose.")
            cutscene:text("* On the cabinet,[wait:5] two logos\nreside:[wait:5] Team Y and Blunko\nIndustries.")
            cutscene:text("* The same two human companies\nthat created the Mew Mew Love\nBlaster cabinet.")
            cutscene:text("* Legends say it was playable\nfor a time after it was\nrecovered from the dump...")
            cutscene:text("* ...but its contents were\n\"unpleasant\" upon experience.")
            cutscene:text("* (You flip to the next\nchapter.)")
            local choice2 = cutscene:textChoicer("* (Continue reading?)\n", {"Yes", "No"})
            if choice2 == 1 then
                cutscene:text("* Chapter Two:[wait:5] The Path.")
                cutscene:text("* The Underground is a vast\nplace.")
                cutscene:text("* Throughout it are pathways\nand/or fences to lead monsters\nfrom place to place.")
                cutscene:text("* But maybe,[wait:5] just maybe,[wait:5] the\npaths are truly there to keep\nyou safe.")
                cutscene:text("* In a report from 20XX,[wait:5] a\nfather recalled fishing with\nhis son in the Snowdin forest.")
                cutscene:text("* As the father prepared his\nline,[wait:5] his son wandered past the\nfence and into the trees.")
                cutscene:text("* The father didn't notice at\nfirst but soon began to search\nfor the child.")
                cutscene:text("* \"Before I found ____,[wait:5] it felt\nlike I was in a daze,[wait:5]\" the\nfather recounts.")
                cutscene:text("* \"Just...[wait:5] nothing out there.\"")
                cutscene:text("* (You flip to the next\nchapter.)")
                local choice3 = cutscene:textChoicer("* (Continue reading?)\n", {"Yes", "No"})
                if choice3 == 1 then
                    cutscene:text("* Chapter Three:[wait:5] The Phantom\nSOUL.")
                    cutscene:text("* Seven human SOULS are all it\ntakes to destroy the barrier\nthat intraps us monsters...")
                    cutscene:text("* ...and over time,[wait:5] King ASGORE\nand the Royal Guard have\nensured we reach that goal.")
                    cutscene:text("* This process has been\ncontroversial among some\nresidents but...")
                    cutscene:text("* ...\"War is not pleasant\" says\nthe head of the Royal Guard.")
                    cutscene:text("* Typically,[wait:5] when a human falls\ninto our home,[wait:5] they're\n\"collected\" within hours.")
                    cutscene:text("* But one time...[wait:5] it took\nyears.")
                    cutscene:text("* It was a typical afternoon in\nSnowdin...")
                    cutscene:text("* Suddenly,[wait:5] a human was spotted\nin the area before swiftly\nfleeing for Waterfall.")
                    cutscene:text("* This,[wait:5] surprisingly,[wait:5] was the\nlast time they were seen\nalive.")
                    cutscene:text("* Officials at the time said the\ndisappearance most likely meant\nthe human was hiding.")
                    cutscene:text("* However,[wait:5] the human's SOUL was\nlater inexplicably found deep\nin Waterfall...")
                    cutscene:text("* (...)")
                    cutscene:text("* (You put the book back.)")
                end
            end
        end
    end,
    chem_05_door = function(cutscene, event)
		if not Game:getFlag("chem_05_acid_used") then
			if not Game:getFlag("chem_got_acid") then
				cutscene:text("* (A complex lock mechanism\nblocks your exit.)")
			else
				cutscene:text("* (A complex lock mechanism\nblocks your exit.)")
				local choice = cutscene:textChoicer("* (Use the ACID?)\n", {"Yes", "No"})
				if choice == 1 then
					cutscene:text("* (You use the ACID to ACID\naway at the DOOR.)")
					Game.inventory:removeItem("uty_items/h_acid")
					local door = Game.world.map:getEvent("stw_chem_05_door")
					door:setSprite("world/maps/steamworks/small_objects/chem_05_door")
					door.sprite:play(1 / 10, false)
					cutscene:wait(function() return door.sprite.frame == 6 end)
					Assets.playSound("puzzle_icemelt")
					cutscene:wait(function() return door.sprite.frame == 17 end)
					Assets.playSound("sliding_door_open")
					cutscene:wait(0.5)
					cutscene:text("* TODO: Axis cutscene here.")
					door.solid = false
					Game:setFlag("chem_05_acid_used", true)
				end
			end
		end
    end,
}

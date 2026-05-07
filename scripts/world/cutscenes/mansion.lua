return {
    bamboo = function(cutscene, event)
        cutscene:text("* (Bamboo plants.)")
    end,

    -- Entrance
    lockeddoor = function(cutscene, event)
        cutscene:text("* (The door is locked from the\nother side.)")
        if cutscene:getCharacter("ceroba") then
            cutscene:showNametag("Ceroba")
            cutscene:text("* The lock on this door is actually stuck.", "neutral", "ceroba")
            cutscene:text("* I wanted to fix it for a while,[wait:5] but...", "alt", "ceroba")
            cutscene:text("* Never actually got to doing it.", "muttering", "ceroba")
            cutscene:hideNametag()
        end
    end,

    -- West Hallway 2
    officedoor = function(cutscene, event)
        Assets.playSound("doorclose")
        cutscene:mapTransition("dunes/mansion/office", "down")
    end,

    drawerWH = function(cutscene, event)
        cutscene:text("* (You open the drawer...)")
        cutscene:text("* (Nothing but old pens and\npencils.)")
    end,

    talldrawer = function(cutscene, event)
        cutscene:text("* (You search the drawers...)")
        cutscene:text("* (Just some knickknacks of\nvarious shapes and sizes.)")
    end,

    -- Kanako's room
    toys = function(cutscene, event)
        cutscene:text("* (Several building bricks are\nscattered around a stuffed\nanimal.)")
    end,

    books = function(cutscene, event)
        cutscene:text("* (Books of a novice\nreading level lie in the\nbasket.)")
    end,

    dresser = function(cutscene, event)
        cutscene:text("* (You open a dresser\ndrawer and see many\nneatly folded shirts.)")
    end,

    kanakobed = function(cutscene, event)
        cutscene:text("* (The sturdy bed sits\nbathing in the warm glow\nof the Dunes.)")
    end,

    gameconsole = function(cutscene, event)
        cutscene:text("* (An old TV and game console\ngathering dust.)")
    end,

    -- Office
    cabinet_l = function(cutscene, event)
        cutscene:text("* (The cabinet contains\nthesis papers on many\ndifferent subjects.)")
    end,

    bookshelf_l = function(cutscene, event)
        cutscene:text("* (Dozens of books line the\nshelves.)")
        cutscene:text("* (A thick,[wait:5] degraded book sticks\nout from the others.)")
        cutscene:text("* \"Home: Blueprints and\nAnnotations - Ketsukane\"")
    end,

    box = function(cutscene, event)
        cutscene:text("* (A few unfinished\nrobots poke out from the\nbox.)")
    end,

    workstation = function(cutscene, event)
        cutscene:text("* (Gizmos and gadgets\nfill the deskspace.)")
        cutscene:text("* (Looming over it all...[wait:5]\na map.)")
        cutscene:text("* (On the map are several\npinned locations of...)")
        cutscene:text("* (...)")
    end,

    drawer = function(cutscene, event)
        cutscene:text("* (A drawer full of\nvideotapes.)")
        cutscene:text("* (A label on the front\nreads:[wait:5] \"Home movies.\")")
    end,

    bookshelf_r = function(cutscene, event)
        cutscene:text("* (Dozens of books line the\nshelves.)")
        cutscene:text("* (History,[wait:5] engineering,[wait:5]\nchemistry...[wait:5] All too advanced\nfor you.)")
    end,

    cabinet_r = function(cutscene, event)
        cutscene:text("* (Expertly organized\nfiles,[wait:5] labeled with\nnumerous monster names.)")
    end,

    -- East Hallway 2
    bedroomdoor = function(cutscene, event)
        Assets.playSound("doorclose")
        cutscene:mapTransition("dunes/mansion/bedroom", "down")
    end,

    drawerEH = function(cutscene, event)
        cutscene:text("* (You open the drawer...)")
        cutscene:text("* (It's empty.)")
    end,

    stove = function(cutscene, event)
        cutscene:text("* (An old-fashioned gas oven,[wait:5]\nbest kept turned off.)")
        cutscene:text("* (Wouldn't want a house fire.)")
    end,

    dishes = function(cutscene, event)
        cutscene:text("* (Dirty dishes.)")
        if cutscene:getCharacter("ceroba") then
            cutscene:showNametag("Ceroba")
            cutscene:text("* Left here undone...[wait:5] Just like everything in this house.", "dissapproving", "ceroba")
            cutscene:hideNametag()
        end
    end,

    sink = function(cutscene, event)
        cutscene:text("* (You stare at your reflection\nin the sink water...)")
        -- maybe put something here depending on party's leader???
    end,

    cuttingboard = function(cutscene, event)
        if not Game:getFlag("ceroba_robbing_attempt") then
            cutscene:text("* (You reach for the\nknife on the counter.)")
            if cutscene:getCharacter("ceroba") then
                cutscene:showNametag("Ceroba")
                cutscene:text("* Um, excuse me?", "irked", "ceroba")
                cutscene:text("* That still belongs to me,[wait:5] you know.", "muttering", "ceroba")
                cutscene:hideNametag()
                Game:setFlag("ceroba_robbing_attempt", true)
            else
                cutscene:text("* (On the second thought,[wait:5] you decide to leave it be.)")
            end
        else
            cutscene:text("* (You decide to keep a safe\ndistance between you and the\nknife.)")
        end
    end,

    fridge = function(cutscene, event)
        if not Game:getFlag("corn_chowder") then
            cutscene:text("* (You open the refrigerator and\nfind some leftover corn\nchowder.)")
            if cutscene:getCharacter("ceroba") then
                cutscene:showNametag("Ceroba")
                cutscene:text("* Oh,[wait:5] I suppose I left it here...", "alt", "ceroba")
                cutscene:text("* You can take it if you want.[wait:5] I don't mind.", "neutral", "ceroba")
                cutscene:hideNametag()
            end
            local choice = cutscene:textChoicer("* (Take it?)\n", {"Yes", "No"})
            if choice == 1 then
                if Game.inventory:tryGiveItem("uty_items/corn_chowder") then
                    cutscene:text("* (You got some Corn Chowder!)")
                    Game:setFlag("corn_chowder", 1)
                else
                    Assets.playSound("uty_cant_select")
                    cutscene:text("* (Not enough space.)")
                end
            end
        elseif Game:getFlag("corn_chowder") == 1 then
            cutscene:text("* (You open the refrigerator and\nfind some more corn\nchowder.)")
            if cutscene:getCharacter("ceroba") then
                cutscene:showNametag("Ceroba")
                cutscene:text("* ...", "surprised", "ceroba")
                cutscene:text("* Didn't you took that already?", "nervous_smile", "ceroba")
                cutscene:hideNametag()
            end
            local choice = cutscene:textChoicer("* (Take more?)\n", {"Yes", "No"})
            if choice == 1 then
                if Game.inventory:tryGiveItem("uty_items/corn_chowder") then
                    cutscene:text("* (You got some more Corn Chowder!)")
                    Game:setFlag("corn_chowder", 2)
                else
                    Assets.playSound("uty_cant_select")
                    cutscene:text("* (Not enough space.)")
                end
            end
        elseif Game:getFlag("corn_chowder") == 2 then
            cutscene:text("* (You open the refrigerator and\nfind some corn chowder again.)")
            if cutscene:getCharacter("ceroba") then
                cutscene:showNametag("Ceroba")
                cutscene:text("* ...", "unamused", "ceroba")
                cutscene:text("* This is getting ridiculous.", "unamused", "ceroba")
                cutscene:hideNametag()
            end
            local choice = cutscene:textChoicer("* (Take even more?)\n", {"Yes", "No"})
            if choice == 1 then
                if Game.inventory:tryGiveItem("uty_items/corn_chowder") then
                    cutscene:text("* (You got some more Corn Chowder!)")
                    Game:setFlag("corn_chowder", 3)
                else
                    Assets.playSound("uty_cant_select")
                    cutscene:text("* (Not enough space.)")
                end
            end
        else
            cutscene:text("* (You thought about taking more,[wait:5] but...)")
            cutscene:text("* (Infinite heals would be game breaking.)")
        end
    end,

    -- Bedroom
    familyphoto = function(cutscene, event)
        Assets.playSound("ui_move")
        cutscene:after(function()
            Game.world:openMenu(ImageViewer("world/mansion_family_picture"))
        end)
    end,

    bed = function(cutscene, event)
        cutscene:text("* (The bed is tidily made.)")
        cutscene:text("* (Doesn't look like it's been\nused in a long time.)")
        if cutscene:getCharacter("ceroba") then
            cutscene:showNametag("Ceroba")
            cutscene:text("* Even though it's old and dusty...", "snarky", "ceroba")
            cutscene:text("* It's still must be comfortable as ever.", "smile", "ceroba")
            cutscene:hideNametag()
        end
    end,

    nightstand = function(cutscene, event)
        cutscene:text("* (You search the nightstand...)")
        cutscene:text("* (Nothing but an empty eyeglass\ncase sits in the drawer.)")
        if cutscene:getCharacter("ceroba") then
            cutscene:showNametag("Ceroba")
            cutscene:text("* Weird.[wait:5] If I remember correctly,[wait:5] there should be a...", "question", "ceroba")
            cutscene:text("* [speed:0.1]...", "alt", "ceroba")
            cutscene:text("* Actually,[wait:5] nevermind that.", "dissapproving", "ceroba")
            cutscene:hideNametag()
        end
    end,

    closet = function(cutscene, event)
        cutscene:text("* (Ceroba's many outfits hang in\nthe closet.)")
        cutscene:text("* (You can see someone else's\nclothes hidden behind the front\nrow.)")
        if cutscene:getCharacter("ceroba") then
            cutscene:showNametag("Ceroba")
            cutscene:text("* Oh,[wait:5] right,[wait:5] these are still here...", "unsure", "ceroba")
            cutscene:text("* Maybe I'll move them one day.", "closed_eyes", "ceroba")
            cutscene:hideNametag()
        end
    end,

    -- West and East Hallways
    founderscrest = function(cutscene, event)
        cutscene:text("* The Founder's Crest")
        cutscene:text("* \"Decisive.[wait:5] Devoted.[wait:5]\nDetermined.\"")
    end,

    -- Kotatsu room
    fireplace = function(cutscene, event)
        cutscene:text("* (The fireplace is\nmaking the already-warm\nhouse warmer.)")
        if cutscene:getCharacter("ceroba") then
            cutscene:showNametag("Ceroba")
            cutscene:text("* I'm surprised it didn't went out yet.", "surprised", "ceroba")
            cutscene:text("* Quite impressive.", "neutral", "ceroba")
            cutscene:hideNametag()
        end
    end,

    kotatsu = function(cutscene, event)
        local ceroba = cutscene:getCharacter("ceroba")
        cutscene:text("* (Some kind of a table.)")
        if ceroba then
            cutscene:text("* That's a Kotatsu.", "neutral", "ceroba")
            cutscene:text("* If you'd like...[wait:10]\n[face:neutral]* We could rest here.", "alt", "ceroba")
            local outcome = cutscene:textChoicer("* (Begin hangout?)\n", {"Yes", "No"})
            if outcome == 1 then
                cutscene:text("* Alright then.", "neutral", "ceroba")
                cutscene:text("* Get comfortable.", "smile", "ceroba")
                cutscene:wait(cutscene:fadeOut(1))
                cutscene:detachFollowers()
                cutscene:detachCamera()
                Game.world.camera:setPosition(320, 240)
                ceroba:setPosition(320, 288)
                ceroba:setFacing("down")
                cutscene:getCharacter("hero_lw"):setPosition(320, 420)
                cutscene:getCharacter("hero_lw"):setFacing("up")
                cutscene:getCharacter("susie_lw"):setPosition(414, 340)
                cutscene:getCharacter("susie_lw"):setSprite("sit_1")
                cutscene:getCharacter("susie_lw").flip_x = true
                cutscene:getCharacter("jamm_lw"):setPosition(194, 354)
                cutscene:getCharacter("jamm_lw"):setSprite("sit")
                cutscene:wait(3)
                cutscene:wait(cutscene:fadeIn(1))
            else
                cutscene:text("* Maybe some other time then.", "closed_eyes", "ceroba")
            end
        end
    end,

    -- Chujin's Grave
    grave = function(cutscene, event)
        cutscene:text("* Chujin Ketsukane")
        cutscene:text("* The best of us.")
    end,

    -- Basement (aka the Study)
    tv = function(cutscene, event)
        cutscene:text("* (An old,[wait:5] dusty monitor with\nnothing but static hissing at\nyou.)")
        cutscene:text("* (This only brings you unease.)")
    end,

    scraps = function(cutscene, event)
        cutscene:text("* (A cobweb-ridden box of\nscraps.)")
    end,

    trash = function(cutscene, event)
        cutscene:text("* (Dozens of crumpled up\nformulas lie in the bin.)")
    end,

    study_bookshelf_left = function(cutscene, event)
        cutscene:text("* (A prototype of a familiar\nface rests on the shelf.)")
    end,

    study_drawer = function(cutscene, event)
        cutscene:text("* (A drawer full of\nvideotapes.)")
        cutscene:text("* (A label on the front reads:\n\"Legacy.\")")
    end,

    study_box = function(cutscene, event)
        cutscene:text("* (Forgotten fragments of\nvarious robots.)")
        cutscene:text("* (All of their soulless eyes\nstare through you.)")
    end,

    study_bookshelf_right = function(cutscene, event)
        cutscene:text("* (On the shelf sits many books,[wait:5]\ntheses,[wait:5] and illustrations of\nscience...)")
        cutscene:text("* (...Most on the subject of\nhumans and their SOULs.)")
    end,
}

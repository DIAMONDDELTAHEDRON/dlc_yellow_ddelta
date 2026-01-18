return function(cutscene, event)
    Game.world.music:fade(0, 1)
    cutscene:text("* I know why u came here")
    cutscene:text("* So here you go")
    Music("fanfare", 1, 1, false)
    Game.world:spawnNPC("ceroba", Game.world.player.x+100, Game.world.player.y-320)
    local roba = cutscene:getCharacter("ceroba")
    cutscene:wait(cutscene:slideTo(roba, roba.x, Game.world.player.y, 10))
    cutscene:wait(1)
    if #Game.party >= 4 then
        cutscene:text("* Wait what")
        cutscene:text("* Your party is full!??!?!?!?!?!?!?!?")
        cutscene:text("* Okay you know what")
        cutscene:getCharacter(Game.party[4].id):explode()
        Game:removePartyMember(Game.party[4].id)
        cutscene:wait(2)
    end
    if Game:isDessMode() then
        cutscene:text("* Oh wait a sec it's Dess Mode:tm:")
        cutscene:text("* Uhhhhhhhhhhhhh")
        cutscene:wait(2)
        Assets.playSound("vaporized", 1.2)
        local sprite = roba.sprite
        sprite.visible = false
        local death_x, death_y = sprite:getRelativePos(0, 0, self)
        local death
        death = DustEffect(sprite:getTexture(), death_x, death_y, true, function() roba:remove() end)
        death:setColor(sprite:getDrawColor())
        death:setScale(sprite:getScale())
        roba:addChild(death)
        cutscene:wait(2)
        cutscene:text("* Here problem solved")
    else
        cutscene:text("* Here you go she's in your party now")
        Game:unlockPartyMember("ceroba")
        Game:addPartyMember("ceroba")
        roba:convertToFollower()
        cutscene:wait(cutscene:attachFollowers())
        cutscene:wait(1)
    end
    Game.world.music:fade(1, 1)
end
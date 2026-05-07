local Elevator, super = Class(Event)

function Elevator:init(data)
    super.init(self, data)

    self:setOrigin(0.5, 1)
    self:setSprite("world/events/newhome/elevator_1")

    Game.world.timer:after(1/30, function ()
        self.layer = 0.3
    end)
end

function Elevator:onInteract(chara, dir)
    Game.world:startCutscene(function(cutscene)
        local party2
        local party3
        local party4
        local choice
        if Game.party[2] then
            party2 = cutscene:getCharacter(Game.party[2].id)
        end
        if Game.party[3] then
            party3 = cutscene:getCharacter(Game.party[3].id)
        end
        if Game.party[4] then
            party4 = cutscene:getCharacter(Game.party[4].id)
        end
        if Game.world.map.id == "newhome/01" then
            choice = cutscene:textChoicer("* Do you want to go to the MTT Hotel?", { "Yes", "No" })
        elseif Game.world.map.id == "newhome/02b" then
            choice = cutscene:textChoicer("* Do you want to go to the\nCastle?", { "Yes", "No" })
        end
        if choice == 1 then
            cutscene:detachFollowers()
            self:setSprite("world/events/newhome/elevator", 1/16)
            Assets.playSound("sliding_door_open")
            cutscene:wait(0.7)
            self:setSprite("world/events/newhome/elevator_11")
            cutscene:wait(cutscene:walkTo(Game.world.player, self.x - 9, Game.world.player.y, 0.1, "up"))
            cutscene:wait(cutscene:walkTo(Game.world.player, Game.world.player.x, self.y - 8, 0.3, "up"))
            Game.world.player:fadeOutAndRemove(0.2)
            cutscene:wait(0.2)
            if Game.party[2] then
                cutscene:wait(cutscene:walkTo(party2, self.x - 9, party2.y, 0.3, "up"))
                cutscene:wait(cutscene:walkTo(party2, party2.x, self.y - 8, 0.4, "up"))
                party2:fadeOutAndRemove(0.2)
                cutscene:wait(0.2)
            end
            if Game.party[3] then
                cutscene:wait(cutscene:walkTo(party3, self.x - 9, party3.y, 0.3, "up"))
                cutscene:wait(cutscene:walkTo(party3, party3.x, self.y - 8, 0.4, "up"))
                party3:fadeOutAndRemove(0.2)
                cutscene:wait(0.2)
            end
            if Game.party[4] then
                cutscene:wait(cutscene:walkTo(party4, self.x - 9, party4.y, 0.3, "up"))
                cutscene:wait(cutscene:walkTo(party4, party4.x, self.y - 8, 0.4, "up"))
                party4:fadeOutAndRemove(0.2)
                cutscene:wait(0.2)
            end
            if Game.world.map.id == "newhome/01" then
                Game:swapIntoMod("dpr_underground_dlc", false, "hotland/hotellobby")
            elseif Game.world.map.id == "newhome/02b" then
                Game:swapIntoMod("dpr_underground_dlc", false, "hotland/hotellobby") -- placeholder
            end
        end
    end)
    return true
end

return Elevator
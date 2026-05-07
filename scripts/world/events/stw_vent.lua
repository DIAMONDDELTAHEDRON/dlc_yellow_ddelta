local SteamworksVent, super = Class(Event)

function SteamworksVent:init(data)
    super.init(self, data)

    self:setSprite("world/maps/steamworks/small_objects/13_vent")
    self:setOrigin(0.5, 1)

    Game.world.timer:after(1/30, function ()
        self.layer = 0.3
    end)
end

function SteamworksVent:onInteract(chara, dir)
    Game.world:startCutscene(function(cutscene)
        cutscene:text("* A slightly open vent.")
        local opinion = cutscene:textChoicer("* Go inside?\n", {"Yes", "No"})
        if opinion == 1 then
            if Game:getFlag("basement_trapped") then
                Game:setFlag("basement_trapped", false)
            end
            Game.world:mapTransition("steamworks/14", "vent")
        end
    end)
    return true
end

return SteamworksVent
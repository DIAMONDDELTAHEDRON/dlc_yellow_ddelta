local MailStation, super = Class(Event)

function MailStation:init(data)
    super.init(self, data)

    self.solid = true
    self:setOrigin(0, 0)
    self:setSprite("world/events/steamworks/mail_station")
    self.collider = Hitbox(self, 28, 4, 92, 66)
end

function MailStation:onInteract(chara, dir)
    Game.world:startCutscene(function(cutscene)
        cutscene:text("* (An old screen.)")
        cutscene:text("* (It's out of order.)")
    end)
    return true
end

return MailStation
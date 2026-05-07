local Acid, super = Class(Event)

function Acid:init(data)
    super.init(self, data)

    self:setOriginExact(3, 8)
    self:setSprite("world/events/steamworks/hydrochlorid_acid")
	if not Game:getFlag("chem_did_puzzle") or Game:getFlag("chem_got_acid") then
		self.sprite.alpha = 0
		self.active = false
	end
    Game.world.timer:after(1/30, function ()
        self.layer = 0.5
		if Game:getFlag("chem_got_acid") then
			self:remove()
		end
    end)
end

function Acid:onInteract(player, dir)
    if self.active then
		Game.world:startCutscene(function(cutscene)
			local outcome = cutscene:textChoicer("* (Take the acid?)\n", {"Yes", "No"})
			if outcome == 1 then
                if Game.inventory:tryGiveItem("uty_items/h_acid") then
					self:remove()
                    Game:setFlag("chem_got_acid", true)
                    cutscene:text("* (Obtained ACID!)")
                else
                    cutscene:text("* (Not enough space.)")
                end
			else
				cutscene:text("* It doesn't seem appetizing.")
			end
		end)
		return true
	end
end

return Acid
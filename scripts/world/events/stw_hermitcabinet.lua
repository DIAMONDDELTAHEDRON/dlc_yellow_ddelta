local SteamworksHermitCabinet, super = Class(Event)

function SteamworksHermitCabinet:init(data)
    super.init(self, data)

    self:setSprite("world/events/steamworks/chem_04_cabinet")
    self:setOrigin(0.5, 1)
	self.solid = true
	if Game:getFlag("chem_moved_cabinet") then
		self.x = self.x - 80
	end
    Game.world.timer:after(1/30, function ()
        self.layer = 0.3
    end)
end

function SteamworksHermitCabinet:onInteract(player, dir)
    if not Game:getFlag("chem_moved_cabinet") then
		Game.world:startCutscene(function(cutscene)
			cutscene:text("* (You notice wall cracks peeking\nout from behind the cabinet.)")
			local outcome = cutscene:textChoicer("* (Move it?)\n", {"Yes", "No"})
			if outcome == 1 then
				cutscene:detachFollowers()
				local snd = Assets.playSound("uty_rumble")
				snd:setLooping(true)
				if Game.world.player.x < self.x and Game.world.player.y < 277 then
					cutscene:slideToSpeed(Game.world.player, Game.world.player.x, 277, 2)
				end
				for _, follower in ipairs(Game.world.followers) do
					if follower.x < self.x and follower.y < 277 then
						cutscene:slideToSpeed(follower, follower.x, 277, 2)
					end
				end
				cutscene:wait(cutscene:slideToSpeed(self, self.x-80, self.y, 2))
				Assets.stopSound("uty_rumble", true)
				Assets.playSound("mart_impact_1")
				Game:setFlag("chem_moved_cabinet", true)
				cutscene:interpolateFollowers()
				cutscene:attachFollowers()
			end
		end)
		return true
	end
end

return SteamworksHermitCabinet
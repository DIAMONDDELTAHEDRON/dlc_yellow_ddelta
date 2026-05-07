local SteamworksChaseVent, super = Class(Event)

function SteamworksChaseVent:init(data)
    super.init(self, data)
	
    properties = data.properties or {}
    self.map = properties["map"]
end

function SteamworksChaseVent:onInteract(chara, dir)
    Game.world:startCutscene(function(cutscene)
        local opinion = cutscene:textChoicer("* (Crawl through the vent?)\n", {"Yes", "No"})
        if opinion == 1 then
			cutscene:fadeOut(0.5, {music = true})
			cutscene:wait(0.5)
			local vent_loop = 4
			while vent_loop > 0 do
				Assets.playSound("step_metal1")
				cutscene:wait(0.5)
				Assets.playSound("step_metal2")
				cutscene:wait(0.5)
				vent_loop = vent_loop - 1
			end
			cutscene:wait(1)
			Assets.playSound("steamworks_13_vent")
			cutscene:wait(0.5)
			Game.world:loadMap(self.map, "vent", "down")
			Game.world.music:stop()
			cutscene:fadeIn(1, {wait = true})
			cutscene:wait(1)
			Game.world.music:play()
        end
    end)
    return true
end

return SteamworksChaseVent
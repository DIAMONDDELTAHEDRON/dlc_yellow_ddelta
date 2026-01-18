function Mod:init()
    print("Loaded "..self.info.name.."!")
	self.dyn_music = {}
	self.dyn_music[1] = Music()
	self.dyn_music[2] = Music()
	self.dyn_music[3] = Music()
	self.dyn_music[4] = Music()
	self.dyn_music[5] = Music()
	self.dyn_music_name = ""
	self.dyn_music_type = 0
    Utils.hook(World, "lightShopTransition", function(orig, self, shop, options)
		local shop_inst = MagicalGlassLib:createLightShop(shop)
		if shop_inst.shop_music and shop_inst.shop_music ~= "" then
			Kristal.modCall("fadeDynMusic")
		end
        orig(self, shop, options)
    end)
    Utils.hook(MagicalGlassLib, "enterLightShop", function(orig, self, shop, options, light)
		local shop_inst = MagicalGlassLib:createLightShop(shop)
		if shop_inst.shop_music and shop_inst.shop_music ~= "" then
			Kristal.modCall("pauseDynMusic")
		end
        orig(self, shop, options)
    end)
	Utils.hook(LightShop, "leaveImmediate", function(orig, self)
		self:remove()
		Game.shop = nil
		MagicalGlassLib.in_light_shop = false
		Game.state = "OVERWORLD"
		Game.fader.alpha = 1
		Game.fader:fadeIn()
		Game.world:setState("GAMEPLAY")

		--self.transition_target.shop = nil
		--Game.world:transitionImmediate(self.transition_target)
		if self.leave_options["menu"] then
			Game:returnToMenu()
		elseif self.leave_options["x"] then
			Game.world:mapTransition(self.leave_options["map"] or Game.world.map.id, self.leave_options["x"], self.leave_options["y"], self.leave_options["facing"])
			Kristal.modCall("checkAndStartDynMusic")
		elseif self.leave_options["marker"] then
			Game.world:mapTransition(self.leave_options["map"] or Game.world.map.id, self.leave_options["marker"], self.leave_options["facing"])
			Kristal.modCall("checkAndStartDynMusic")
		else
			if self.leave_options["facing"] then
				Game.world.player:setFacing(self.leave_options["facing"])
			end
			Kristal.modCall("checkAndStartDynMusic")
		end
    end)
	Utils.hook(World, "onKeyPressed", function(orig, self, key)
		if Kristal.Config["debug"] and Input.ctrl() then
			if key == "m" then
				Kristal.modCall("ctrlMOnDynMusic")
				return
			end
		end
		orig(self, key)
	end)
end

function Mod:postInit(new_file)
	if not Game:getFlag("SHINY") or Game:getFlag("SHINY")["ceroba"] == nil then
		Game:rollShiny("ceroba")
	end
    if not Game:getFlag("snowdin_yellow_kills") then
        Game:setFlag("snowdin_yellow_kills", 0)
    end
    if not Game:getFlag("dunes_kills") then
        Game:setFlag("dunes_kills", 0)
    end
    if not Game:getFlag("steamworks_kills") then
        Game:setFlag("steamworks_kills", 0)
    end
    if Game:getFlag("EMPTIED_STEAMWORKS") then
        MUSIC_PITCHES["snowfall"] = 0.25
        MUSIC_PITCHES["vigorous_terrain"] = 0.25
        MUSIC_PITCHES["steamworks_overworld"] = 0.25
    elseif Game:getFlag("EMPTIED_DUNES") then
        MUSIC_PITCHES["snowfall"] = 0.25
        MUSIC_PITCHES["vigorous_terrain"] = 0.25
        MUSIC_PITCHES["steamworks_overworld"] = 0.5
    elseif Game:getFlag("EMPTIED_SNOWDIN_YELLOW") then
        MUSIC_PITCHES["snowfall"] = 0.25
        MUSIC_PITCHES["vigorous_terrain"] = 0.5
    end
end

-- This dynamic music system kinda sucks ass but fuck it I already wrote it like this
function Mod:onMapMusic(map, music, fade_out, nextmap)
	local dynmusic = map.data and map.data.properties and map.data.properties["dynmusic"] or ""
	local dynmtype = map.data and map.data.properties and map.data.properties["dynmtype"] or 0
	local fade_out = fade_out or false
	local nextmap = nextmap or nil
	if fade_out then
		if nextmap and nextmap.music ~= self.dyn_music_name then
			Mod:fadeAndStopDynMusic()
		end
		return music
	else
		if music == dynmusic and dynmtype ~= 0 then
			if self.dyn_music_type == 0 then
				Mod:startDynMusic(dynmusic, dynmtype)
			else
				if dynmtype ~= self.dyn_music_type then
					Mod:swapDynMusic(dynmtype)
				end
			end
			return ""
		end
	end
	return music
end

function Mod:checkAndStartDynMusic()
	if self.dyn_music_type ~= 0 then
		if not self.dyn_music[self.dyn_music_type]:isPlaying() then
			Mod:startDynMusic(self.dyn_music_name, self.dyn_music_type)
		end
	else
		Game.world.music:resume()
	end
end

function Mod:instantCheckDynMusic(map)
	local map = map or nil
	if map then
		local dynmusic = map.data and map.data.properties and map.data.properties["dynmusic"] or ""
		local dynmtype = map.data and map.data.properties and map.data.properties["dynmtype"] or 0
		if self.dyn_music_name ~= "" and dynmusic ~= self.dyn_music_name then
			Mod:stopDynMusic()
			if dynmtype ~= 0 then
				Mod:startDynMusic(dynmusic, dynmtype)
			end
		end
	end
end

function Mod:fadeDynMusic(time, volume, pause)
	local time = time or 10/30
	local volume = volume or 0
	local pause = pause or true
	if self.dyn_music_type ~= 0 then
		for i, v in ipairs(self.dyn_music) do
			if self.dyn_music[i]:isPlaying() then
				self.dyn_music[i]:fade(volume, time, function() if pause then self.dyn_music[i]:pause() end end)
			end
		end
		return true
	end
	return false
end

function Mod:fadeAndStopDynMusic(time, volume)
	local time = time or 10/30
	local volume = volume or 0
	if self.dyn_music_type ~= 0 then
		for i, v in ipairs(self.dyn_music) do
			if self.dyn_music[i]:isPlaying() then
				self.dyn_music[i]:fade(volume, time, function() self.dyn_music[i]:stop() end)
			end
		end
		self.dyn_music_name = ""
		self.dyn_music_type = 0
		return true
	end
	return false
end

function Mod:pauseDynMusic()
	if self.dyn_music_type ~= 0 then
		for i, v in ipairs(self.dyn_music) do
			if self.dyn_music[i]:isPlaying() then
				self.dyn_music[i]:pause()
			end
		end
		return true
	end
	return false
end

function Mod:resumeDynMusic()
	if self.dyn_music_type ~= 0 then
		for i, v in ipairs(self.dyn_music) do
			if not self.dyn_music[i]:isPlaying() then
				self.dyn_music[i]:resume()
			end
		end
		return true
	end
	return false
end

function Mod:stopDynMusic()
	if self.dyn_music_type ~= 0 then
		for i, v in ipairs(self.dyn_music) do
			if self.dyn_music[i]:isPlaying() then
				self.dyn_music[i]:stop()
			end
		end
		self.dyn_music_name = ""
		self.dyn_music_type = 0
		return true
	end
	return false
end

function Mod:startDynMusic(dynmusic, dynmtype)
	if dynmusic == "oasis" then
		self.dyn_music[1]:play("oasis")
		self.dyn_music[2]:play("oasis_indoors")
	elseif dynmusic == "the_wild_east" then
		self.dyn_music[1]:play("the_wild_east")
		self.dyn_music[2]:play("the_wild_east_barn")
		self.dyn_music[3]:play("the_wild_east_hospital")
		self.dyn_music[4]:play("the_wild_east_house")
		self.dyn_music[5]:play("the_wild_east_jail")
	end
	for i, v in ipairs(self.dyn_music) do
		self.dyn_music[i]:setVolume(0)
	end
	self.dyn_music[dynmtype]:setVolume(1)
	self.dyn_music_name = dynmusic
	self.dyn_music_type = dynmtype
	return true
end

function Mod:swapDynMusic(dynmtype, time)
	local time = time or 10/30
	self.dyn_music[dynmtype]:seek(self.dyn_music[self.dyn_music_type]:tell())
	self.dyn_music[dynmtype]:fade(1, time)
	self.dyn_music[self.dyn_music_type]:fade(0, time)
	self.dyn_music_type = dynmtype
	return true
end

function Mod:ctrlMOnDynMusic()
	if self.dyn_music_type ~= 0 then
		if self.dyn_music[self.dyn_music_type]:isPlaying() then
			Mod:pauseDynMusic()
		else
			Mod:resumeDynMusic()
		end
	else
        if Game.world.music then
            if Game.world.music:isPlaying() then
                Game.world.music:pause()
            else
                Game.world.music:resume()
            end
        end
	end
end

function Mod:load(data, new_file)
    Game.money = Kristal.getLibConfig("magical-glass", "debug") and 1000 or 0
    Game.lw_money = Kristal.getLibConfig("magical-glass", "debug") and 1000 or 0
    MagicalGlassLib:setLightBattleShakingText(true)
    MagicalGlassLib:setCellCallsRearrangement(true)
end

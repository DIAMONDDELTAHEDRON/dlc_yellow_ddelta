local SteamworksManta, super = Class(Character)

function SteamworksManta:init(data)
    super.init(self, "steamworks_manta", data.x, data.y)
	self:setOrigin(0.5, 0.5)
	self.dir = "right"
	self.checkpoint_collider = nil
	self.sail_sound = nil
	self.moving = false
	self.riding_manta = false
	self.arrows = MantaArrows(self.x, self.y)
	self.player_speed_x = 0
	self.player_speed_y = 0
	self.is_manta = true
	Game:setFlag("manta_glass", false)
	Game.world:addChild(self.arrows)
end

function SteamworksManta:onAdd(parent)
	super.onAdd(self, parent)
	self:setLayer(0.21)
end

function SteamworksManta:postLoad(parent)
	super.onLoad(self)
	if Game:getFlag("manta_riding", false) then
		if not Game.world.map:getMarker(Game:getFlag("manta_marker", nil)) then
			self.x = Game:getFlag("manta_tx", nil)
			self.y = Game:getFlag("manta_ty", nil)
		else
			local x, y = Game.world.map:getMarker(Game:getFlag("manta_marker", nil))
			self.x = x
			self.y = y
		end
		self.riding_manta = true
		Game.world:detachFollowers()
		Game.world.camera.target = self
		local dir = Game:getFlag("manta_dir")
		if dir == "right" then
			self.dir = "right"
			self.physics.speed_x = 8
			self.checkpoint_collider = LineCollider(self,44,44,44+20,44)
		end
		if dir == "left" then
			self.dir = "left"
			self.physics.speed_x = -8
			self.checkpoint_collider = LineCollider(self,44,44,44-20,44)
		end
		if dir == "up" then
			self.dir = "up"
			self.physics.speed_y = -8
			self.checkpoint_collider = LineCollider(self,44,44,44,44-20)
		end
		if dir == "down" then
			self.dir = "down"
			self.physics.speed_y = 8
			self.checkpoint_collider = LineCollider(self,44,44,44,44+20)
		end
		if self.riding_manta then
			local index = 1
			for _,follower in ipairs(Game.world.followers) do
				local npcx, npcy = self:getFollowerPos(self.dir, index, #Game.party)
				follower.x = npcx
				follower.y = npcy
				follower:setFacing(self.dir)
				index = index + 1
			end
			local plx, ply = self:getPlayerPos(self.dir)
			Game.world.player.x = plx
			Game.world.player.y = ply
			Game.world.player:setFacing(self.dir)
			self.player_speed_x = self.physics.speed_x
			self.player_speed_y = self.physics.speed_y
		end
		Game:setFlag("manta_dir", self.dir)
		self.sprite:setAnimation("move/"..self.dir)
		Game:setFlag("manta_spawn_id", nil)
		self.arrows:displayArrows(false)
		self.moving = true
	else
		for _,checkpoint in ipairs(Game.world.map:getEvents("stw_manta_checkpoint")) do
			if checkpoint.spawn_id then
				if Game:getFlag("manta_spawn_id", nil) == checkpoint.spawn_id then
					print("spawning manta somewhere else")
					self.x = checkpoint.x
					self.y = checkpoint.y
					self.dir = checkpoint.spawn_dir
					checkpoint.active = true
				end
			end
		end
		self.sprite:setAnimation("idle/"..self.dir)
	end
end

function SteamworksManta:getPlayerPos(dir)
	local plx = self.x
	local ply = self.y
	if dir == "right" then
		plx = self.x + 20
		ply = self.y
	end
	if dir == "left" then
		plx = self.x - 20
		ply = self.y
	end
	if dir == "up" then
		plx = self.x
		ply = self.y - 10
	end
	if dir == "down" then
		plx = self.x
		ply = self.y + 40
	end
	return plx, ply
end

function SteamworksManta:getFollowerPos(dir, index, amt)
	local npcx = self.x
	local npcy = self.y
	if amt < 3 then
		if dir == "right" then
			npcx = self.x - 10
			npcy = self.y
		end
		if dir == "left" then
			npcx = self.x + 10
			npcy = self.y
		end
		if dir == "up" then
			npcx = self.x
			npcy = self.y
		end
		if dir == "down" then
			npcx = self.x
			npcy = self.y + 30
		end
	else
		if index == 1 then
			if dir == "right" then
				npcx = self.x
				npcy = self.y - 20
			end
			if dir == "left" then
				npcx = self.x
				npcy = self.y - 20
			end
			if dir == "up" then
				npcx = self.x - 20
				npcy = self.y
			end
			if dir == "down" then
				npcx = self.x - 20
				npcy = self.y + 30
			end
		end
		if index == 2 then			
			if dir == "right" then
				npcx = self.x
				npcy = self.y + 20
			end
			if dir == "left" then
				npcx = self.x
				npcy = self.y + 20
			end
			if dir == "up" then
				npcx = self.x + 20
				npcy = self.y
			end
			if dir == "down" then
				npcx = self.x + 20
				npcy = self.y + 30
			end
		end
	end
	return npcx, npcy
end

function SteamworksManta:getOppositeDir()
	if self.dir == "up" then
		return "down"
	end
	if self.dir == "down" then
		return "up"
	end	
	if self.dir == "left" then
		return "right"
	end
	if self.dir == "right" then
		return "left"
	end
end

function SteamworksManta:onInteract(chara, dir)
    Game.world:startCutscene(function(cutscene)
        local opinion = cutscene:textChoicer("* (Take a ride?)\n", {"Yes", "No"})
        if opinion == 1 then
			Assets.playSound("manta_startup")
			local leader = Game.world.player
			cutscene:detachCamera()
			Game.world.camera.target = self
			local camattach = cutscene:attachCamera()
			cutscene:detachFollowers()
			Game:setFlag("manta_glass", true)
			local plx, ply = self:getPlayerPos(self.dir)
			cutscene:wait(cutscene:walkToSpeed(leader, plx, ply, 6, self.dir))
			for i = 2, #Game.party do
				local member = Game.party[i].id
				local npcx, npcy = self:getFollowerPos(self.dir, i-1, #Game.party)
				cutscene:wait(cutscene:walkTo(cutscene:getCharacter(member), npcx, npcy, 0.5, self.dir))
			end
			for _,checkpoint in ipairs(self.world.map:getEvents("stw_manta_checkpoint")) do
				if self:collidesWith(checkpoint) then
					self:setProperties(checkpoint.up_free, checkpoint.down_free, checkpoint.left_free, checkpoint.right_free, checkpoint.can_dock, checkpoint.dock_x, checkpoint.dock_y)
					self.arrows:setProperties(checkpoint.up_free, checkpoint.down_free, checkpoint.left_free, checkpoint.right_free, checkpoint.can_dock)
				end
			end
			Game:setFlag("manta_glass", false)
			cutscene:wait(camattach)
			Game:setFlag("manta_riding", true)
			Game:setFlag("manta_dir", self.dir)
			self.riding_manta = true
			self.arrows:displayArrows(true)
        end
    end)
    return true
end

function SteamworksManta:update()
	super.update(self)
	if self.riding_manta then
		Game.lock_movement = true
		self.arrows.x = self.x
		self.arrows.y = self.y
		if self.arrows:canMove() then
			if Input.pressed("up") then
				self:tryMove("up", true)
			elseif Input.pressed("down") then
				self:tryMove("down", true)
			elseif Input.pressed("left") then
				self:tryMove("left", true)
			elseif Input.pressed("right") then
				self:tryMove("right", true)
			end
		end
		Game.world.player.x = Game.world.player.x + self.player_speed_x*DTMULT
		Game.world.player.y = Game.world.player.y + self.player_speed_y*DTMULT
		if #Game.world.followers >= 1 then
			for _,follower in ipairs(Game.world.followers) do
				follower.x = follower.x + self.player_speed_x*DTMULT
				follower.y = follower.y + self.player_speed_y*DTMULT
			end
		end
	end
	if self.checkpoint_collider then
		for _,checkpoint in ipairs(self.world.map:getEvents("stw_manta_checkpoint")) do
			if self.checkpoint_collider:collidesWith(checkpoint) then
				local chx = checkpoint.x or nil
				local chy = checkpoint.y or nil
				if self.x < chx+8*DTMULT and self.x > chx - 8*DTMULT and self.y < chy+8*DTMULT and self.y > chy-8*DTMULT then
					if not checkpoint.active then
						self:stopMoving(chx, chy)
						checkpoint.active = true
						Game:setFlag("manta_spawn_id", checkpoint.spawn_id)
					end
				end
				self:setProperties(checkpoint.up_free, checkpoint.down_free, checkpoint.left_free, checkpoint.right_free, checkpoint.can_dock, checkpoint.dock_x, checkpoint.dock_y)
				self.arrows:setProperties(checkpoint.up_free, checkpoint.down_free, checkpoint.left_free, checkpoint.right_free, checkpoint.can_dock)
			else
				if checkpoint.active then
					checkpoint.active = false
				end
			end
		end
		for _,warp in ipairs(self.world.map:getEvents("transition_manta")) do
			if self:collidesWith(warp) then
				warp:doTransition()
			end
		end
	end
	if self:isStopped() then
		if self.checkpoint_collider then
			self.checkpoint_collider = nil
		end
	end
end

function SteamworksManta:tryMove(dir, confirm_snd)
	if self.can_dock == dir then
		self.riding_manta = false
		self.arrows:displayArrows(false)
		Game.world:startCutscene(function(cutscene)
			local leader = Game.world.player
			cutscene:detachCamera()
			local camattach = cutscene:panTo(self.dock_x, self.dock_y, 0.5)
			cutscene:wait(cutscene:walkToSpeed(leader, self.dock_x, self.dock_y, 6, self.dir))
			for i = 2, #Game.party do
				local member = Game.party[i].id
				cutscene:wait(cutscene:walkToSpeed(cutscene:getCharacter(member), self.dock_x, self.dock_y, 6, self.dir))
			end
			cutscene:wait(camattach)
			cutscene:interpolateFollowers()
			Game.world.camera.target = leader
			cutscene:wait(cutscene:attachCamera(0.1))
			Game.lock_movement = false
			Game:setFlag("manta_riding", false)
			Game:setFlag("manta_dir", nil)
			cutscene:attachFollowersImmediate()
		end)
	elseif (dir == "up" and self.up_free) or (dir == "down" and self.down_free) or (dir == "left" and self.left_free) or (dir == "right" and self.right_free) then
		local sel_arrow = 1
		if dir == "up" then sel_arrow = 1 end
		if dir == "down" then sel_arrow = 2 end
		if dir == "left" then sel_arrow = 3 end
		if dir == "right" then sel_arrow = 4 end
		if confirm_snd then
			Assets.playSound("ui_select")
		end
		self.arrows:selectArrow(sel_arrow)
		self:moveInDirection(dir)
	else
		if confirm_snd then
			Assets.playSound("uty_cant_select")
		end
	end
end

function SteamworksManta:setProperties(up, down, left, right, dock_dir, dock_x, dock_y, dock_flag, spawn_id)
	self.up_free = up or false
	self.down_free = down or false
	self.left_free = left or false
	self.right_free = right or false
	self.can_dock = dock_dir or nil
	self.dock_x = dock_x or self.x
	self.dock_y = dock_y or self.y
end

function SteamworksManta:stopMoving(x, y)
	local x, y = x, y
	Assets.stopSound("manta_sail", true)
	self.sprite:setAnimation("idle/"..self.dir)
	Assets.playSound("manta_stop_go")
	if self.riding_manta then
		self.player_speed_x = 0
		self.player_speed_y = 0
	end
	self.physics.speed_x = 0
	self.physics.speed_y = 0
	if x ~= 0 then
		self.x = x
	end
	if y ~= 0 then
		self.y = y
	end
	self.moving = false
	if self.riding_manta then
		self.arrows:displayArrows(true)
	end
end

function SteamworksManta:isMoving()
	if self.moving then
		return true
	end
	return false
end

function SteamworksManta:isStopped()
	if not self.moving then
		return true
	end
	return false
end

function SteamworksManta:moveInDirection(dir)
	local dir = dir
	if dir then
		if dir == "right" then
			self.dir = "right"
			self.physics.speed_x = 8
			self.checkpoint_collider = LineCollider(self,44,44,44+20,44)
		end
		if dir == "left" then
			self.dir = "left"
			self.physics.speed_x = -8
			self.checkpoint_collider = LineCollider(self,44,44,44-20,44)
		end
		if dir == "up" then
			self.dir = "up"
			self.physics.speed_y = -8
			self.checkpoint_collider = LineCollider(self,44,44,44,44-20)
		end
		if dir == "down" then
			self.dir = "down"
			self.physics.speed_y = 8
			self.checkpoint_collider = LineCollider(self,44,44,44,44+20)
		end
		if self.riding_manta then
			local index = 1
			for _,follower in ipairs(Game.world.followers) do
				local npcx, npcy = self:getFollowerPos(self.dir, index, #Game.party)
				follower.x = npcx
				follower.y = npcy
				follower:setFacing(self.dir)
				index = index + 1
			end
			local plx, ply = self:getPlayerPos(self.dir)
			Game.world.player.x = plx
			Game.world.player.y = ply
			Game.world.player:setFacing(self.dir)
			self.player_speed_x = self.physics.speed_x
			self.player_speed_y = self.physics.speed_y
		end
		Game:setFlag("manta_dir", self.dir)
		self.sprite:setAnimation("move/"..self.dir)
		local sail_sound = Assets.playSound("manta_sail")
		sail_sound:setLooping(true)
		Assets.playSound("manta_stop_go")
		Game:setFlag("manta_spawn_id", nil)
		self.arrows:displayArrows(false)
		self.moving = true
	end
end

function SteamworksManta:draw()
    super.draw(self)
    if DEBUG_RENDER and self.checkpoint_collider then
        self.checkpoint_collider:draw(0, 0, 1, 1)
    end
end

return SteamworksManta
local Player, super = HookSystem.hookScript(Player)

function Player:init(chara, x, y)
    super.init(self, chara, x, y)
	self.on_stairs = false
end

function Player:getBaseStairsSpeed()
    return Game:isLight() and 4 or 2.5
end

function Player:getCurrentStairsSpeed(running)
    local speed = self:getBaseStairsSpeed()
    if running then
        if self.run_timer > 60 then
            speed = speed + (Game:isLight() and 6 or 5)
        elseif self.run_timer > 10 then
            speed = speed + 4
        else
            speed = speed + 2
        end
    end
    return speed
end

function Player:handleMovement()
	if self.on_stairs then
		local walk_x = 0
		local walk_y = 0
		local stairs_y = 0

		if Input.down("left") then
			walk_x = walk_x - 1
			stairs_y = stairs_y + 1
		elseif Input.down("right") then
			walk_x = walk_x + 1
			stairs_y = stairs_y - 1
		end

		if Input.down("up") and not Input.down("right") then
			walk_y = walk_y - 1
		elseif Input.down("down") and not Input.down("left") then
			walk_y = walk_y + 1
		end

		self.moving_x = walk_x
		self.moving_y = walk_y + stairs_y

		local running = (Input.down("cancel") or self.force_run) and not self.force_walk
		if Kristal.Config["autoRun"] and not self.force_run and not self.force_walk then
			running = not running
		end

		if self.force_run and not self.force_walk then
			self.run_timer = 200
		end

		local speed = self:getCurrentSpeed(running)

		self:move(walk_x, walk_y, speed * DTMULT)

		local stairs_speed = self:getCurrentStairsSpeed(running)
		
		self:move(0, stairs_y, stairs_speed * DTMULT, true)

		if not running or self.last_collided_x or self.last_collided_y then
			self.run_timer = 0
		elseif running then
			if walk_x ~= 0 or walk_y ~= 0 or stairs_y ~= 0 then
				self.run_timer = self.run_timer + DTMULT
				self.run_timer_grace = 0
			else
				-- Dont reset running until 2 frames after you release the movement keys
				if self.run_timer_grace >= 2 then
					self.run_timer = 0
				end
				self.run_timer_grace = self.run_timer_grace + DTMULT
			end
		end
	else
		super.handleMovement(self)
	end
end

return Player
local CerobaBeam, super = Class(LightBullet)

function CerobaBeam:init(x, y, rot, dur, wid)
    super.init(self, x, y)

    self.damage = 3
    self.destroy_on_hit = false
    self.rotation_num = rot or 0
    self.duration = dur or 0.5

	self.rotation = math.rad(self.rotation_num)
	
	self.beam_stage = 0
	self.beam_width = wid or 40
	self.beam_width_cur = 0
	self.beam_width_inc = self.beam_width / (0.4 * 30)
	self.beam_width_fluc = 4
	self.beam_grow = true
	self.beam_color = {1,1,1}
	
	self.collider = nil
    Assets.playSound("kamehamehacharge")
end

function CerobaBeam:onDamage(soul)
    if soul.inv_timer > 0 or not self.collider then else
        soul.inv_timer = self.inv_timer
        Assets.playSound("ceroba_hurt_red")
        local alive_battlers = Utils.filter(Game.battle.party, function(battler) return not battler.is_down end)
        for _,battler in ipairs(alive_battlers) do
            battler:hurt(3, true)
			Assets.stopSound("hurt")
			if battler.chara:getHealth() <= 0 then
				battler.chara:setHealth(0)
				local zero_health = (battler.chara:getBaseStat("health") or 0) + battler.chara:getEquipmentBonus("health")
				battler.chara:setStatBuff("health", -zero_health)
			else
				battler.chara:addStatBuff("health", -3)
			end
        end
    end
    return {}
end

function CerobaBeam:update()
    super.update(self)
	if self.beam_stage == 0 then
		self.beam_width_cur = self.beam_width_cur + self.beam_width_inc * DTMULT
		if self.beam_width_cur >= self.beam_width then
			self.beam_width_cur = self.beam_width
			self.beam_stage = 1
			self.beam_color = {230/255, 50/255, 50/255}
			self.collider = Hitbox(self,-self.x,0,1000,0)
			Assets.stopSound("kamehamehacharge")
			Assets.playSound("kamehamehablast")
		end
	elseif self.beam_stage == 1 then
		if self.beam_grow == true then
			if self.beam_width_cur < self.beam_width + self.beam_width_fluc then
				self.beam_width_cur = self.beam_width_cur + 2 * DTMULT
			else
				self.beam_grow = false
			end
		else
			if self.beam_width_cur > self.beam_width - self.beam_width_fluc then
				self.beam_width_cur = self.beam_width_cur - 2 * DTMULT
			else
				self.beam_grow = true
			end
		end
		if self.duration > 0 then
			self.duration = self.duration - DT
		else
			self.beam_stage = 2
		end
	elseif self.beam_stage == 2 then
		if self.beam_width_cur > 0 then
			self.beam_width_cur = self.beam_width_cur - 8 * DTMULT
		else
			self:remove()
		end
	end
	if self.collider then
		self.collider.y = -(self.beam_width_cur/4)
		self.collider.height = self.beam_width_cur/2
	end 
end

function CerobaBeam:draw()
    Draw.setColor(self.beam_color)
	love.graphics.setLineWidth(self.beam_width_cur/2)
	love.graphics.line(-1000, 0, 1000, 0)
    super.draw(self)
end

return CerobaBeam
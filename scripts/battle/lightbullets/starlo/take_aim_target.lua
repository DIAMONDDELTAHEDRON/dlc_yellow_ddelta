local TakeAimTarget, super = Class(LightBullet)

function TakeAimTarget:init(x, y)
    super.init(self, x, y, nil)
	self:setScale(1)

	self.collider = nil

	self.target_radius_max = 40
	self.target_radius_current = self.target_radius_max
	self.target_radius_deg = 90
	self.target_draw_alpha = 0
end

function TakeAimTarget:update()
    super.update(self)

	if self.target_radius_deg > 0 then
		self.target_radius_deg = self.target_radius_deg - 4 * DTMULT
	else
		self.wave:spawnBullet("starlo/take_aim_shot", self.x, self.y)
		self:remove()
	end
	self.target_radius_current = math.sin(math.rad(self.target_radius_deg))
	if self.target_draw_alpha < 1 then
		self.target_draw_alpha = self.target_draw_alpha + 0.25 * DTMULT
	end
end

function TakeAimTarget:draw()
    super.draw(self)

	Draw.setColor(1, 0, 0, self.target_draw_alpha)
	love.graphics.circle("fill", 0, 0, 14)
	Draw.setColor(0, 0, 0, self.target_draw_alpha)
	love.graphics.circle("fill", 0, 0, 12)
	Draw.setColor(1, 0, 0, self.target_draw_alpha)
	love.graphics.circle("fill", 0, 0, 3)
	Draw.setColor(1, 1, 1, self.target_draw_alpha)
	love.graphics.draw(Assets.getTexture("battle/bullets/starlo/take_aim_circle"), 0, 0, 0, self.target_radius_current, self.target_radius_current, 43, 43)
	Draw.setColor(1, 1, 1, 1)
end

return TakeAimTarget
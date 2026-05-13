local StarloLassoSoul, super = Class(LightSoul)

function StarloLassoSoul:init(x, y, color)
    super.init(self, x, y)

    self.color = color or {1, 0, 0}
	self.rope_tex = Assets.getTexture("player/rope")
	self.roped_tex = Assets.getTexture("player/roped")
	self.rope_damaged = false
	self.stretch_multiplier = 0
	self.rope_angle = 0
	self.rope_strain_noloop = false
	self.rope_overlay_alpha = 0
	self.rope_soul_overlay_alpha = 2
	self.rope_x = 320
	self.rope_y = 320
end

function StarloLassoSoul:update()
	if self.rope_damaged then
		self.rope_damaged = false
		self.rope_overlay_alpha = 1.5
		Assets.playSound("starlo_rope_shot")
	end
	local soul_distance = MathUtils.dist(self.rope_x, self.rope_y, self.x, self.y)
    if soul_distance > 28 and not self.rope_strain_noloop then
		Assets.playSound("starlo_rope_strain")
		self.rope_strain_noloop = true
	elseif self.rope_strain_noloop and soul_distance < 20 then
		self.rope_strain_noloop = false
	end
	self.rope_overlay_alpha = MathUtils.lerp(self.rope_overlay_alpha, 0, 0.15 * DTMULT)
	self.rope_soul_overlay_alpha = MathUtils.lerp(self.rope_soul_overlay_alpha, 0, 0.2 * DTMULT)
	if self.rope_soul_overlay_alpha < 0.1 then
		self.rope_soul_overlay_alpha = 0
	end
	super.update(self)	
	local box = Game.battle.arena
	local distance = MathUtils.dist(self.x, self.y, box.x, box.y)
	local soul_speed = 3
	if self.moving_x ~= 0 and self.moving_y ~= 0 then
		soul_speed = 4.24
	end
	local lerp_amount = soul_speed / 42
	self.x = MathUtils.lerp(self.x, box.x, lerp_amount * DTMULT)
	self.y = MathUtils.lerp(self.y, box.y, lerp_amount * DTMULT)
	self.stretch_multiplier = MathUtils.dist(box.x, box.y, self.x, self.y) / 3
	self.rope_angle = MathUtils.angle(box.x, box.y, self.x, self.y)
end

function StarloLassoSoul:draw()
	love.graphics.push()
	love.graphics.origin()
	Draw.setColor(216/255, 112/255, 43/255)
	Draw.draw(self.rope_tex, self.rope_x, self.rope_y, self.rope_angle, self.stretch_multiplier, 1, 0, 1)
	Draw.setColor(1, 1, 1, self.rope_overlay_alpha)
	Draw.draw(self.rope_tex, self.rope_x, self.rope_y, self.rope_angle, self.stretch_multiplier, 1, 0, 1)
	Draw.setColor(1, 1, 1, 1)
	love.graphics.pop()
    local last_shader = love.graphics.getShader()
	if self.rope_soul_overlay_alpha > 0 then
        local shader = Kristal.Shaders["AddColor"]
        love.graphics.setShader(shader)
        shader:send("inputcolor", {1, 1, 1})
        shader:send("amount", self.rope_soul_overlay_alpha)
	end
    super.draw(self)
    love.graphics.setShader(last_shader)
	Draw.setColor(1, 1, 1, 1)
	Draw.draw(self.roped_tex, 0, 0, 0, 1, 1, 8, 8)
end

return StarloLassoSoul
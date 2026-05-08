local StarloBattleBackground, super = Class(Object)

function StarloBattleBackground:init()
    super.init(self, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

	self:setParallax(0, 0)
    self.layer = LIGHT_BATTLE_LAYERS["background"]
	self.debug_select = false
	self.bg_shader = Assets.getShader("starlobgwave")
	self.bg_alpha = 0
	self.bg_tumble_timer = 0
end

function StarloBattleBackground:update()
    super.update(self)
	local alpha_target = ((1 + math.sin(Kristal.getTime())) * 0.3) + 0.4
	if Game.battle.encounter.bg_state == 1 then
		if self.bg_alpha < alpha_target then
			self.bg_alpha = self.bg_alpha + 0.05 * DTMULT
		else
			Game.battle.encounter.bg_state = 2
		end
	elseif Game.battle.encounter.bg_state == 2 then
		self.bg_alpha = alpha_target
	else
		return
	end
    self.bg_tumble_timer = self.bg_tumble_timer + DT
    if self.bg_tumble_timer >= 5 then
        self.bg_tumble_timer = 0
		local tumble_type = love.math.random(1, 3)
		if tumble_type == 1 then
			local tumble = StarloBGTumble("battle/starlotumble_1", 660, Utils.random(210, 230))
			tumble.sin_timer = 0.15
			tumble.xspeed = 0.5
			tumble.rotation_speed = 0.5
			tumble:setLayer(LIGHT_BATTLE_LAYERS["above_battlers"])
			Game.battle:addChild(tumble)
		elseif tumble_type == 2 then
			local tumble = StarloBGTumble("battle/starlotumble_2", 660, Utils.random(180, 210))
			tumble.sin_timer = 0.18
			tumble.xspeed = 1
			tumble.rotation_speed = 1
			tumble.rotation = math.rad(180)
			tumble:setLayer(LIGHT_BATTLE_LAYERS["below_battlers"]-1)
			Game.battle:addChild(tumble)
		elseif tumble_type == 3 then
			local tumble = StarloBGTumble("battle/starlotumble_3", 660, Utils.random(160, 190))
			tumble.sin_timer = 0.21
			tumble.xspeed = 2
			tumble.rotation_speed = 1.5
			tumble.rotation = math.rad(180)
			tumble:setLayer(LIGHT_BATTLE_LAYERS["below_battlers"]-2)
			Game.battle:addChild(tumble)
		end
    end
end

function StarloBattleBackground:draw()
    love.graphics.setColor(1, 1, 1, self.bg_alpha)
    local last_shader = love.graphics.getShader()
	love.graphics.setShader(self.bg_shader)
	self.bg_shader:send("wave_sine", Kristal.getTime() * 85)
	self.bg_shader:send("wave_mag", 5)
	self.bg_shader:send("wave_height", 30)
	self.bg_shader:send("texsize", {SCREEN_WIDTH, SCREEN_HEIGHT})
    love.graphics.draw(Assets.getTexture("battle/starlo_bg"), -20, 10)
    love.graphics.setShader(last_shader)
    Draw.setColor(1, 1, 1)
    super.draw(self)
end

return StarloBattleBackground
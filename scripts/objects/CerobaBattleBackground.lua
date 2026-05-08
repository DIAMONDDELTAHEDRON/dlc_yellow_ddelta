local CerobaBattleBackground, super = Class(Object)

function CerobaBattleBackground:init()
    super.init(self, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

	self:setParallax(0, 0)
    self.layer = LIGHT_BATTLE_LAYERS["background"]
	self.debug_select = false
	self.diamond_w = 60
	self.diamond_w_cur = 0
	self.diamond_h = 140
	self.diamond_x = {640 - self.diamond_w - 20, self.diamond_w + 20}
	self.diamond_y = 120
	self.diamond_y_orig = 115
	self.diamond_y_shift = 30
	self.diamond_sin = 0
	self.diamond_alpha = 1
    self.ember_small = Assets.getTexture("ui/lightbattle/backgrounds/ceroba_background_particle_small")
    self.ember_medium = Assets.getTexture("ui/lightbattle/backgrounds/ceroba_background_particle_medium")
    self.ember_large = Assets.getTexture("ui/lightbattle/backgrounds/spr_ceroba_background_particle_large")
	self.ember_particles = {}
	for i = 1, 3 do
		local ember_x = Utils.random() * SCREEN_WIDTH
		local ember_y = Utils.random() * 250
		local ember_speed = Utils.random(0.8, 1.1)
		local ember_dir = math.rad(love.math.random(75, 105))
		table.insert(self.ember_particles, {sprite = self.ember_small, color = {228/255, 69/255, 101/255}, x = ember_x, y = ember_y, speed = ember_speed, direction = ember_dir, lifetime = 0, maxlife = 300})
	end
	for i = 1, 2 do
		local ember_x = Utils.random() * SCREEN_WIDTH
		local ember_y = Utils.random() * 250
		local ember_speed = Utils.random(0.6, 0.9)
		local ember_dir = math.rad(love.math.random(75, 105))
		table.insert(self.ember_particles, {sprite = self.ember_medium, color = {228/255, 69/255, 101/255}, x = ember_x, y = ember_y, speed = ember_speed, direction = ember_dir, lifetime = 0, maxlife = 325})
	end
	for i = 1, 1 do
		local ember_x = Utils.random() * SCREEN_WIDTH
		local ember_y = Utils.random() * 250
		local ember_speed = Utils.random(0.4, 0.7)
		local ember_dir = math.rad(love.math.random(75, 105))
		table.insert(self.ember_particles, {sprite = self.ember_large, color = {228/255, 69/255, 101/255}, x = ember_x, y = ember_y, speed = ember_speed, direction = ember_dir, lifetime = 0, maxlife = 350})
	end
	self.part_timer = 0
end

function CerobaBattleBackground:update()
    super.update(self)
    local to_remove = {}
    for _,particle in ipairs(self.ember_particles) do
		particle.x = particle.x - (particle.speed * math.cos(particle.direction)) * DTMULT
		particle.y = particle.y - (particle.speed * math.sin(particle.direction)) * DTMULT
		particle.lifetime = particle.lifetime + DTMULT
		if particle.lifetime >= 0 then
			particle.color = Utils.mergeColor({228/255, 69/255, 101/255, 1}, {228/255, 69/255, 101/255, 0}, particle.lifetime/particle.maxlife)
		end
		if particle.lifetime >= particle.maxlife then
			table.insert(to_remove, particle)
		end
    end

    for _,particle in ipairs(to_remove) do
        Utils.removeFromTable(self.ember_particles, particle)
    end

	self.part_timer = self.part_timer + DTMULT
	if self.part_timer >= 1 then
		self.part_timer = 0
		if love.math.random(15) == 1 then
			local ember_x = Utils.random() * SCREEN_WIDTH
			local ember_y = 250
			local ember_speed = Utils.random(0.8, 1.1)
			local ember_dir = math.rad(love.math.random(75, 105))
			table.insert(self.ember_particles, {sprite = self.ember_small, color = {228/255, 69/255, 101/255}, x = ember_x, y = ember_y, speed = ember_speed, direction = ember_dir, lifetime = 0, maxlife = 300})
		end
		if love.math.random(45) == 1 then
			local ember_x = Utils.random() * SCREEN_WIDTH
			local ember_y = 250
			local ember_speed = Utils.random(0.6, 0.9)
			local ember_dir = math.rad(love.math.random(75, 105))
			table.insert(self.ember_particles, {sprite = self.ember_medium, color = {228/255, 69/255, 101/255}, x = ember_x, y = ember_y, speed = ember_speed, direction = ember_dir, lifetime = 0, maxlife = 325})
		end
		if love.math.random(125) == 1 then
			local ember_x = Utils.random() * SCREEN_WIDTH
			local ember_y = 250
			local ember_speed = Utils.random(0.4, 0.7)
			local ember_dir = math.rad(love.math.random(75, 105))
			table.insert(self.ember_particles, {sprite = self.ember_large, color = {228/255, 69/255, 101/255}, x = ember_x, y = ember_y, speed = ember_speed, direction = ember_dir, lifetime = 0, maxlife = 350})
		end
	end
	if self.diamond_w_cur >= self.diamond_w then
		self.diamond_w_cur = 0
	end
	self.diamond_w_cur = self.diamond_w_cur + 0.5 * DTMULT
	self.diamond_sin = self.diamond_sin + DTMULT
	if self.diamond_sin >= 360 then
		self.diamond_sin = self.diamond_sin - 360
	end
	self.diamond_y = self.diamond_y_orig + math.sin(math.rad(self.diamond_sin)) * self.diamond_y_shift
end

function CerobaBattleBackground:draw()
	for _,particle in ipairs(self.ember_particles) do
		Draw.setColor(particle.color)
		Draw.draw(particle.sprite, particle.x, particle.y, 0, 2, 2)
	end
    Draw.setColor(73/255, 24/255, 31/255)
    love.graphics.rectangle("fill", 0, 230, 640, 106)
    Draw.setColor(157/255, 23/255, 50/255)
    love.graphics.rectangle("fill", 0, 242, 640, 88)
    Draw.setColor(216/255, 31/255, 68/255)
    love.graphics.rectangle("fill", 0, 268, 640, 56)
    Draw.setColor(228/255, 69/255, 101/255)
    love.graphics.rectangle("fill", 0, 310, 640, 14)
	Draw.setColor(216/255, 31/255, 68/255, self.diamond_alpha)
	love.graphics.setLineWidth(1)
	if self.diamond_alpha > 0 then
		for i = 1, 2 do
			local diamond_x_l = self.diamond_x[i] - self.diamond_w - self.diamond_w_cur / 3
			local diamond_x_r = self.diamond_x[i] + self.diamond_w + self.diamond_w_cur / 3
			if self.diamond_w_cur > self.diamond_w / 2 then
				diamond_x_l = self.diamond_x[i] - self.diamond_w - (self.diamond_w / 3 - self.diamond_w_cur / 3)
				diamond_x_r = self.diamond_x[i] + self.diamond_w + (self.diamond_w / 3 - self.diamond_w_cur / 3)
			end
			love.graphics.line(diamond_x_l, self.diamond_y, self.diamond_x[i], self.diamond_y - self.diamond_h / 2)
			love.graphics.line(self.diamond_x[i], self.diamond_y - self.diamond_h / 2, diamond_x_r, self.diamond_y)
			love.graphics.line(diamond_x_r, self.diamond_y, self.diamond_x[i], self.diamond_y + self.diamond_h / 2)
			love.graphics.line(self.diamond_x[i], self.diamond_y + self.diamond_h / 2, diamond_x_l, self.diamond_y)
			local vert_line_1_x = self.diamond_x[i] - self.diamond_w + self.diamond_w_cur
			love.graphics.line(self.diamond_x[i], self.diamond_y - self.diamond_h / 2, vert_line_1_x, self.diamond_y)
			love.graphics.line(vert_line_1_x, self.diamond_y, self.diamond_x[i], self.diamond_y + self.diamond_h / 2)
			local vert_line_2_x = self.diamond_x[i] + self.diamond_w_cur
			love.graphics.line(self.diamond_x[i], self.diamond_y - self.diamond_h / 2, vert_line_2_x, self.diamond_y)
			love.graphics.line(vert_line_2_x, self.diamond_y, self.diamond_x[i], self.diamond_y + self.diamond_h / 2)
			love.graphics.line(diamond_x_l, self.diamond_y, vert_line_1_x, self.diamond_y)
			love.graphics.line(vert_line_1_x, self.diamond_y, vert_line_2_x, self.diamond_y)
			love.graphics.line(vert_line_2_x, self.diamond_y, diamond_x_r, self.diamond_y)
		end
	end
    Draw.setColor(1, 1, 1)
    super.draw(self)
end

return CerobaBattleBackground
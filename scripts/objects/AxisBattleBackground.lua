---@class AxisBattleBackground : Object
---@overload fun(x?: number, y?:number)
local AxisBattleBackground, super = Class(Object)

function AxisBattleBackground:init(x,y)
    super.init(self,x,y)
	self:setParallax(0, 0)
    self.layer = LIGHT_BATTLE_LAYERS["background"]
	self.debug_select = false
	self.number_timer = 0
	self.number_timer_max = Utils.random(25, 45, 0.5)

	self.number_timer_two = 0
	self.number_timer_two_max = Utils.random(25, 45, 0.5)

	self.bg_numbers = {}
	self.number_particles = {}

	self.bg_speed = 4
    self.timer = self:addChild(Timer())

	for a = SCREEN_HEIGHT, 0, -36 do
		for i = SCREEN_WIDTH+15, 0, -36 do
			if Utils.pick({1, 2, 3}) ~= 1 then
				local number_col = Utils.pick({{0.0745098039215686, 0.2470588235294118, 0.1019607843137255, 0.22},
				{0.1686274509803922, 0.5686274509803922, 0.2352941176470588, 0.22}})
				table.insert(self.bg_numbers, {x = i, y = a, color = number_col, index = Utils.pick({1, 2})})
			end
		end
	end

    self.timer:every((36/self.bg_speed)/30, function()
		for i = SCREEN_WIDTH+15, 0, -36 do
			if Utils.pick({1, 2, 3}) ~= 1 then
				local number_col = Utils.pick({{0.0745098039215686, 0.2470588235294118, 0.1019607843137255, 0.22},
				{0.1686274509803922, 0.5686274509803922, 0.2352941176470588, 0.22}})
				table.insert(self.bg_numbers, {x = i, y = SCREEN_HEIGHT, color = number_col, index = Utils.pick({1, 2})})
			end
		end
	end)

    self.number_image = Assets.getFrames("ui/lightbattle/backgrounds/battle_axis_number")
end

function AxisBattleBackground:update()
    super.update(self)
	self.number_timer = self.number_timer + DTMULT
	self.number_timer_two = self.number_timer_two + DTMULT
    local to_remove = {}
    for _,particle in ipairs(self.number_particles) do
        particle.y = particle.y + (DTMULT * 5)
		particle.lifetime = particle.lifetime + DTMULT
		if particle.lifetime >= 0 then
			if particle.lifetime < 45 then
				particle.color = Utils.mergeColor({0, 1, 0, 0}, {1, 1, 0, 0.8}, particle.lifetime/45)
			else
				particle.color = Utils.mergeColor({1, 1, 0, 0.8}, {1, 0.625, 0.25, 0}, (particle.lifetime-45)/45)
			end
		end


        if particle.lifetime >= 90 then
            table.insert(to_remove, particle)
        end
    end

    for _,particle in ipairs(to_remove) do
        Utils.removeFromTable(self.number_particles, particle)
    end

    to_remove = {}
    for _,particle in ipairs(self.bg_numbers) do
        particle.y = particle.y - (DTMULT * self.bg_speed)
        if particle.y < -50 then
            table.insert(to_remove, particle)
        end
    end

    for _,particle in ipairs(to_remove) do
        Utils.removeFromTable(self.bg_numbers, particle)
    end

	if self.number_timer >= self.number_timer_max then
		self.number_timer = 0
		self.number_timer_max = Utils.random(25, 45, 0.5)
		local number_x = Utils.round(Utils.round(Utils.random() * SCREEN_WIDTH, 0.5)/40, 0.5)*40
		local number_y = Utils.round(Utils.random() * 30, 0.5)
		local number_size = Utils.pick({1, 1, 1, 2, 2, 3})
        for _,particle in ipairs(self.number_particles) do
			if particle.x == number_x then
				number_x = number_x + 20
			end
		end
		for i = 1, 10 do
			table.insert(self.number_particles, {x = number_x, y = number_y, color = {0, 1, 0, 0}, lifetime = -(i-1)*(number_size*2), size = number_size, index = Utils.pick({1, 2})})
			number_y = number_y - number_size*10
		end
	end
	if self.number_timer_two >= self.number_timer_two_max and Utils.randomSign() == 1 then
		self.number_timer_two = 0
		self.number_timer_two_max = Utils.random(25, 45, 0.5)
		local number_x = Utils.round(Utils.round(Utils.random() * SCREEN_WIDTH, 0.5)/40, 0.5)*40
		local number_y = Utils.round(Utils.random() * 30, 0.5)
		local number_size = Utils.pick({1, 1, 1, 2, 2, 3})
        for _,particle in ipairs(self.number_particles) do
			if particle.x == number_x then
				number_x = number_x + 20
			end
		end
		for i = 1, 10 do
			table.insert(self.number_particles, {x = number_x, y = number_y, color = {0, 1, 0, 0}, lifetime = -(i-1)*(number_size*2), size = number_size, index = Utils.pick({1, 2})})
			number_y = number_y - number_size*10
		end
	end
end

function AxisBattleBackground:draw()
    local offset = 0
	for _,particle in ipairs(self.bg_numbers) do
		Draw.setColor(particle.color)
		Draw.draw(self.number_image[particle.index], particle.x, particle.y, 0, 3, 3)
	end
	for _,particle in ipairs(self.number_particles) do
		Draw.setColor(particle.color)
		Draw.draw(self.number_image[particle.index], particle.x, particle.y, 0, particle.size, particle.size)
	end
    --[[for i = 1, #self.falling_numbers do
        local sine = (math.sin(self.bg_siners[i] / 14) * 28) + 12
        Draw.setColor(0, 0.5, 0)
        love.graphics.setLineWidth(1)
        love.graphics.rectangle("line", 18 + offset, sine, 101, 118)
        love.graphics.rectangle("line", 18 + offset, sine + 118, 101, 118)
        offset = offset + 101
    end]]
    super.draw(self)
end

return AxisBattleBackground
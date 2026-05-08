local Axis, super = Class(LightEncounter)

function Axis:init()
    super.init(self)

    self.text = "* Axis Model 014,[wait:5] ready to\ndefend."

    self.music = "guns_blazing_geno"

    self:addEnemy("axis_g")

	self.turns_passed = 0

	self.number_timer = 0
	self.number_timer_max = Utils.random(25, 45, 0.5)
	
	self.number_timer_two = 0
	self.number_timer_two_max = Utils.random(25, 45, 0.5)
	
	self.bg_numbers = {}
	self.number_particles = {}
	
	self.bg_speed = 4
	
	for a = SCREEN_HEIGHT, 0, -36 do
		for i = SCREEN_WIDTH+15, 0, -36 do
			if Utils.pick({1, 2, 3}) ~= 1 then
				local number_col = Utils.pick({{0.0745098039215686, 0.2470588235294118, 0.1019607843137255, 0.22},
				{0.1686274509803922, 0.5686274509803922, 0.2352941176470588, 0.22}})
				table.insert(self.bg_numbers, {x = i, y = a, color = number_col, index = Utils.pick({1, 2})})
			end
		end
	end
	
    Game.battle.timer:every((36/self.bg_speed)/30, function()
		for i = SCREEN_WIDTH+15, 0, -36 do
			if Utils.pick({1, 2, 3}) ~= 1 then
				local number_col = Utils.pick({{0.0745098039215686, 0.2470588235294118, 0.1019607843137255, 0.22},
				{0.1686274509803922, 0.5686274509803922, 0.2352941176470588, 0.22}})
				table.insert(self.bg_numbers, {x = i, y = SCREEN_HEIGHT, color = number_col, index = Utils.pick({1, 2})})
			end
		end
	end)
	
    self.number_image = Assets.getFrames("ui/lightbattle/backgrounds/battle_axis_number")
	
    self.can_flee = false
end

function Axis:createBackground()
    local background = AxisBattleBackground()
    return Game.battle:addChild(background)
end

function Axis:update()
    super.update(self)
end

function Axis:onBattleInit()
	MagicalGlassLib.serious_mode = true
end

function Axis:beforeStateChange(old, new)
    if old == "DEFENDINGEND" and new ~= "DEFENDINGEND" then
		if self.turns_passed == 10 then
			if Game.battle:getEnemyBattler("axis_g").geno_aborted then
				if not Game.battle:getEnemyBattler("axis_g").tired then
					Game.battle:setState("NONE")
					Game.battle:startCutscene("axis_geno", "tired")
			    end
			else
				Game.battle:setState("NONE")
				Game.battle:startCutscene("axis_geno", "fight_end")
			end
		else
			self.turns_passed = self.turns_passed + 1
        end
    end
end

function Axis:onReturnToWorld(events)
	Game:setFlag("axis_geno_done", true)
	MagicalGlassLib.serious_mode = false
end

function Axis:getVictoryMoney(money)
	return 0
end

return Axis
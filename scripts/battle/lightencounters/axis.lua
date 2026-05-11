---@class LightEncounter.Axis : LightEncounter
local Axis, super = Class(LightEncounter)

function Axis:init()
    super.init(self)

    self.text = "* Axis Model 014,[wait:5] ready to\nattack!"

    self.music = "guns_blazing"

    self:addEnemy("axis")

    self.can_flee = false

    self.trash_meter = 0
end

function Axis:onBattleStart()
    Game.battle:setState("ENEMYDIALOGUE")
	Game.battle.music:stop()
    Game.battle:startCutscene("axis", "floweysave")
end

function Axis:createBackground()
    local background = AxisBattleBackground()
    return Game.battle:addChild(background)
end

function Axis:onBattleInit()
    self.battery_meter = AxisBatteryMeter(20, -80)
    Game.battle:addChild(self.battery_meter)
    self.tick_o_bar = AxisTickOBar(557, -80)
    Game.battle:addChild(self.tick_o_bar)
end

function Axis:onReturnToWorld(events)
	Game:setFlag("axis_done", true)
end

function Axis:beforeStateChange(old, new)
    if new == "DEFENDINGBEGIN" then
		self.battery_meter.move_up = false
        self.tick_o_bar.move_up = false
    elseif new == "DEFENDINGEND" then
		self.battery_meter.move_up = true
        self.tick_o_bar.move_up = true
    end
end

function Axis:getVictoryMoney(money)
	return 0
end

return Axis
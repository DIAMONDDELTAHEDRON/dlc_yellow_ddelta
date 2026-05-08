local AxisBatteryMeter, super = Class(Sprite)

function AxisBatteryMeter:init(x, y)
  super.init(self, "battle/lightenemies/axis/battery_meter", x, y)
  self:setOriginExact(0, 2)
  self.current = 100
  self.move_up = false
  self.hit_count = 8
end

function AxisBatteryMeter:drainCharge()
  -- god help me I don't know how to do it
end

function AxisBatteryMeter:update()
  super.update(self)

  if self.move_up then
    self.y = MathUtils.lerp(self.y, -80, 0.2*DTMULT)
  else
    self.y = MathUtils.lerp(self.y, 20, 0.2*DTMULT)
  end

  local battery_level_target = 100 * (self.hit_count / 8)
  self.current = MathUtils.lerp(self.current, battery_level_target, 0.15*DTMULT)
end

function AxisBatteryMeter:draw()
  local w = 52 - 52 * (1 - self.current / 100)
  local h = 32
  Draw.setColor(0, 1, 0)
  love.graphics.rectangle("fill", 0, 2, w + 1, h + 1)
  super.draw(self)
end

return AxisBatteryMeter
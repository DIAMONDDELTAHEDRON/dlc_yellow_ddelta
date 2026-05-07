local RobotDestroyExplosion, super = Class(Sprite)

function RobotDestroyExplosion:init(x, y)
  super.init(self, "effects/robot_destroy_explosion", x, y)
  self:setOriginExact(31, 24)
  self:setScale(2)
  self.alpha = 0.8
  self.fade_out = false
  self.timer = 0
end

function RobotDestroyExplosion:update()
  super.update(self)

  if self.timer >= 15 and not self.fade_out then self.fade_out = true end

  if self.fade_out then
    self.alpha = self.alpha - 0.1 * DTMULT
    if self.alpha <= 0 then
      self:remove()
    end
  end

  local current_time = math.floor(Kristal.getTime() * 1000)
  self.scale_x = 2 + (math.sin(current_time / 100)) * 0.2
  self.scale_y = self.scale_x

  self.timer = self.timer + DTMULT
end

return RobotDestroyExplosion
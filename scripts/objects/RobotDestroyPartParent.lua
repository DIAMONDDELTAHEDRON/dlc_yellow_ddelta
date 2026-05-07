local RobotDestroyExplosion, super = Class(Sprite)

function RobotDestroyExplosion:init(sprite, x, y, orig_x, orig_y)
  super.init(self, sprite, x, y)
  self:setOriginExact(orig_x, orig_y)
  self.physics.speed_y = MathUtils.random(-5, -10)
  self.physics.speed_x = MathUtils.randomInt(3, 6)
  if self.x < 320 then
    self.physics.speed_x = self.physics.speed_x * -1
  end
  self.physics.gravity = 0.5
  self.fade_out_timer = 30
end

function RobotDestroyExplosion:update()
  super.update(self)

  local function sign(num)
    if num == 0 then
      return 0
    elseif num > 0 then
      return 1
    else
      return -1
    end
  end

  self.rotation = self.rotation + -math.rad(sign(self.physics.speed_x) * 15) * DTMULT
  if self.fade_out_timer > 0 then
    self.fade_out_timer = self.fade_out_timer - DTMULT
  else
    self.alpha = self.alpha - 0.1 * DTMULT
    if self.alpha <= 0 then
      self:remove()
    end
  end
end

return RobotDestroyExplosion
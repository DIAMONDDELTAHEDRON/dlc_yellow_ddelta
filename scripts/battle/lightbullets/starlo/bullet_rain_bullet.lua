local BulletRainBullet, super = Class(LightBullet)

function BulletRainBullet:init(x, y, dir)
    -- Last argument = sprite path
    super.init(self, x, y)

	self.rotation = dir or 0
	self.collider = LineCollider(self, 0, 0, 1000, 0)
	self.alpha = 1
	self.destroy_on_hit = false
end

function BulletRainBullet:update()
    super.update(self)
	if self.alpha > 0 then
		self.alpha = self.alpha - 0.15 * DTMULT
	else
		self:remove()
	end
end

function BulletRainBullet:draw()
    super.draw(self)
	Draw.setColor(1, 1, 1, self.alpha)
	love.graphics.setLineWidth(2)
	love.graphics.line(0, 0, 1000, 0)
	Draw.setColor(1, 1, 1, 1)
end

return BulletRainBullet
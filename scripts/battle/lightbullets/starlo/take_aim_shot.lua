local TakeAimTarget, super = Class(LightBullet)

function TakeAimTarget:init(x, y)
    super.init(self, x, y, "battle/bullets/starlo/take_aim_shot")
	self:setOriginExact(31, 30)
    self:setScale(1)
	self.sprite:play(1/10, false, function() self:remove() end)

	self.collider = CircleCollider(self, 31, 29, 14)
	self.destroy_on_hit = false

	self.screenshake = true
	self.screenshake_max = 3

	Assets.playSound(TableUtils.pick({"shotmid", "shotstrong"}))
end

function TakeAimTarget:update()
    super.update(self)

end

return TakeAimTarget
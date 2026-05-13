local SoulTutorialArrows, super = Class(Sprite)

function SoulTutorialArrows:init(x, y)
    super.init(self, "ui/lightbattle/tutorial_arrows", x, y)
    self:setOriginExact(13, 13)
    self:setScale(1)
    self.layer = BATTLE_LAYERS["above_bullets"]
	self.heart_x_default = Game.battle.soul.x
	self.heart_y_default = Game.battle.soul.y
	self.floor_xy_check = false
	self.alpha_timer = 0
	self.reached_first_alpha_time = false
end

function SoulTutorialArrows:update()
	self.alpha_timer = self.alpha_timer + DTMULT
	if self.reached_first_alpha_time then
		if not self.visible and self.alpha_timer >= 5 then
			self.visible = true
			self.alpha_timer = 0
		elseif self.visible and self.alpha_timer >= 15 then
			self.visible = false
			self.alpha_timer = 0
		end
	elseif self.alpha_timer >= 120 then
		self.visible = false
		self.alpha_timer = 0
		self.reached_first_alpha_time = true
	end
	super.update(self)
    if self.floor_xy_check then
		if math.floor(Game.battle.soul.x) ~= math.floor(self.heart_x_default) or math.floor(Game.battle.soul.y) ~= math.floor(self.heart_y_default) then
			self:remove()
		end
	else
		if Game.battle.soul.x ~= self.heart_x_default or Game.battle.soul.y ~= self.heart_y_default then
			self:remove()
		end	
	end
end

return SoulTutorialArrows
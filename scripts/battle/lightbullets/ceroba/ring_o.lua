local CerobaRingOrange, super = Class(LightBullet)

function CerobaRingOrange:init(x, y, dir, speed)
    -- Last argument = sprite path
    super.init(self, x, y)

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed

    self.collider = PolygonCollider(self, {{27,1},{31,1},{41,5},{48,12},{52,21},{52,31},{48,40},{41,47},{31,51},{22,51},{12,47},{5,40},{1,31},{1,21},{5,12},{12,5},{22,1},{26,1},
    {26,2},{23,2},{12,7},{7,12},{2,22},{2,30},{7,40},{12,45},{23,50},{30,50},{41,45},{46,40},{51,30},{51,22},{46,12},{41,7},{30,2},{27,2}})
    --self:setHitbox(0, 0, self.width, 8)

    self.destroy_on_hit = false
    self:setScale(0.1, 0.1)
	self:setOrigin(0.5, 0.5)
	self.scale = 0.1
	self.circle_width = 0.04
	self.fading = false
end

local function condition(soul)
	return (soul.moving_x == 0 and soul.moving_y == 0)
end

function CerobaRingOrange:onCollide(soul)
	if condition(soul) then
		return super.onCollide(self, soul)
	end
end

function CerobaRingOrange:update()

    local soul = Game.battle.soul
	if not condition(soul) then
		self.grazed = true
	end
	
	self.scale = self.scale + 0.2 * DTMULT
	self.circle_width = self.circle_width + 0.02 * DTMULT
	self.scale_x = self.scale
	self.scale_y = self.scale
	self.x = self.x - 5 * DTMULT
	self.y = self.y - 5 * DTMULT
	if self.scale >= 6 and not self.fading then
		self:fadeOutAndRemove(0.25)
		self.fading = true
	end

    super.update(self)
end

function CerobaRingOrange:draw()
	super.draw(self)
    Draw.setColor({1, 0.625, 0.25, self.alpha})
	love.graphics.setLineWidth(self.circle_width)
	love.graphics.circle("line",26,26,18+self.scale)
	if DEBUG_RENDER and self.collider then
        self.collider:draw(1, 0, 0)
    end
end

return CerobaRingOrange
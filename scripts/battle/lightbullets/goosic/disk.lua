local Disk, super = Class(LightBullet)

function Disk:init(x, y)
    super.init(self, x, y, "battle/bullets/goosic/disk")
    self:setOriginExact(23, 23)
    self:setScale(1)
    self.rotation = -math.rad(90)
    self.sprite.alpha = 0
    self.spin_speed = 0
    self.slow_down_noloop = false
    self.scene = 0
    self.cutscene_timer = 0
    self.launch_timer = 30 -- 1 * room_speed
    self.launch_timer_max = self.launch_timer
    self.disc_yoffset = 60
    self.vsp = 0
    self.arrow_alpha = 0
    self.timer = 0

    self.wait_timer = 0
    self.wait_callback = nil
end

function Disk:wait(seconds, callback)
    self.wait_timer = seconds
    self.wait_callback = callback
end

function Disk:update()
    if self.timer >= 2 then
        if self.sprite.alpha < 1 then
            self.sprite.alpha = self.sprite.alpha + 0.2
            self.timer = 0
        else
            self.scene = 1
        end
    end

    self.timer = self.timer + DTMULT

    local timer_was_going = (self.wait_timer > 0) and true or false

    -- bro who tf uses cutscenes as a part of the attack
    self.wait_timer = MathUtils.approach(self.wait_timer, 0, DT)
    if self.wait_timer > 0 then
        -- we don do scene shit if it's active
        self.scene = 0
    elseif timer_was_going then
        self.wait_callback()
        self.wait_callback = nil
    end

    if self.scene == -1 then
        -- unused?
        self.disc_yoffset = self.disc_yoffset - math.abs(self.vsp)
        self.y = self.y + self.vsp * DTMULT
        if self.disc_yoffset <= 0 then
            self.vsp = MathUtils.lerp(self.vsp, 0, 0.15*DTMULT)
            if math.abs(self.vsp) < 0.1 then
                self.vsp = 0
                self.scene = 1
            end
        end
    elseif self.scene == 1 then
        self:wait(0.5, function() self.scene = 2 end)
    elseif self.scene == 2 then
        if self.spin_speed < 20 then
            self.spin_speed = self.spin_speed + DTMULT
        else
            self.scene = 3
        end
    elseif self.scene == 3 then
        local soul_dir = MathUtils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)
        if self.launch_timer > 0 then
            self.launch_timer = self.launch_timer - DTMULT
        elseif self.physics.direction > math.floor(soul_dir - self.spin_speed) and self.physics.direction < math.floor(soul_dir + self.spin_speed) then
            self.slow_down_noloop = true
        end
        if self.slow_down_noloop == true then
            self.spin_speed = MathUtils.lerp(self.spin_speed, 0, 0.75*DTMULT)
            if self.spin_speed < 0.1 then
                self.spin_speed = 0
                self.scene = 4
            end
        end
    elseif self.scene == 4 then
        self:wait(0.2, function() self.scene = 5 end)
    elseif self.scene == 5 then
        self.physics.speed = MathUtils.lerp(self.physics.speed, 14, 0.5*DTMULT)
        self:wait(0.7, function()
            self.launch_timer = self.launch_timer_max
            self.slow_down_noloop = false
            self.scene = 1
            self.scene = 2
        end)
    end

    self.physics.direction = self.physics.direction - self.spin_speed * DTMULT
    self.rotation = self.physics.direction
    if self.scene ~= 4 and self.scene ~= -1 then
        self.physics.speed = MathUtils.lerp(self.physics.speed, 0, 0.3*DTMULT)
    end
    local alpha_new = 0
    if self.scene == 2 or self.scene == 3 then
        alpha_new = 1
    end
    self.arrow_alpha = MathUtils.lerp(self.arrow_alpha, alpha_new, 0.2*DTMULT)

    super.update(self)
end

function Disk:draw()
    super.draw(self)

    Draw.setColor(1, 1, 1, self.arrow_alpha)
    Draw.draw(Assets.getTexture("battle/bullets/goosic/disk_arrow"), 0, 0, self.rotation, 1, 1, -25, 7)
end

return Disk
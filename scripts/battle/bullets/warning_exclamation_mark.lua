local WarningExclamationMark, super = Class(Bullet)

function WarningExclamationMark:init(x, y)
    super.init(self, x, y, "battle/bullets/warning_exclamation_mark")
    self:setOriginExact(4, 20)
    self:setScale(1)
    self.sprite:play((1/30)/0.8, false, function() self:remove() end)

    self.collider = nil

    self.counter = 0
    self.sound_play_noloop = {false, false, false}
end

function WarningExclamationMark:update()
    self.counter = self.counter + 0.8 * DTMULT

    if self.counter >= 3.2 and self.sound_play_noloop[1] == false then
        Assets.stopAndPlaySound("bombfall")
        self.sound_play_noloop[1] = true
    end

    if self.counter >= 5.6 and self.sound_play_noloop[2] == false then
        Assets.stopAndPlaySound("bombfall")
        self.sound_play_noloop[2] = true
    end

    if self.counter >= 8 and self.sound_play_noloop[3] == false then
        Assets.stopAndPlaySound("bombfall")
        self.sound_play_noloop[3] = true
    end

    super.update(self)
end

return WarningExclamationMark
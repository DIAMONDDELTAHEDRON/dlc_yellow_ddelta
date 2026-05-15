local actor, super = Class(Actor, "starlo_b")

function actor:init()
    super.init(self)

    self.name = "Starlo"

    self.light_battle_width = 108
    self.light_battle_height = 214

    self.hitbox = {0, 0, 16, 16}

    self.use_light_battler_sprite = true

    self.path = "battle/lightenemies/starlo"
    self.default = ""

    self.voice = "starlo"

    self.animations = {}

    self.offsets = {
        ["body_dead"] = {8, 32}
    }

    self.anim_loop_time = 30 * 6 -- room_speed * 6
    self.anim_stretch_current = 1
    self.anim_stretch_max = 1.05
    self.anim_stage = 1
    self.anim_inc_multiplier = 2
    self.anim_inc_multiplier_max = 2
    self.anim_head_offset = 214 - 64 -- y - obj_starlo_boss_head.y
    self.anim_head_offset_x = 54 - 54 -- x - obj_starlo_boss_head.x

    self.do_body_stretch = true

    self:addLightBattlerPart("body", {
        ["create_sprite"] = function()
            local sprite = Sprite(self.path.."/body", 54, 214)
            sprite:setOriginExact(54, 154)
            return sprite
        end
    })

    self:addLightBattlerPart("head", {
        ["create_sprite"] = function()
            local sprite = Sprite(self.path.."/head", 54, 64)
            sprite:setOriginExact(42, 64)
            sprite.layer = 500
            return sprite
        end
    })
end

function actor:onBattleUpdate(battler)
    local body = self:getLightBattlerPart("body")
    local head = self:getLightBattlerPart("head")

    local anim_loop_time_half = self.anim_loop_time / 2
    local anim_inc_current = (self.anim_stretch_max - 1) / anim_loop_time_half * self.anim_inc_multiplier

    if self.anim_stage == 1 then
        self.anim_stretch_current = self.anim_stretch_current + anim_inc_current * DTMULT
        self.anim_inc_multiplier = self.anim_inc_multiplier - (self.anim_inc_multiplier_max / anim_loop_time_half) * DTMULT
        if self.anim_stretch_current >= self.anim_stretch_max then
            self.anim_stretch_current = self.anim_stretch_max
            self.anim_stage = 2
            self.anim_inc_multiplier = self.anim_inc_multiplier_max
        end
    elseif self.anim_stage == 2 then
        self.anim_stretch_current = self.anim_stretch_current - ((self.anim_stretch_max - 1) / anim_loop_time_half) * DTMULT
        self.anim_inc_multiplier = self.anim_inc_multiplier - (self.anim_inc_multiplier_max / anim_loop_time_half) * DTMULT
        if (self.anim_stretch_current <= 1) then
            self.anim_stretch_current = 1
            self.anim_stage = 1
            self.anim_inc_multiplier = self.anim_inc_multiplier_max
        end
    end

    if self.do_body_stretch then
        body.sprite.scale_y = self.anim_stretch_current
    else
        body.sprite.scale_y = 1
    end
    head.sprite.y = body.sprite.y - self.anim_head_offset * body.sprite.scale_y
end

function actor:onTextSound()
    Assets.stopAndPlaySound("voice/starlo")
    return true
end

return actor
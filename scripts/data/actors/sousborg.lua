local actor, super = Class(Actor, "sousborg")

function actor:init()
    super.init(self)

    self.name = "Sousborg"

    self.width = 45
    self.height = 84

    self.use_light_battler_sprite = true

    self.hitbox = {0, 64, 45, 20}

    self.color = {1, 0, 0}

    self.flip = nil

    self.path = "world/npcs/steamworks"
    self.default = "sousborg_1"

    self.voice = nil
    self.portrait_path = nil
    self.portrait_offset = nil

    self.can_blush = false

    self.talk_sprites = {
        ["sousborg"] = 0.2,
    }

    self.animations = {}

    self.offsets = {}

end

return actor
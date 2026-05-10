local BallChaseAttack, super = Class(LightEncounter)

function BallChaseAttack:init()
    super.init(self)

    self.music = nil

    self.event = true
    self.event_waves = {"chase_attack"}

    self.fast_transition = true
end

function BallChaseAttack:createBackground()
    if self.background then
        local background = Sprite("ui/lightbattle/backgrounds/standard", 0, 0, SCREEN_HEIGHT, SCREEN_WIDTH)
        background:setColor({238 / 255, 71 / 255, 122 / 255, 1})
        background:setParallax(0, 0)
        background.layer = LIGHT_BATTLE_LAYERS["background"]
        background.debug_select = false
        return Game.battle:addChild(background)
    end
end

return BallChaseAttack
local Dunebud, super = Class(LightEncounter)

function Dunebud:init()
    super.init(self)

    self.text = "* Double trouble!"

    if Game:getFlag("dunes_kills") >= 13 then
        local enemies_left = 20 - Game:getFlag("dunes_kills")
        local mus_pitch = 1
        if enemies_left > 0 then
            mus_pitch = (enemies_left / 7)
        end
        MUSIC_PITCHES["genobattle_yellow"] = mus_pitch
        self.music = "genobattle_yellow"
    else
        self.music = "prebattle3_yellow"
    end

    self:addEnemy("dunebud")
    self:addEnemy("dunebud")

    self.can_flee = false

    self.kill_count = 0
end

function Dunebud:createBackground()
    if self.background then
        local background = Sprite("ui/lightbattle/backgrounds/standard", 0, 0, SCREEN_HEIGHT, SCREEN_WIDTH)
        background:setColor({1, 204 / 255, 0, 1})
        background:setParallax(0, 0)
        background.layer = LIGHT_BATTLE_LAYERS["background"]
        background.debug_select = false
        return Game.battle:addChild(background)
    end
end

return Dunebud
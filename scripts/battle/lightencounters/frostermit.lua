local Frostermit, super = Class(LightEncounter)

function Frostermit:init()
    super.init(self)

    self.text = "* There is an igloo here."

    if Game:getFlag("snowdin_yellow_kills") >= 13 then
        local enemies_left = 20 - Game:getFlag("snowdin_yellow_kills")
        local mus_pitch = 1
        if enemies_left > 0 then
            mus_pitch = (enemies_left / 7)
        end
        MUSIC_PITCHES["genobattle_yellow"] = mus_pitch
        self.music = "genobattle_yellow"
    else
        self.music = "battle_snowdin"
    end

    self:addEnemy("frostermit")

    self.can_flee = false

    self.kill_count = 0
end

function Frostermit:createBackground()
    if self.background then
        local background = Sprite("ui/lightbattle/backgrounds/standard", 0, 0, SCREEN_HEIGHT, SCREEN_WIDTH)
        background:setColor({0, 198 / 255, 1, 1})
        background:setParallax(0, 0)
        background.layer = LIGHT_BATTLE_LAYERS["background"]
        background.debug_select = false
        return Game.battle:addChild(background)
    end
end

return Frostermit
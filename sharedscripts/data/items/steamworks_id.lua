local item, super = Class(Item, "steamworks_id")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Steamworks ID"

    -- Item type (item, key, weapon, armor)
    self.type = "key"
    -- Whether this item is for the light world
    self.light = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "ID of the Chemist"

    -- Light world check text
    self.check = "ID of the Chemist"

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
end

function item:onWorldUse()
    ---@type Sprite
    local viewer = ImageViewerBroken("id_minigame/crayon_id")
    local ok, texture = pcall(love.graphics.newImage, "saves/stworks_id_"..Game.save_id..".png")
    if ok then viewer:setTexture(texture) end
    viewer:setPosition(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
    viewer:setOrigin(.5)
    --Game.world:openMenu(viewer)
    return false
end

function item:onToss()
    Game.world:showText("* You felt like you should keep it.")
    return false
end

return item
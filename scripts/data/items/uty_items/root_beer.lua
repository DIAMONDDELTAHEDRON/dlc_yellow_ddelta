local item, super = Class(HealItem, "uty_items/root_beer")

function item:init(inventory)
    super.init(self)

    -- How this item is used on you (ate, drank, eat, etc.)
    self.use_method = "drink"
    -- Display name
    self.name = "Root Beer"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Whether this item is for the light world
    self.light = true

    self.heal_amount = 18

    self.price = 22
    -- Default shop sell price
    self.sell_price = 25
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "(It's family friendly!)"

    -- Light world check text
    self.check = "Heals 18 HP\"\n* (It's family friendly!)"

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false
    
end

function item:getWorldUseText(target)
    if not MagicalGlassLib.serious_mode then
        if target.id == Game.party[1].id then
            return "* (You down the Root Beer.[wait:5] The\ncarbonation tingles!)"
        else
            return "* ("..target:getName().." downs the Root Beer.)"
        end
    else
        return ""
    end
end

function item:getLightBattleText(user, target)
    if not MagicalGlassLib.serious_mode then
        if target.chara.id == Game.battle.party[1].chara.id then
            return "* (You down the Root Beer.[wait:5] The\ncarbonation tingles!)"
        else
            return "* ("..target.chara:getName().." downs the Root Beer.)"
        end
    else
        return ""
    end
end

return item
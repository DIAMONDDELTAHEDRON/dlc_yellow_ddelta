local item, super = Class(HealItem, "uty_items/adult_soda")

function item:init(inventory)
    super.init(self)

    -- How this item is used on you (ate, drank, eat, etc.)
    self.use_method = "drink"
    -- Display name
    self.name = "Adult Soda"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Whether this item is for the light world
    self.light = true

    self.heal_amount = 20

    self.price = 20
    -- Default shop sell price
    self.sell_price = 25
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "(A transparent liquid with no smell.)"

    -- Light world check text
    self.check = "Heals ??? HP\n* (A transparent liquid\nwith no smell.)"

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
            return {
                "* (You take a sip out of\nthe adult soda.)",
                "* (...)",
                "* (Tastes like water.)"
            }
        else
            return "* ("..target:getName().." takes a sip out of\nthe adult soda.)"
        end
    else
        return ""
    end
end

function item:getLightBattleText(user, target)
    if not MagicalGlassLib.serious_mode then
        if target.chara.id == Game.battle.party[1].chara.id then
            return {
                "* (You take a sip out of\nthe adult soda.)",
                "* (...)",
                "* (Tastes like water.)"
            }
        else
            return "* ("..target.chara:getName().." takes a sip out of\nthe adult soda.)"
        end
    else
        return ""
    end
end

return item
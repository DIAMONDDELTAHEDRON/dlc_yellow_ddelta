local item, super = Class(HealItem, "uty_items/corn_chowder")

function item:init(inventory)
    super.init(self)

    -- How this item is used on you (ate, drank, eat, etc.)
    self.use_method = "drink"
    -- Display name
    self.name = "Corn Chowder"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Whether this item is for the light world
    self.light = true

    self.heal_amount = 15

    -- Default shop sell price
    self.sell_price = 15
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "(Weeks-old leftovers from Ceroba's fridge.)"

    -- Light world check text
    self.check = "Heals 15 HP\"\n* (Weeks-old leftovers from\nCeroba's fridge.)"

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
                "* (You nervously drink the Corn\nChowder.)",
                "* (...Could've been worse.)"
            }
        else
            return "* ("..target:getName().." nervously drinks the Corn\nChowder.)"
        end
    else
        return ""
    end
end

function item:getLightBattleText(user, target)
    if not MagicalGlassLib.serious_mode then
        if target.chara.id == Game.battle.party[1].chara.id then
            return {
                "* (You nervously drink the Corn\nChowder.)",
                "* (...Could've been worse.)"
            }
        else
            return "* ("..target.chara:getName().." nervously drinks the Corn\nChowder.)"
        end
    else
        return ""
    end
end

return item
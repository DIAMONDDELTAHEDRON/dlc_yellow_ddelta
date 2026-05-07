local item, super = Class(HealItem, "uty_items/gunpowder")

function item:init(inventory)
    super.init(self)

    -- Display name
    self.name = "Gunpowder"
    --self.short_name = "ButtsPie"
    --self.serious_name = "Pie"

    -- How this item is used on you (ate, drank, eat, etc.)
    self.use_method = "ate"
    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Whether this item is for the light world
    self.light = true

    self.heal_amount = 999

    self.price = 40
    -- Default shop sell price
    self.sell_price = 15
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "(The forbidden spice.)"

    -- Light world check text
    self.check = "Heals ??? HP\"\n* (The forbidden spice.)"

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false
end

function item:getLightWorldHealingText(target, amount)
    if not MagicalGlassLib.serious_mode then
        return nil
    else
        return super.getLightWorldHealingText(self, target, amount)
    end
end

function item:getLightBattleHealingText(user, target, amount)
    if not MagicalGlassLib.serious_mode then
        return nil
    else
        return super.getLightBattleHealingText(self, user, target, amount)
    end
end

function item:getWorldUseText(target)
    if not MagicalGlassLib.serious_mode then
        if target.id == Game.party[1].id then
            return "* (You put the gunpowder in your\nmouth and nearly choke to\ndeath.)"
        else
            return "* ("..target:getName().." puts the gunpowder in their\nmouth and nearly chokes to\ndeath.)"
        end
    else
        return ""
    end
end

function item:getLightBattleText(user, target)
    if not MagicalGlassLib.serious_mode then
        if target.chara.id == Game.battle.party[1].chara.id then
            return {
                "* (You put the gunpowder in your\nmouth and nearly choke to\ndeath.)",
                "* (...HP fully restored.)"
            }
        else
            return {
                "* ("..target.chara:getName().." puts the gunpowder in their\nmouth and nearly chokes to\ndeath.)",
                "* (...HP fully restored.)"
            }
        end
    else
        return ""
    end
end

return item
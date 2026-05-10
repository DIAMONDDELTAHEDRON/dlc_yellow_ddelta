local Soap, super = Class(LightBullet)

function Soap:init(x, y)
    super.init(self, x, y, "battle/bullets/jandroid/garbage_soap")
    self:setScale(1)
end

function Soap:update()

    super.update(self)
end

function Soap:onCollide(soul)
	local member = TableUtils.pick(Game.battle.party)
	member:heal(4)
    local attackers = self.wave:getAttackers()
    for _, attacker in ipairs(attackers) do
        attacker:addMercy(100)
    end
	self:remove()
end

return Soap
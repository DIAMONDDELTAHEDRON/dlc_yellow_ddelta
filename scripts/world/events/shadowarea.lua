local ShadowArea, super = Class(Event)

function ShadowArea:init(data)
	super.init(self, data)

	local properties = data.properties or {}
    self.target_amount = properties["amount"] or 0.5
	self.start_amount = self.target_amount
	
    Game.world.timer:after(1/30, function ()
        self.start_amount = 0
    end)
end

function ShadowArea:onEnter(chara)
    local id = self:getUniqueID().."_shadow"
    local mask = chara:addFX(ColorMaskFX(), id)
	mask.color = {0,0,0}
	mask.amount = self.start_amount
    self.world.timer:tween(10/30, mask, {amount = self.target_amount})
end

function ShadowArea:onExit(chara)
    local id = self:getUniqueID().."_shadow"
    local mask = chara:getFX(id)
    if mask then
        self.world.timer:tween(10/30, mask, {amount = 0}, "linear", function()
            chara:removeFX(mask)
        end)
    end
end

return ShadowArea
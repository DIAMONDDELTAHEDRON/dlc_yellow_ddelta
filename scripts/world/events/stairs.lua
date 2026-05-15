local Stairs, super = Class(Event)

function Stairs:init(data)
	super.init(self, data)
end

function Stairs:onEnter(chara)
    if chara.is_player then
		Game.world.player.on_stairs = true
	end
end

function Stairs:onExit(chara)
    if chara.is_player then
		Game.world.player.on_stairs = false
	end
end

return Stairs
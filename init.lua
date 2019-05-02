local ActionBlockType = "default:goldblock"
local NodePowers = {["default:mese"] = 100}

local on_punch_old = ItemStack(ActionBlockType):get_definition().on_punch -- Added to avoid conflicts with other mods
local PunchDebounces = {}

minetest.override_item(ActionBlockType, {
	on_punch = function(pos, node, puncher, pointed_thing)
		if not PunchDebounces[puncher] then
			local direction = {x = 0, y = 0, z = 0}
			local ReadPos = {x = pos.x, y = pos.y, z = pos.z}
			local function doAction(d, polarity) -- D stands for dimension.
				local LoopFirst = true
				local ReadNode = nil
				while LoopFirst or NodePowers[ReadNode] ~= nil do
					if LoopFirst then
						LoopFirst = false
					else
						direction[d] = direction[d] + NodePowers[ReadNode]
					end
					ReadPos[d] = ReadPos[d] + polarity
					ReadNode = minetest.get_node(ReadPos).name
				end
				ReadPos[d] = pos[d]
			end
			
			doAction("x", 1)
			doAction("x", -1)
			doAction("y", 1)
			doAction("y", -1)
			doAction("z", 1)
			doAction("z", -1)
			
			-- Teleport the player
			if direction.x ~= 0 or direction.y ~= 0 or direction.z ~= 0 then
				local puncherPos = puncher:getpos()
				puncher:setpos({x = puncherPos.x + direction.x, y = puncherPos.y + direction.y, z = puncherPos.z + direction.z})
				PunchDebounces[puncher] = true
				minetest.after(0.5, function(...)
					PunchDebounces[puncher] = nil
				end)
			end
		end

		return on_punch_old(pos, node, puncher, pointed_thing) -- Added to avoid conflict with other mods
	end,
})

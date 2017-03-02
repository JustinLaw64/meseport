local on_punch_old = ItemStack("default:goldblock"):get_definition().on_punch -- Added to avoid conflict with other mods
local NodePowers = {["default:mese"] = 100}
local PunchDebounces = {}

minetest.override_item("default:goldblock", {
	on_punch = (function(pos, node, puncher, pointed_thing)
		if (not PunchDebounces[puncher]) then
			local direction = {x = 0, y = 0, z = 0}
		
			local ReadPos = {x = pos.x, y = pos.y, z = pos.z}
			for d,v in pairs(direction) do -- D stands for dimension.
				-- Go positive
				local LoopFirst, ReadNode
			
				LoopFirst = true
				ReadNode = nil
				while (LoopFirst or NodePowers[ReadNode] ~= nil) do
					if not LoopFirst then
						direction[d] = direction[d] + NodePowers[ReadNode]
					else
						LoopFirst = false
					end
					ReadPos[d] = ReadPos[d] + 1
					ReadNode = minetest.get_node(ReadPos)["name"]
				end
				ReadPos[d] = pos[d]
				
				-- Go negative
				LoopFirst = true
				ReadNode = nil
				while (LoopFirst or NodePowers[ReadNode] ~= nil) do
					if not LoopFirst then
						direction[d] = direction[d] - NodePowers[ReadNode]
					else
						LoopFirst = false
					end
					ReadPos[d] = ReadPos[d] - 1
					ReadNode = minetest.get_node(ReadPos)["name"]
				end
				ReadPos[d] = pos[d]
			end
		
			-- Teleport the player
			-- Condition added to avoid jumpiness after punching unpowered gold.
			if (direction.x ~= 0 or direction.y ~= 0 or direction.z ~= 0) then
				local puncherPos = puncher:getpos()
				puncher:setpos({x = puncherPos.x + direction.x, y = puncherPos.y + direction.y, z = puncherPos.z + direction.z})
				PunchDebounces[puncher] = true
				minetest.after(0.5, function(...)
					PunchDebounces[puncher] = nil
				end)
			end
		end

		return on_punch_old(pos, node, puncher, pointed_thing) -- Added to avoid conflict with other mods
	end)
})

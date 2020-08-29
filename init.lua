meseport = {} -- Add a table so other mods are aware of it.

local ActionBlockType = "default:goldblock"
local NodePowers = {["default:mese"] = 100}
local AxisDirections = {'x', 'y', 'z'}
local Polarities = {-1, 1}

local on_punch_old = ItemStack(ActionBlockType):get_definition().on_punch -- Added to avoid conflicts with other mods.
local PunchDebounces = {}

minetest.override_item(ActionBlockType, {
	on_punch = function(pos, node, puncher, pointed_thing)
		if not PunchDebounces[puncher] then
			local power = {x = 0, y = 0, z = 0}
			local readPos = {x = pos.x, y = pos.y, z = pos.z}
			
			-- Figure out the relative position to teleport.
			for _, axis in ipairs(AxisDirections) do
				for _, polarity in ipairs(Polarities) do
					local readNode = nil
					repeat
						readPos[axis] = readPos[axis] + polarity
						readNode = minetest.get_node(readPos).name
						power[axis] = power[axis] + (NodePowers[readNode] or 0) * polarity
					until NodePowers[readNode] == nil
					readPos[axis] = pos[axis]
				end
			end
			
			-- Teleport the player
			if power.x ~= 0 or power.y ~= 0 or power.z ~= 0 then
				local puncherPos = puncher:getpos()
				puncher:setpos({x = puncherPos.x + power.x, y = puncherPos.y + power.y, z = puncherPos.z + power.z})
				PunchDebounces[puncher] = true
				minetest.after(0.5, function(...)
					PunchDebounces[puncher] = nil
				end)
			end
		end

		return on_punch_old(pos, node, puncher, pointed_thing) -- Added to avoid conflicts with other mods.
	end,
})

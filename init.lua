meseport = {} -- Add a table so other mods are aware of it.

local PunchDebounces = {}
local AxisDirections = {'x', 'y', 'z'}
local Polarities = {-1, 1}

meseport.nodepowers = {}
local NodePowers = meseport.nodepowers

function meseport.register_nodepower(node_name, power_level)
	assert(minetest.registered_nodes[node_name] ~= nil, "Argument 1 must be the name of a node type registered prior to calling 'meseport.register_nodepower'.")
	
	if power_level == nil or power_level == false then
		meseport.nodepowers[node_name] = nil
		return
	end
	assert(type(power_level) == "number", "Argument 2 must be a number or the values 'nil' or 'false'.")
	meseport.nodepowers[node_name] = power_level
end

function meseport.register_actionblock(ActionBlockType)
	local nodeDefinition = minetest.registered_nodes[ActionBlockType]
	assert(nodeDefinition ~= nil, "Argument 1 must be the name of a node type registered prior to calling 'meseport.register_actionblock'.")
	local on_punch_old = nodeDefinition.on_punch -- Added to avoid conflicts with other mods.
	
	minetest.override_item(ActionBlockType, {
		on_punch = function(pos, node, puncher, pointed_thing)
			if not PunchDebounces[puncher] and not puncher:get_player_control()["sneak"] then
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
					local puncherPos = puncher:get_pos()
					puncher:set_pos({x = puncherPos.x + power.x, y = puncherPos.y + power.y, z = puncherPos.z + power.z})
					PunchDebounces[puncher] = true
					minetest.after(0.5, function(...)
						PunchDebounces[puncher] = nil
					end)
				end
			end
	
			return on_punch_old(pos, node, puncher, pointed_thing) -- Added to avoid conflicts with other mods.
		end,
		
		_meseport_on_punch_old = on_punch_old,
	})
end

function meseport.unregister_actionblock(ActionBlockType)
	local nodeDefinition = minetest.registered_nodes[ActionBlockType]
	assert(nodeDefinition ~= nil, "Argument 1 must be the name of a node type registered prior to calling 'meseport.unregister_actionblock'.")
	local on_punch_old = nodeDefinition._meseport_on_punch_old
	if on_punch_old == nil then
		return -- was never registered
	end
	
	minetest.override_item(ActionBlockType, {
		on_punch = on_punch_old,
	})
end

-- Support Minetest_Game
if minetest.get_modpath("default") then
	meseport.register_nodepower("default:mese", 100)
	meseport.register_actionblock("default:goldblock")
end

-- Support MineClone2
if minetest.get_modpath("mcl_core")
	and minetest.get_modpath("mesecons_torch")
	and minetest.registered_nodes["mesecons_torch:redstoneblock"] then

	meseport.register_nodepower("mesecons_torch:redstoneblock", 100)
	meseport.register_actionblock("mcl_core:goldblock")
end
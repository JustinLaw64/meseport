# Meseport

### A mod for [Minetest](http://www.minetest.net)

When used with the "default" mod, this mod allows you to teleport by means of Mese and Gold structures.
You punch a gold block that's next to Mese to teleport 100 meters in the
direction that the Mese is located relative to the gold block. Each
additional Mese added in a straight line adds an additional 100 meters.
You can also add Mese to multiple sides in such a way to go in diagonal
directions! However, Mese on opposing sides cancel each other.

* Sneak-punching the gold block will allow it to be dug without being teleported.

* If MineClone2 is the base game, gold blocks and Redstone blocks will be used as a substitute for gold and Mese blocks.

* If the default mod isn't present and MineClone2 isn't the base game, another mod must use Meseport's API to set its nodes.

### License: CC0

## API

``meseport.register_actionblock(node_name)`` - Sets a particular node type to trigger a Meseport teleport when punched. When the default mod is installed it will automatically be called on `default:goldblock`.

``meseport.unregister_actionblock(node_name)`` - The opposite of the above, unregisters a particular node type and restores its old behaviour.

``meseport.register_nodepower(node_name, power_level)`` - Determines how far an adjacent node of a particular type will send the puncher. Setting a power_level of ``nil`` or ``false`` will disable this node's use with this mod. Setting it to 0 means it can still be part of the chain of nodes that determine the actionblock's teleport range but won't contribute to it.

``meseport.nodepowers`` - The table storing registered nodepowers. For example, when the default mod is installed this table will be:

	{
		["default:mese"] = 100
	}

Use ``meseport.register_nodepower`` to modify the values here.

# Special Thanks

* oscar14 for the Gold-Mese-Transport idea!
* FaceDeer for the added API and compatibility with MineClone2!
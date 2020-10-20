# Meseport

### A mod for [Minetest](http://www.minetest.net)

When used with the "default" mod, this mod allows you to teleport by means of Mese and Gold structures.
You punch a gold block that's next to Mese to teleport 100 meters in the
direction that the Mese is located relative to the gold block. Each
additional Mese added in a straight line adds an additional 100 meters.
You can also add Mese to multiple sides in such a way to go in diagonal
directions! However, Mese on opposing sides cancel each other. Thanks to
oscar14 for the Gold-Mese-Transport idea!

If Mineclone2 is installed, this mod will instead use gold blocks and Redstone blocks for teleportation.

If neither of these mods are is not installed, another mod will need to use meseport's API to set what nodes it uses.

## API

``meseport.register_actionblock(node_name)`` - A method that sets a particular node type to trigger a meseport teleport when punched. When the default mod is installed it will automatically be called with ``meseport.register_actionblock("default:goldblock")``.

``meseport.nodepowers`` - A table that determines how far an adjacent node of a particular type will send the puncher. For example, when the default mod is installed this table will be:

	{
		["default:mese"] = 100
	}

### License: CC0

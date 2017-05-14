PowerTools API
==============
The PowerTools mod provides a simple API enabling you to create, remove, and use powertools.

`powertools.set(player, chatcommand)`

* Transform the wielded item into a powertool
* `player`: PlayerRef or player username
* `chatcommand`: Full chatcommand to execute (including parameters and slash)

`powertools.unset(itemstack)`

* Returns an itemstack with all powertool data removed
* `itemstack`: Powertool itemstack (typically `player:get_wielded_item()`)

`powertools.use(player, pointed_thing)`

* Use the wielded powertool
* `player`: PlayerRef (not string)
* `pointed_thing`: Table containing `under` and `above` positions (provided as a parameter to function in `minetest.register_on_punchnode`)
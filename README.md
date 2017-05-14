![Screenshot](.gh-screenshot.png)

PowerTools [powertools]
=======================
* GitHub: https://github.com/octacian/powertools
* Download: https://github.com/octacian/powertools/archive/master.zip
* Forum: https://forum.minetest.net/viewtopic.php?f=9&t=17602

PowerTools allows players with the `powertools` privilege to assign a chatcommand to any item in their hotbar which will be executed whenever they punch any node. This allows quickly assigning things like `/time 6000` to an item which will be executed whenever you punch anything.

Any instances of `@p` inside the chatcommand to be called are replaced with the player's current position, while instances of `@n` are replaced with the position of the node punched, allowing dynamic commands to be assigned to the items.

When a PowerTool is assigned, the description of the item is changed to display both that it is a PowerTool and the command assigned to it. Whenever a PowerTool is dropped and picked up by another player who is not the owner, the tool will not work and instead the PowerTools status will be removed. __Note:__ PowerTools do not allows players to execute chatcommands without privileges, so the above is simply a safeguard.

PowerTools can only be assigned or unassigned if they are selected in the player's hotbar as the `get_wielded_item` methods are used to reference the itemstack which is to be modified as a PowerTool.

#### Usage
```
/powertool <chatcommand/"unset">
```

Chatcommand is the chatcommand to be executed when punching a node with the tool in hand (with beginning slash) or "unset", causing the PowerTool status of the item held to be removed. __Note:__ If unset is called on a non-powertool item nothing will be changed.
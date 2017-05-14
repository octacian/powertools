-- powertools/init.lua

powertools = {}

local delay = {}
local use_delay = tonumber(minetest.setting_get("powertools.delay")) or 0.2

---
--- API
---

-- [local function] Get description
local function get_item_desc(stack)
  if not stack:is_known() then
		return
	end

  return minetest.registered_items[stack:get_name()].description
end

-- [local function] Position to string
local function pos_to_string(pos)
  return pos.x.." "..pos.y.." "..pos.z
end

-- [function] Set power tool
function powertools.set(player, chatcommand)
  if type(player) == "string" then
    player = minetest.get_player_by_name(player)
  end

  local stack = player:get_wielded_item()
  local meta  = stack:get_meta()
  local desc  = get_item_desc(stack)

  if not stack:is_known() then
		return
	end

  -- Update description
  meta:set_string("description", minetest.colorize("red", "POWERTOOL ")..desc
      .."\n"..minetest.colorize("grey", "Command: "..chatcommand))
  -- Set powertool meta
  meta:set_string("powertool", chatcommand)
  -- Set owner
  meta:set_string("powertool_owner", player:get_player_name())

  -- Update stack
  player:set_wielded_item(stack)

  return minetest.colorize("red", "[POWERTOOLS] ")..desc.." is now a powertool!"
end

-- [function] Remove power tool
function powertools.unset(stack)
  local meta  = stack:get_meta()
  local desc  = get_item_desc(stack)
  local pt    = meta:get_string("powertool")

  if pt and pw ~= "" then
    -- Clear description
    meta:set_string("description", nil)
    -- Clear powertool meta
    meta:set_string("powertool", nil)
    -- Clear owner
    meta:set_string("powertool_owner", nil)
  end

  return stack
end

-- [function] Use power tool
function powertools.use(player, pointed_thing)
  local stack = player:get_wielded_item()
  local meta  = stack:get_meta()
  local tool  = meta:get_string("powertool")

  -- Check owner
  if player:get_player_name() ~= meta:get_string("powertool_owner") then
    player:set_wielded_item(powertools.unset(stack))
    return false, "You don't own this PowerTool, removed!"
  end

  if tool and tool ~= "" then
    -- Replace "@p"
    tool = tool:gsub("@p", pos_to_string(player:getpos()))
    -- Replace "@n"
    tool = tool:gsub("@n", pos_to_string(pointed_thing.under))

    -- Separate command and parameters
    tool = tool:split(" ")
    local cmd  = tool[1]:sub(2, -1)
    table.remove(tool, 1)
    local param = table.concat(tool, " ")

    -- Execute command
    local command = minetest.registered_chatcommands[cmd]
    if command then
      return command.func(player:get_player_name(), param)
    else
      return false, "Invalid chatcommand"
    end
  end
end

---
--- Registrations
---

-- [priv] powertools
minetest.register_privilege("powertools", {
  description = "Ability to use /powertool chatcommand",
  give_to_singleplayer = false,
})

-- [chatcommand] /powertool
minetest.register_chatcommand("powertool", {
  description = "Make the current item a power tool",
  params = "<chatcommand/\"unset\"> | Chatcommand to execute when punching a node with the tool in hand (@p indicates player position, @n indicates punched node position), unsets PowerTool",
  privs = {powertools=true},
  func = function(name, param)
    if not param or param == "" then
      return false, "Invalid usage (see /help powertool)"
    elseif param == "unset" then
      local player = minetest.get_player_by_name(name)
      player:set_wielded_item(powertools.unset(player:get_wielded_item()))
      return false, minetest.colorize("red", "[POWERTOOLS] ")
          .." Removed PowerTool!"
    end

    return true, powertools.set(name, param)
  end,
})

-- [register] Globalstep
minetest.register_globalstep(function(dtime)
  for _, i in pairs(delay) do
    delay[_] = i + dtime
  end
end)

-- [register] On punch node
minetest.register_on_punchnode(function(pos, node, player, pointed_thing)
  local stack = player:get_wielded_item()
  local meta  = stack:get_meta()
  local tool  = meta:get_string("powertool")
  local name  = player:get_player_name()

  if tool and tool ~= "" then
    if not delay[name] or delay[name] > use_delay then
      local ok, msg = powertools.use(player, pointed_thing)
      if type(msg) ~= "string" then
        msg = dump(msg)
      end

      minetest.chat_send_player(player:get_player_name(),
          minetest.colorize("red", "[POWERTOOLS] ")..msg)

      -- Start delay counter
      delay[name] = 0
    end
  end
end)

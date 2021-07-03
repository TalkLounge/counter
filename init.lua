-- clientmods/counter/init.lua
-- =================
-- See README.md for licensing and other information.

local mod_storage = minetest.get_mod_storage()
local ip = minetest.get_server_info().ip
local port = minetest.get_server_info().port
local timer = 0

local function get_id(action)
	if ip == "localhost" or ip == "127.0.0.1" or ip == "0:0:0:0:0:0:0:0" then
		return "singleplayer_".. action
	end
	return ip .."-".. port .."_".. action
end

local function get_action(action)
	return mod_storage:get_int(get_id(action)) or 0
end

local function increase_count(action)
	local count = get_action(action)
	count = count + 1
	mod_storage:set_int(get_id(action), count)
end

minetest.register_on_dignode(function(pos, node)
		increase_count("dig")
end)

minetest.register_on_placenode(function(pointed_thing, node)
    increase_count("place")
end)

if type(minetest.register_on_sending_chat_messages) == "function" then
	minetest.register_on_sending_chat_messages(function(message)
			increase_count("chat")
		end)
else
	minetest.register_on_sending_chat_message(function(message)
			increase_count("chat")
	end)
end

minetest.register_on_death(function()
    increase_count("death")
end)

local function on_connected()
	if not minetest.localplayer then
		return minetest.after(0, on_connected)
	end
	increase_count("connect")
end

on_connected()

minetest.register_globalstep(function(dtime)
    if minetest.localplayer then
			timer = timer + dtime
			if timer >= 60 then
				timer = 0
				increase_count("time")
			end
		end
end)

minetest.register_chatcommand("counter", {
    description = "Show your stats",
    func = function()
      local time_count = get_action("time")
			
      if time_count >= 1440 then
        time_count = math.floor((time_count / 1440) * 100)/100 .." days"
      elseif time_count >= 60 then
        time_count = math.floor((time_count / 60) * 100)/100 .." hours"
      else
        time_count = time_count .." minutes"
      end
			
      minetest.show_formspec("counter:count",
        "size[1.9,3]" ..
        "label[0.65,0;Stats]" ..
        "label[0.2,0.2;On this server you ..]"..
        "label[0,0.6;.. dug ".. get_action("dig") .." blocks.]" ..
        "label[0,0.9;.. placed ".. get_action("place") .." blocks.]" ..
        "label[0,1.2;.. sent ".. get_action("chat") .." chat messages.]" ..
        "label[0,1.5;.. died ".. get_action("death") .." times.]" ..
        "label[0,1.8;.. connected ".. get_action("connect") .." times.]" ..
        "label[0,2.1;.. played for ".. time_count ..".]" ..
        "button_exit[0.5,2.9;0.9,0.1;e;Exit]")
end})


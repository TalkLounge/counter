-- clientmods/counter/init.lua
-- =================
-- See README.txt for licensing and other information.

local mod_storage = minetest.get_mod_storage()
local ip = minetest.get_server_info().ip
local port = minetest.get_server_info().port
local dig = ip .."-".. port .."_dig"
local place = ip .."-".. port .."_place"
local chat = ip .."-".. port .."_chat"
local death = ip .."-".. port .."_death"
local connect = ip .."-".. port .."_connect"

if mod_storage:get_int(dig) == nil then
  mod_storage:set_int(dig, 0)
end

if mod_storage:get_int(place) == nil then
  mod_storage:set_int(place, 0)
end

if mod_storage:get_int(chat) == nil then
  mod_storage:set_int(chat, 0)
end

if mod_storage:get_int(death) == nil then
  mod_storage:set_int(death, 0)
end

if mod_storage:get_int(connect) == nil then
  mod_storage:set_int(connect, 0)
end


minetest.register_on_dignode(function(pos, node)
    local number = mod_storage:get_int(dig)
    mod_storage:set_int(dig, number + 1)
  end)

minetest.register_on_placenode(function(pointed_thing, node)
    local number = mod_storage:get_int(place)
    mod_storage:set_int(place, number + 1)
  end)

minetest.register_on_sending_chat_messages(function(message)
    local number = mod_storage:get_int(chat)
    mod_storage:set_int(chat, number + 1)
  end)

minetest.register_on_death(function()
    local number = mod_storage:get_int(death)
    mod_storage:set_int(death, number + 1)
  end)

minetest.register_on_connect(function()
    local number = mod_storage:get_int(connect)
    mod_storage:set_int(connect, number + 1)
  end)

minetest.register_chatcommand("counter", {
    description = "Show your stats",
    func = function()
      local number_dig = mod_storage:get_int(dig)
      local number_place = mod_storage:get_int(place)
      local number_chat = mod_storage:get_int(chat)
      local number_death = mod_storage:get_int(death)
      local number_connect = mod_storage:get_int(connect)
      minetest.show_formspec("counter:count",
        "size[1.9,2.7]" ..
        "label[0.65,0;Stats]" ..
        "label[0.2,0.2;On this server you ...]"..
        "label[0,0.6;... digged ".. number_dig .." blocks.]" ..
        "label[0,0.9;... placed ".. number_place .." blocks.]" ..
        "label[0,1.2;... send ".. number_chat .." chat messages.]" ..
        "label[0,1.5;... died ".. number_death .." times.]" ..
        "label[0,1.8;... connect ".. number_connect .." times.]" ..
        "button_exit[0.5,2.6;0.9,0.1;e;Exit]")
  end})


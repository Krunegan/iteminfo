--[[

The MIT License (MIT)
Copyright (C) 2023 Acronymmk

Permission is hereby granted, free of charge, to any person obtaining a copy of this
software and associated documentation files (the "Software"), to deal in the Software
without restriction, including without limitation the rights to use, copy, modify, merge,
publish, distribute, sublicense, and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.

]]

minetest.register_chatcommand("iteminfo", {
    params = "",
    description = "Shows information about the item in use",
    func = function(name)
        local player = minetest.get_player_by_name(name)
        local stack = player:get_wielded_item()
        local itemdef = stack:get_definition()
        local tool_capabilities = itemdef.tool_capabilities
        local groups = itemdef.groups
        local line = 3.6
    
        local formspec = "size[18,6]" ..
        "item_image[0,0;7,7;" .. itemdef.name .. "]" ..
        "background[-0.15,-0.2;18.3,6.65;iteminfo_background.png]"..
        "box[0,0;5.6,6.1;#030303]" ..
        "box[5.9,0;11.85,6.1;#030303]" ..
        "box[5.9,0;11.85,6.1;#030303]" ..
        -- "box[5.9,3.52;11.85,2.59;#030303]" ..
        "label[6,0;"..minetest.colorize("#01B5F7", "Name: ") .. minetest.colorize("orange", itemdef.description) .. "]" ..
        "label[6,0.6;"..minetest.colorize("#01B5F7", "String: ") ..minetest.colorize("orange", stack:to_string()) .. "]"
    
        if stack:is_known() and stack:get_count() > 0 then
        formspec = formspec .. "label[6,1.2;"..minetest.colorize("#01B5F7", "Amount: ") ..  minetest.colorize("orange", stack:get_count()) .. "]"
        end
    
        if tool_capabilities and tool_capabilities.full_punch_interval and tool_capabilities.max_drop_level then
        formspec = formspec .. "label[6,3;"..minetest.colorize("#01B5F7", "Full punch interval: ").. minetest.colorize("orange", tool_capabilities.full_punch_interval) .. "]"
        formspec = formspec .. "label[6,2.4;" .. minetest.colorize("#01B5F7", "Max drop level: ") .. minetest.colorize("orange", tool_capabilities.max_drop_level) .. "]"
        end
    
        if groups then
        formspec = formspec .. "label[6,1.8;"..minetest.colorize("#01B5F7", "Groups: ")..minetest.colorize("orange", minetest.serialize(groups)) .. "]"
        end
    
        if tool_capabilities and tool_capabilities.groupcaps then
        formspec = formspec .. "label[6,3.6;"..minetest.colorize("#01B5F7", "Group capabilities: ").."]"
        for group, capabilities in pairs(tool_capabilities.groupcaps) do
            line = line + 0.6
            formspec = formspec .. "label[6," .. line .. ";" ..minetest.colorize("yellow", group) .. ": " .. minetest.colorize("orange", minetest.serialize(capabilities)) .. "]"
        end
        end
    
        minetest.show_formspec(name, "iteminfo", formspec)
    end,
 
 })
 
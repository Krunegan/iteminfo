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
        local desc = itemdef.description

        if string.len(desc) > 44 then
            desc = ""
            local i = 1
            while i <= string.len(itemdef.description) do
                desc = desc .. string.sub(itemdef.description, i, i + 44) .. "\n"
                i = i + 44
            end
        else
            desc = itemdef.description
        end

        local formspec = "size[10,3]" ..
        "bgcolor[#080808BB;true]" ..
        "background9[0,0;10,3;iteminfo_bg.png;true]"..
        "item_image[0,0;3.35,3.5;" .. itemdef.name .. "]" ..
        "box[0,0;2.7,3.05;#020202]" ..
        "box[3,0;6.8,3;#020202]" ..
        "textarea[3.3,0;7,3.65;;;" ..
        minetest.colorize("#01B5F7", "Name: ") .. minetest.colorize("orange", desc) ..
        "\n" ..
        minetest.colorize("#01B5F7", "String: ") .. stack:to_string() ..
        "\n" ..
        (stack:is_known() and stack:get_count() > 0 and minetest.colorize("#01B5F7", "Amount: ") .. minetest.colorize("orange", stack:get_count()) or "") ..
        "\n" ..
        (tool_capabilities and tool_capabilities.full_punch_interval and tool_capabilities.max_drop_level and tool_capabilities.damage_groups and
            minetest.colorize("#01B5F7", "Full punch interval: ") .. minetest.colorize("orange", tool_capabilities.full_punch_interval) ..
            "\n" ..
            minetest.colorize("#01B5F7", "Max drop level: ") .. minetest.colorize("orange", tool_capabilities.max_drop_level) ..
            "\n" ..
            minetest.colorize("#01B5F7", "Damage groups: ") .. minetest.serialize(tool_capabilities.damage_groups) or "") ..
        "\n" ..
        (groups and minetest.colorize("#01B5F7", "Groups: ") .. minetest.serialize(groups) or "") ..
        "\n" ..
        (tool_capabilities and tool_capabilities.groupcaps and minetest.colorize("#01B5F7", "Group capabilities: ") or "")
        
        if tool_capabilities and tool_capabilities.groupcaps then
            for group, capabilities in pairs(tool_capabilities.groupcaps) do
                formspec = formspec .. group .. ": " .. minetest.serialize(capabilities).. "\n"
            end
        end

        formspec = formspec .. "]"

        minetest.show_formspec(name, "iteminfo", formspec)
    end,
})

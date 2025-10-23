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

local S = minetest.get_translator(minetest.get_current_modname())

minetest.register_chatcommand("iteminfo", {
    params = "",
    description = S("Shows information about the wielded item"),
    func = function(name)
        local player = minetest.get_player_by_name(name)
        local stack = player:get_wielded_item()
        local itemdef = stack:get_definition()
        local tool_capabilities = stack:get_tool_capabilities()
        local groups = itemdef.groups
        local line = 3.6
        local desc = stack:get_short_description()

        local formspec_table = {}
        local C; function C(t) table.insert(formspec_table, t) return C end

        C"size[10,3]"
        C"bgcolor[#080808BB;true]"
        C"formspec_version[3]"
        C"background9[0,0;10,3;iteminfo_bg.png;true]"
        C"box[0,0;2.7,3.05;#020202]"
        C"box[3,0;6.8,3;#020202]"
        C"item_image[0,0;3.35,3.5;" (itemdef.name) "]"
        C"textarea[3.3,0;7,3.65;;;"
        C(minetest.colorize("#01B5F7", S("Name: @1", desc)))
        C"\n"
        if stack:is_known() and stack:get_count() > 1 then
            --TL: @1 is a whole number
            C(minetest.colorize("#01B5F7", S("Amount: @1", stack:get_count())))
            C"\n"
        end
        C"\n"
        C(minetest.colorize("#01B5F7", S("String: @1", stack:to_string())))
        C"\n\n"
        if tool_capabilities and tool_capabilities.full_punch_interval
        and tool_capabilities.max_drop_level and tool_capabilities.damage_groups then
            --TL: @1 is in seconds
            C(minetest.colorize("#01B5F7", S("Full punch interval: @1s", tool_capabilities.full_punch_interval)))
            C"\n"
            --TL: @1 is a whole number
            C(minetest.colorize("#01B5F7", S("Max drop level: @1", tool_capabilities.max_drop_level)))
            C"\n"
            C(minetest.colorize("#01B5F7", S("Damage groups: @1", dump(tool_capabilities.damage_groups))))
        end
        C"\n\n"
        if groups then
            C(minetest.colorize("#01B5F7", S("Groups: @1", dump(groups))))
        end
        C"\n\n"
        if tool_capabilities and tool_capabilities.groupcaps then
            C(minetest.colorize("#01B5F7", S("Group capabilities: @1", dump(tool_capabilities.groupcaps))))
        end

        C"]"

        minetest.show_formspec(name, "iteminfo", table.concat(formspec_table))
    end,
})

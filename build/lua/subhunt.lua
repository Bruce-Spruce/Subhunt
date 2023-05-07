-- this might only work for linux currently
package.path = package.path .. ";" .. os.getenv("PWD") .. "/lua/?.lua"
-- this makes it so we can store our files in a separate dir other than executable


require "destroyer"
require "submanager"
require "depthcharge"

recs_to_draw = {}
tris_to_draw = {}

local ship
local sub_manager
local charges

function setup()

        sub_manager = SubManager:new()
        ship = Destroyer:new({}, screen_width)
        charges = {}
end

last_key = -2

function main(key)

        if key == 0 then
                ship:move_left(delta_time)
        elseif key == 1 then
                ship:move_right(delta_time)
        elseif key == 2  and last_key ~= 2 then
                if #charges < 3 then
                        charge = DepthCharge:new()
                        charge:init(ship:get_center())
                        charges[#charges+1] = charge
                end

        elseif key == -2 then
                setup()
        end

        for i, charge in pairs(charges) do
                charge:move(delta_time)
                if charge:past_bottom(screen_height) then
                        table.remove(charges, i)
                end
                charge_center = charge:get_center()
                for j, sub in pairs(sub_manager["subs"]) do
                        p1x = sub["rect_pieces"][1]
                        p1y = sub["rect_pieces"][2]
                        p2x = sub["rect_pieces"][3]
                        p2y = sub["rect_pieces"][4]

                        if ((p1x <= charge_center["x"] and charge_center["x"] <= p2x) and (p1y <= charge_center["y"] and charge_center["y"] <= p2y)) then
                                -- score = score + 10 * j
                                table.remove(charges, i)
                                sub_manager["subs"][j] = nil
                        end
                end
        end

        -- add things that need drawn to tables
        recs_to_draw = add_tables({}, ship["rect_pieces"])

        for _, sub in pairs(sub_manager["subs"]) do
                recs_to_draw = add_tables(recs_to_draw, sub["rect_pieces"])
        end

        for _, charge in pairs(charges) do
                recs_to_draw = add_tables(recs_to_draw, charge["charge"])
        end

        tris_to_draw = add_tables({}, ship["tri_pieces"])

        sub_manager:make_sub(delta_time, screen_width) -- update submarines
        sub_manager:move_subs(delta_time, screen_width)

        last_key = key
end

function get_rects()
        return recs_to_draw
end

function get_tris()
        return tris_to_draw
end

function add_tables(t1, t2)
        local result = {}
        for _,v in pairs ( t1 ) do
                table.insert( result, v )
        end
        for _,v in pairs ( t2 ) do
                table.insert( result, v )
        end
        return result
end

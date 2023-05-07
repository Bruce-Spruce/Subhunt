

require "submarine"

SubManager = {}
-- meta class

function SubManager:new(o)

    o = o or {}
    setmetatable(o, self)
    self.__index = self

    self.make_prob = 0.5

    self.subs = {nil, nil, nil, nil, nil, nil}

    return o

end

function SubManager:move_subs(delta_time, screen_width)
    for i,sub in pairs(self.subs) do
        sub:move(delta_time)
        if sub:off_screen(screen_width) then
            self.subs[i] = nil
        end
    end
    -- negative 1 means dont remove that index from the draw area? do i need this?
    return
end

function SubManager:make_sub(delta_time, width)
    if math.random() < (self.make_prob * delta_time) then
        lane = math.random(1, 6)
        if self.subs[lane] == nil then
            s = Submarine:new()
            s:init(lane-1, width)
            self.subs[lane] = s
            end
        end
end

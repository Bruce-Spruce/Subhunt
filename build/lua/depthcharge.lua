
DepthCharge = {}
-- meta class

function DepthCharge:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    return o
end

function DepthCharge:init(center)
    self.velocity = 150
    self.charge = self:create_charge(center)
end

function DepthCharge:create_charge(center)
    return {center["x"] - 3, center["y"] - 3, center["x"] + 3, center["y"] + 3}
end

function DepthCharge:move(delta_time)
    self.charge[2] = self.charge[2] + (self.velocity * delta_time)
    self.charge[4] = self.charge[4] + (self.velocity * delta_time)
end

function DepthCharge:past_bottom(height)
    return self.charge[2] > height
end

function DepthCharge:get_center()
    return { ["x"] = self.charge[1] + 3, ["y"] = self.charge[2] + 1.5 }
end


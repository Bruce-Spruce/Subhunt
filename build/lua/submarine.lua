
Submarine = {}
-- meta class

math.randomseed(os.time()) -- random doesn't get random seed on its own

function Submarine:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    return o
end

-- because OBJ:new(o) self is for class not instance
function Submarine:init(y, screen_width)
    self.side = math.random(0, 1)
    if self.side == 1 then
        self.vel = -math.random(50, 100) * 1.5
    else
        self.vel = math.random(50, 100) * 1.5
    end

    self.rect_pieces = self:create_rect_pieces(y, screen_width)

end

function Submarine:create_rect_pieces(y, screen_width)

    local height = 10

    pieces = { self.side * screen_width - 25,
               (200 - height) + (y * 100),
               self.side * screen_width + 25,
               (200 + height) + (y * 100) }

    return pieces
end

function Submarine:move(delta_time)
    self.rect_pieces[1] = self.rect_pieces[1] + self.vel * delta_time
    self.rect_pieces[3] = self.rect_pieces[3] + self.vel * delta_time
end

function Submarine:off_screen(width)
    if self.side == 1 then
        return self.rect_pieces[3] < 0
    else
         return self.rect_pieces[1] > width
    end
end



-- meta class
Destroyer = {}

function Destroyer:new(o, width)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    self.velocity = 100
    self.center = width / 2

    self.rect_pieces = self:create_rect_pieces(width)
    self.tri_pieces = self:create_tri_pieces(width)

    return o

end

function Destroyer:create_rect_pieces(screen_width)

    local center = screen_width / 2
    local width = 25

    pieces = { center - width,
               150,
               center + width,
               135,
               center - width + 10,
               135,
               center + width - 10,
               125 }

    return pieces
end

function Destroyer:create_tri_pieces(screen_width)

    local center = screen_width / 2
    local width = 25  -- width not instance var

    local pieces = { center - width,
                    150,
                    center - width,
                    135,
                    center - width * 2,
                    135,

                    center + width,
                    150,
                    center + width,
                    135,
                    center + width * 2,
                    135 }

    return pieces
end

function Destroyer:move_left(delta_time)
    for i=1, 7, 2 do
        self.rect_pieces[i] = self.rect_pieces[i] - self.velocity * delta_time
    end

    for i=1, 11, 2 do
        self.tri_pieces[i] = self.tri_pieces[i] - self.velocity * delta_time
    end

end

function Destroyer:move_right(delta_time)
    for i=1, 7, 2 do
        self.rect_pieces[i] = self.rect_pieces[i] + self.velocity * delta_time
    end

    for i=1, 11, 2 do
        self.tri_pieces[i] = self.tri_pieces[i] + self.velocity * delta_time
    end

end

function Destroyer:get_center()
    -- 25 is width of destroyer ("magic number")
    return { ["x"] = self.rect_pieces[1] + 25, ["y"] = self.rect_pieces[2] }
end

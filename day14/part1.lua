-- AOC 2024 Day 14 Part 1
-- done on 1/4/24

local Robot = {}
Robot.ROWS = 103
Robot.COLS = 101
Robot.HALF_ROWS = math.floor(Robot.ROWS / 2)
Robot.HALF_COLS = math.floor(Robot.COLS / 2)

function Robot:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Robot:quadrant_after(sec)
    self.x = (self.x + self.x_vel * sec) % Robot.ROWS
    self.y = (self.y + self.y_vel * sec) % Robot.COLS

    if self.x < Robot.HALF_ROWS then
        if self.y < Robot.HALF_COLS then
            return 1
        elseif self.y > Robot.HALF_COLS then
            return 2 end
    elseif self.x > Robot.HALF_ROWS then
        if self.y < Robot.HALF_COLS then
            return 3
        elseif self.y > Robot.HALF_COLS then
            return 4 end
    end

    return 0
end

-- input
local robots = {}
for line in io.lines("input.txt") do
    local y, x, y_vel, x_vel = line:match("p=([-]?%d+),([-]?%d+) v=([-]?%d+),([-]?%d+)")
    table.insert(robots, Robot:new({
        x = tonumber(x),
        y = tonumber(y),
        x_vel = tonumber(x_vel),
        y_vel = tonumber(y_vel)
    }))
end

-- simulate 100 seconds
local seconds = 100
local quadrants = {
    [0] = 0,
    [1] = 0,
    [2] = 0,
    [3] = 0,
    [4] = 0,
}
for _, r in ipairs(robots) do
    local quadrant = r:quadrant_after(seconds)
    quadrants[quadrant] = quadrants[quadrant] + 1
end

print(quadrants[1] * quadrants[2] * quadrants[3] * quadrants[4])

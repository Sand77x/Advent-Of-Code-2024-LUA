-- AOC 2024 Day 14 Part 2
-- done on 1/5/24

local Robot = {}
Robot.ROWS = 103 -- 103
Robot.COLS = 101 -- 101
Robot.HALF_ROWS = math.floor(Robot.ROWS / 2)
Robot.HALF_COLS = math.floor(Robot.COLS / 2)

function Robot:new(o)
    if o and o.x and o.y and o.x_vel and o.y_vel then
        setmetatable(o, self)
        self.__index = self
        return o
    end

    return nil
end

function Robot:pos_after_sec(sec)
    local after_x = (self.x + self.x_vel * sec) % Robot.ROWS
    local after_y = (self.y + self.y_vel * sec) % Robot.COLS

    return Robot:new({ x = after_x, y = after_y, x_vel = self.x_vel, y_vel = self.y_vel })
end

function Robot:quadrant()
    if self.x < Robot.HALF_ROWS then
        if self.y < Robot.HALF_COLS then
            return 1
        elseif self.y > Robot.HALF_COLS then
            return 2
        end
    elseif self.x > Robot.HALF_ROWS then
        if self.y < Robot.HALF_COLS then
            return 3
        elseif self.y > Robot.HALF_COLS then
            return 4
        end
    end

    return 0
end

function Robot.print_robots(robots)
    local graph = {}
    for i = 1, Robot.ROWS do
        graph[i] = {}
        for j = 1, Robot.COLS do
            graph[i][j] = "."
        end
    end

    for _, r in ipairs(robots) do
        graph[r.x + 1][r.y + 1] = graph[r.x + 1][r.y + 1] == "." and 1 or graph[r.x + 1][r.y + 1] + 1
    end

    for i = 1, Robot.ROWS do
        print(table.unpack(graph[i]))
    end
end

function Robot.weird(robots)
    local graph = {}
    for i = 1, Robot.ROWS do
        graph[i] = {}
        for j = 1, Robot.COLS do
            graph[i][j] = "."
        end
    end

    for _, r in ipairs(robots) do
        graph[r.x + 1][r.y + 1] = graph[r.x + 1][r.y + 1] == "." and 1 or graph[r.x + 1][r.y + 1] + 1
    end

    local impurity = 0
    local thresh = 9925
    for i = 1, Robot.ROWS do
        for j = 1, Robot.COLS do
            if graph[i][j] == "." then
                impurity = impurity + 1
            end
        end
    end

    return impurity > thresh
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

-- search for easter egg (vertical pattern happen every 66 + 101n, for n >= 0)
-- local max_seconds = 66 + 101 * 2000
-- for i = 66, max_seconds, 101 do
--     local quadrants = {
--         [0] = 0,
--         [1] = 0,
--         [2] = 0,
--         [3] = 0,
--         [4] = 0,
--     }

--     local seconds = i
--     local robots_after = {}
--     for _, r in ipairs(robots) do
--         local after = r:pos_after_sec(seconds)
--         local q = after:quadrant()
--         table.insert(robots_after, after)
--         quadrants[q] = quadrants[q] + 1
--     end

--     print(("SECONDS: %d"):format(i))
--     Robot.print_robots(robots_after)
-- end

-- here is what the correct solution looks like
local seconds = 7338 -- first occurance
print(("SECONDS: %d"):format(seconds))

local robots_after = {}
for _, r in ipairs(robots) do
    table.insert(robots_after, r:pos_after_sec(seconds))
end

Robot.print_robots(robots_after)

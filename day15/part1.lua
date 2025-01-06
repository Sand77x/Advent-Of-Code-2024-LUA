-- AOC 2024 Day 15 Part 1
-- done on 1/6/24

local Solution = {}
Solution.map = {}
Solution.moves = {}
Solution.robot = {}

-- get map input
io.input("input.txt")
local f = io.read("*all")

local split = f:find("\n\n")
local map_str = f:sub(1, split)
local line = {}
for i = 1, #map_str do
    local c = map_str:sub(i, i)
    if c == "\n" then
        table.insert(Solution.map, line)
        line = {}
    else
        table.insert(line, c)
    end
end

-- get move inputs
local movement_str = f:sub(split + 2, #f - 1):gsub("\n", "")
for i = 1, #movement_str do
    table.insert(Solution.moves, movement_str:sub(i, i))
end

-- find robot
for i = 1, #Solution.map do
    for j = 1, #Solution.map[1] do
        if Solution.map[i][j] == "@" then
            Solution.robot = { i, j }
            goto found_robot
        end
    end
end
::found_robot::

local function apply_force(pos, force)
    return { pos[1] + force[1], pos[2] + force[2] }
end

local function apply_opposite_force(pos, force)
    return { pos[1] - force[1], pos[2] - force[2] }
end

local function in_bounds(pos)
    return pos[1] >= 1 and pos[1] <= #Solution.map and pos[2] >= 1 and pos[2] <= #Solution.map[1]
end

local function char_at(pos)
    return Solution.map[pos[1]][pos[2]]
end

local function equals(x, y)
    return x[1] == y[1] and x[2] == y[2]
end

local function set(pos, char)
    Solution.map[pos[1]][pos[2]] = char
end

local function get_gps(pos)
    return 100 * (pos[1] - 1) + pos[2] - 1
end

function Solution.gps()
    local s = Solution.map
    local gps = 0
    for i = 1, #s do
        for j = 1, #s[1] do
            if s[i][j] == "O" then
                gps = gps + get_gps({ i, j })
            end
        end
    end

    return gps
end

function Solution.print_map()
    for i = 1, #Solution.map do
        io.write(table.unpack(Solution.map[i]))
        io.write("\n")
    end
end

-- simulate all moves in the moves list
function Solution.simulate_moves()
    local robot = Solution.robot
    local directions = {
        ["^"] = { -1, 0 },
        ["v"] = { 1, 0 },
        ["<"] = { 0, -1 },
        [">"] = { 0, 1 },
    }

    for _, m in ipairs(Solution.moves) do
        local force = directions[m]
        local blank = apply_force(robot, force)

        -- look for blank spot in direction of move
        while in_bounds(blank) and char_at(blank) == "O" do
            blank = apply_force(blank, force)
        end

        if in_bounds(blank) and char_at(blank) == "." then
            -- blank spot found
            while not equals(blank, robot) do
                set(blank, "O")
                blank = apply_opposite_force(blank, force)
            end
            -- set player position
            set(robot, ".")
            set(apply_force(robot, force), "@")
            robot = apply_force(robot, force)
        end
    end
end

Solution.simulate_moves()
-- Solution.print_map()
print(Solution.gps())

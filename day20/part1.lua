-- AOC 2024 Day 19 Part 1
-- done on 1/14/24

local u = function(x) print(vim.inspect(x)) end
local input = {}
input.map = {}
input.walls = {}

local row = 1
for line in io.lines("input.txt") do
    input.map[row] = {}
    for col = 1, #line do
        local c = line:sub(col, col)
        local entry = {
            x = row,
            y = col,
        }

        if c == "S" then
            input.start = { row, col }
            entry.char = "."
        elseif c == "E" then
            input.goal = { row, col }
            entry.char = "."
        else
            if c == "#" then table.insert(input.walls, { row, col }) end
            entry.char = line:sub(col, col)
        end

        input.map[row][col] = entry
    end

    row = row + 1
end

local function equals(a, b) return a.x == b.x and a.y == b.y end

local function in_bounds(map, p)
    return p[1] >= 1 and p[2] >= 1 and p[1] <= #map and p[2] <= #map[1]
end

local function get_neighbors(map, point)
    local neighbors = {}
    local dirs = { { -1, 0 }, { 1, 0 }, { 0, -1 }, { 0, 1 } }

    for i = 1, 4 do
        local new_point = { point.x + dirs[i][1], point.y + dirs[i][2] }
        if in_bounds(map, new_point) and map[new_point[1]][new_point[2]].char ~= "#"
        then
            table.insert(neighbors, map[new_point[1]][new_point[2]])
        end
    end

    return neighbors
end

local function pop_best(list)
    local best = 1
    for i = 2, #list do
        if list[i].cost < list[best].cost then
            best = i
        end
    end

    local point = list[best]
    table.remove(list, best)
    return point
end

local function set_open(map)
    for i = 1, #map do
        for j = 1, #map[1] do
            map[i][j].open = true
            map[i][j].cost = nil
            map[i][j].parent = nil
        end
    end
end

local best = 1e9

local function in_list(list, item)
    for i = 1, #list do
        if equals(list[i], item) then return true end
    end

    return false
end

local function UCS(map, start, goal)
    set_open(map)

    start = map[start[1]][start[2]]
    goal = map[goal[1]][goal[2]]

    local open = { start }

    start.cost = 0
    start.parent = nil

    while #open >= 1 do
        local current = pop_best(open)

        current.open = false

        if equals(current, goal) then
            return current
        end

        local neighbors = get_neighbors(map, current)

        for i = 1, #neighbors do
            if neighbors[i].open then
                local prev_cost = neighbors[i].cost
                if not prev_cost or prev_cost > current.cost + 1 then
                    neighbors[i].cost = current.cost + 1
                    neighbors[i].parent = current
                end
                if not in_list(open, neighbors[i]) then
                    table.insert(open, neighbors[i])
                end
            end
        end
    end
end

do
    best = 0
    local final = UCS(input.map, input.start, input.goal)
    while final do
        best = best + 1
        final = final.parent
    end
    best = best - 1
end

local ans = 0
for i = 1, #input.walls do
    local cheat = input.walls[i]

    input.map[cheat[1]][cheat[2]].char = "."

    if cheat[1] > 1 and cheat[2] > 1 and cheat[1] < #input.map and cheat[2] < #input.map[1] and
        #get_neighbors(input.map, input.map[cheat[1]][cheat[2]]) >= 2
    then
        local final = UCS(input.map, input.start, input.goal)
        local ps = 0
        while final do
            ps = ps + 1
            final = final.parent
        end

        if ps - 1 <= best - 100 then
            ans = ans + 1
        end
    end

    input.map[cheat[1]][cheat[2]].char = "#"
end

print(ans)

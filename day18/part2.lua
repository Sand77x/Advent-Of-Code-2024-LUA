-- AOC 2024 Day 18 Part 1
-- done on 1/10/24

local S = {}

S.ROWS = 71
S.COLS = 71
S.buffer = {}

function S.print_buffer()
    for i = 1, S.ROWS do
        for j = 1, S.COLS do
            io.write(S.buffer[i][j].char)
        end
        io.write("\n")
    end
end

function S.set_buffer(buffer)
    S.buffer = buffer
end

function S.get_min_cost(list)
    local min = 1
    for i = 2, #list do
        if list[i].cost < list[min].cost then
            min = i
        end
    end
    local pop = list[min]
    table.remove(list, min)
    return pop
end

function S.is_in(list, item)
    for _, v in ipairs(list) do
        if v.x == item.x and v.y == item.y then
            return true
        end
    end
    return false
end

function S.in_bounds(x, y)
    if x >= 1 and x <= S.ROWS and y >= 1 and y <= S.COLS then return true end
    return false
end

function S.get_neighbors(n)
    local neighbors = {}
    if S.in_bounds(n.x, n.y + 1) and S.buffer[n.x][n.y + 1].char ~= "#" then
        table.insert(neighbors, S.buffer[n.x][n.y + 1])
    end
    if S.in_bounds(n.x + 1, n.y) and S.buffer[n.x + 1][n.y].char ~= "#" then
        table.insert(neighbors, S.buffer[n.x + 1][n.y])
    end
    if S.in_bounds(n.x, n.y - 1) and S.buffer[n.x][n.y - 1].char ~= "#" then
        table.insert(neighbors, S.buffer[n.x][n.y - 1])
    end
    if S.in_bounds(n.x - 1, n.y) and S.buffer[n.x - 1][n.y].char ~= "#" then
        table.insert(neighbors, S.buffer[n.x - 1][n.y])
    end
    return neighbors
end

function S.ucs()
    local start = S.buffer[1][1]
    local goal = S.buffer[S.ROWS][S.COLS]

    local open = { start }
    start.cost = 0
    start.parent = nil

    while #open > 0 do
        local current = S.get_min_cost(open)

        if current.x == goal.x and current.y == goal.y then
            return current
        end

        current.open = false

        local neighbors = S.get_neighbors(current)

        for _, n in ipairs(neighbors) do
            if not n.open then
                goto bad_node
            end

            local updated_cost = current.cost + 1

            if not S.is_in(open, n) then
                table.insert(open, n)
            elseif updated_cost >= n.cost then
                goto bad_node
            end

            n.parent = current
            n.cost = updated_cost

            ::bad_node::
        end
    end

    return nil
end

--- main ---

local pos = {}
for line in io.lines("input.txt") do
    local y, x = line:match("(%d+),(%d+)")
    table.insert(pos, {
        x = tonumber(x) + 1,
        y = tonumber(y) + 1,
        char = "#"
    })
end


local function get_nbytes_map(n)
    local map = {}
    for i = 1, S.ROWS do
        map[i] = {}
        for j = 1, S.COLS do
            map[i][j] = {
                x = i,
                y = j,
                cost = 0,
                open = true,
                parent = nil,
                char = "."
            }
        end
    end

    local firstn_pos = table.move(pos, 1, n, 1, {})
    for _, v in ipairs(firstn_pos) do
        map[v.x][v.y] = v
    end

    return map
end

local n = 1024
local final = nil

repeat
    S.set_buffer(get_nbytes_map(n))
    final = S.ucs()
    n = n + 1
until final == nil

print(pos[n - 1].x, pos[n - 1].y)
-- 7, 26
-- flip nums and -1 to get 25, 6 (correct answer)
-- this is very brute force solution, can optimize by only
-- doing UCS if a new byte falls on the best path, else skip it

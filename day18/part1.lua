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

    while open do
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

local firstn_pos = table.move(pos, 1, 1024, 1, {})
for _, v in ipairs(firstn_pos) do
    map[v.x][v.y] = v
end

S.set_buffer(map)

local final = S.ucs()
local ans = 0
while final do
    ans = ans + 1
    final = final.parent
end

print(ans - 1)

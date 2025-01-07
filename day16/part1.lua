-- AOC 2024 Day 16 Part 1
-- done on 1/7/24

local node = require("./node")

local S = {}

--- helper functions ---
S.EAST = 1
S.SOUTH = 2
S.WEST = 3
S.NORTH = 4

function S.in_bounds(x, y)
    return x >= 1 and x <= #S.map and y >= 1 and y <= #S.map[1]
end

function S.get_neighbors(n)
    local neighbors = {}
    if S.in_bounds(n.x, n.y + 1) and S.map[n.x][n.y + 1].char ~= "#" then
        table.insert(neighbors, S.map[n.x][n.y + 1])
    end
    if S.in_bounds(n.x + 1, n.y) and S.map[n.x + 1][n.y].char ~= "#" then
        table.insert(neighbors, S.map[n.x + 1][n.y])
    end
    if S.in_bounds(n.x, n.y - 1) and S.map[n.x][n.y - 1].char ~= "#" then
        table.insert(neighbors, S.map[n.x][n.y - 1])
    end
    if S.in_bounds(n.x - 1, n.y) and S.map[n.x - 1][n.y].char ~= "#" then
        table.insert(neighbors, S.map[n.x - 1][n.y])
    end
    return neighbors
end

function S.get_dir(p, n)
    if p.x < n.x then
        return S.NORTH
    elseif p.x > n.x then
        return S.SOUTH
    elseif p.y < n.y then
        return S.WEST
    elseif p.y > n.y then
        return S.EAST
    else
        print("This shan't happen."); os.exit(1)
    end
end

function S.assign_dirs(n, neighbors)
    for _, nx in ipairs(neighbors) do
        nx.dir = S.get_dir(n, nx)
    end
end

function S.get_min_fcost(list)
    local min = 1
    for i = 2, #list do
        if list[i] < list[min] then
            min = i
        end
    end
    local min_node = list[min]
    table.remove(list, min)
    return min_node
end

local function manhattan_dist(a, b)
    return math.abs(a.x - b.x) + math.abs(a.y - b.y)
end

local function is_in(list, item)
    for _, i in ipairs(list) do
        if i == item then
            return true
        end
    end
    return false
end

--- solution ---

function S.compute_score(n)
    local score = 0
    local dir = S.get_dir(n, n.parent)
    while n.parent do
        score = score + 1
        if S.get_dir(n, n.parent) ~= dir then
            score = score + 1000
            dir = S.get_dir(n, n.parent)
        end
        n = n.parent
    end
    if dir ~= S.WEST then score = score + 1000 end
    return score
end

function S.a_star(start, goal, h)
    local open_list = { start }

    start.gcost = 0
    start.hcost = h(start, goal)
    start.parent = nil
    start.dir = S.EAST

    while open_list do
        local current = S.get_min_fcost(open_list)

        if current == goal then
            return current
        end

        current.open = false

        local neighbors = S.get_neighbors(current)
        S.assign_dirs(current, neighbors)

        for _, neighbor in ipairs(neighbors) do
            if not neighbor.open then
                goto bad_node
            end


            local updated_gcost = current.gcost + current:action_cost(neighbor)

            if not is_in(open_list, neighbor) then
                table.insert(open_list, neighbor)
            elseif updated_gcost >= neighbor.gcost then
                goto bad_node
            end

            neighbor.parent = current
            neighbor.gcost = updated_gcost
            neighbor.hcost = h(neighbor, goal)

            ::bad_node::
        end
    end
end

--- main ---
S.map = {}

local start = nil
local goal = nil

do -- populate map and get start and goal nodes
    local ln = 1
    for line in io.lines("input.txt") do
        local r = {}
        for i = 1, #line do
            local new_node = node:new({ x = ln, y = i, char = line:sub(i, i) })
            if new_node.char == "S" then start = new_node end
            if new_node.char == "E" then goal = new_node end
            table.insert(r, new_node)
        end
        table.insert(S.map, r)
        ln = ln + 1
    end
end

local final_node = S.a_star(start, goal, manhattan_dist)
local ans = S.compute_score(final_node)
print(ans)

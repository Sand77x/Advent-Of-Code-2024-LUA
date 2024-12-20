-- AOC 2024 Day 12 Part 1
-- done on 12/20/24

local map = {}
local visited = {}
for line in io.lines("input.txt") do
    local row = {}
    local vrow = {}
    for i = 1, #line do
        row[i] = line:sub(i, i)
        vrow[i] = false
    end
    table.insert(map, row)
    table.insert(visited, vrow)
end

-- global for counting number of times dfs is called
local area = 0

local directions = { { -1, 0 }, { 0, -1 }, { 0, 1 }, { 1, 0 } }
local function dfs(x, y)
    local p = 0

    visited[x][y] = true
    area = area + 1

    for i = 1, #directions do
        local next = { x + directions[i][1], y + directions[i][2] }
        if next[1] < 1 or next[1] > #map or next[2] < 1 or next[2] > #map[1] then
            p = p + 1
            goto skip
        end

        if map[next[1]][next[2]] ~= map[x][y] then
            p = p + 1
            goto skip
        end

        if map[next[1]][next[2]] == map[x][y] and not visited[next[1]][next[2]] then
            p = p + dfs(next[1], next[2])
        end

        ::skip::
    end

    return p
end

local function find_next_pos()
    for i = 1, #visited do
        for j = 1, #visited do
            if not visited[i][j] then
                return { i, j }
            end
        end
    end

    return nil
end

local ans = 0
local next_pos = { 1, 1 }
while next_pos ~= nil do
    area = 0
    local perimeter = dfs(table.unpack(next_pos))

    ans = ans + area * perimeter

    next_pos = find_next_pos()
end

print(ans)

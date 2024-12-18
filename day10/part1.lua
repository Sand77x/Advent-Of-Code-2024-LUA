-- AOC 2024 Day 10 Part 1
-- done on 12/18/24

local map = {}
for line in io.lines("input.txt") do
    local row = {}
    for i = 1, #line do
        row[i] = tonumber(line:sub(i, i))

        if row[i] == nil then row[i] = -1 end
    end
    table.insert(map, row)
end

local directions = { { -1, 0 }, { 0, -1 }, { 0, 1 }, { 1, 0 } }
local function dfs(x, y, visited_nines)
    if map[x][y] == 9 then
        for i = 1, #visited_nines do
            if visited_nines[i][1] == x and visited_nines[i][2] == y then
                return 0
            end
        end

        table.insert(visited_nines, { x, y })
        return 1
    end

    local nines = 0
    for i = 1, #directions do
        local next = { x + directions[i][1], y + directions[i][2] }
        if next[1] < 1 or next[1] > #map or next[2] < 1 or next[2] > #map[1] then goto skip end

        if map[next[1]][next[2]] == map[x][y] + 1 then
            nines = nines + dfs(next[1], next[2], visited_nines)
        end

        ::skip::
    end

    return nines
end

local ans = 0
for i = 1, #map do
    for j = 1, #map[1] do
        local n = map[i][j]
        local visited_nines = {}

        if n == 0 then
            ans = ans + dfs(i, j, visited_nines)
        end
    end
end

print(tostring(ans))

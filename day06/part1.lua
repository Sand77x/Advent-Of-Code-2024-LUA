-- AOC 2024 Day 6 Part 1
-- done on 12/12/24

local map = {}
for row in io.lines("input.txt") do
    local _row = {}
    for i = 1, #row do
        _row[i] = row:sub(i, i)
    end
    table.insert(map, _row)
end

local guard_pos
for i = 1, #map do
    for j = 1, #map[1] do
        if map[i][j] == "^" then
            map[i][j] = "/"
            guard_pos = { i, j }
        end
    end
end

local directions = { { -1, 0 }, { 0, 1 }, { 1, 0 }, { 0, -1 } }
local directions_idx = 0
local ans = 1

while guard_pos[1] > 1 and guard_pos[1] < #map and guard_pos[2] > 1 and guard_pos[2] < #map[1] do
    local x, y = guard_pos[1] + directions[directions_idx + 1][1], guard_pos[2] + directions[directions_idx + 1][2]

    if map[x][y] == "#" then
        directions_idx = (directions_idx + 1) % 4
    end

    if map[x][y] == "." or map[x][y] == "/" then
        guard_pos = { x, y }
        if map[x][y] == "." then
            ans = ans + 1
            map[x][y] = "/"
        end
    end
end

print(ans)

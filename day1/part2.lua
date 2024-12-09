-- AOC 2024 Day 1 Part 2
-- done on 12/7/24

-- get input
local inp = "input.txt"

local list1 = {}
local list2 = {}

for line in io.lines(inp) do
    local x = string.sub(line, 1, 5)
    local y = string.sub(line, 9, 13)

    table.insert(list1, x)
    table.insert(list2, y)
end

local frequencies = {}

for _, v in ipairs(list2) do
    if frequencies[v] then
        frequencies[v] = frequencies[v] + 1
    else
        frequencies[v] = 1
    end
end

local total = 0
for _, v in ipairs(list1) do
    if frequencies[v] then
        total = total + v * frequencies[v]
    end
end

print(total)

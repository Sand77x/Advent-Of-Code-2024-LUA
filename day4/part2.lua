-- AOC 2024 Day 4 Part 2
-- done on 12/10/24

local input = {}

for line in io.lines("input.txt") do
    local row = {}
    for i = 1, #line do
        row[i] = line:sub(i, i)
    end

    table.insert(input, row)
end

local length = #input
local total = 0

for i = 1, length do
    for j = 1, length do
        local c = input[i][j]

        if c == "A" and i > 1 and i < length and j > 1 and j < length then
            local tl, br, tr, bl = input[i - 1][j - 1], input[i + 1][j + 1], input[i - 1][j + 1], input[i + 1][j - 1]
            if ((tl == "M" and br == "S") or (tl == "S" and br == "M")) and ((tr == "M" and bl == "S") or (tr == "S" and bl == "M")) then
                total = total + 1
            end
        end
    end
end

print(total)

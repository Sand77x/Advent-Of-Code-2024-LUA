-- AOC 2024 Day 4 Part 1
-- done on 12/11/24

local input = {}

for line in io.lines("input.txt") do
    local row = {}
    for i = 1, #line do
        row[i] = line:sub(i, i)
    end

    table.insert(input, row)
end

local total = 0
local directions = { { -1, -1 }, { -1, 0 }, { -1, 1 }, { 0, 1 }, { 1, 1 }, { 1, 0 }, { 1, -1 }, { 0, -1 } }
local expectations = { X = "M", M = "A", A = "S", }

-- recursively go in that direction expecting the next letter in the string
local function go_in_direction(x, y, direction, last_letter)
    local newx = x + direction[1]
    local newy = y + direction[2]
    local expected_letter = expectations[last_letter]

    -- return 0 if out of bounds
    if (newx < 1 or newx > #input) or (newy < 1 or newy > #input[1]) then
        return 0
    end

    -- if new char is expected letter
    -- return 1 if expected letter is S (meaning XMAS is found)
    -- else go deeper in that direction
    if input[newx][newy] == expected_letter then
        return expected_letter == "S" and 1 or go_in_direction(newx, newy, direction, expected_letter)
    end

    -- return 0 if new char is NOT expected letter
    return 0
end

-- traverse from x, y into every direction
local function traverse(x, y)
    for i = 1, #directions do
        total = total + go_in_direction(x, y, directions[i], "X")
    end
end

-- iterate through every char
for i = 1, #input do
    for j = 1, #input[i] do
        if input[i][j] == "X" then
            traverse(i, j)
        end
    end
end

print(total)

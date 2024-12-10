-- AOC 2024 Day 4 Part 1
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


-- traverse row wise
for i = 1, length do
    local j = 1
    while j <= length - 3 do
        local c = input[i][j]

        if c == 'X' then
            if (input[i][j + 1] .. input[i][j + 2] .. input[i][j + 3]) == "MAS" then
                total = total + 1
            end
        elseif c == 'S' then
            if (input[i][j + 1] .. input[i][j + 2] .. input[i][j + 3]) == "AMX" then
                total = total + 1
            end
        end
        j = j + 1
    end
end

-- traverse column wise
for i = 1, length do
    local j = 1
    while j <= length - 3 do
        local c = input[j][i]

        if c == 'X' then
            if (input[j + 1][i] .. input[j + 2][i] .. input[j + 3][i]) == "MAS" then
                total = total + 1
            end
        elseif c == 'S' then
            if (input[j + 1][i] .. input[j + 2][i] .. input[j + 3][i]) == "AMX" then
                total = total + 1
            end
        end
        j = j + 1
    end
end

-- traverse / wise
for i = 4, length * 2 - 4 do
    local row = math.min(i, length)
    local start_col = math.min(i - row + 1, length)
    local col = start_col

    while row > 3 and col <= length - 3 do
        local c = input[row][col]

        if c == 'X' then
            if (input[row - 1][col + 1] .. input[row - 2][col + 2] .. input[row - 3][col + 3]) == "MAS" then
                total = total + 1
            end
        elseif c == 'S' then
            if (input[row - 1][col + 1] .. input[row - 2][col + 2] .. input[row - 3][col + 3]) == "AMX" then
                total = total + 1
            end
        end

        row = row - 1
        col = col + 1
    end
end

-- traverse \ wise
for i = 4, length * 2 - 4 do
    local start_row = math.max(1, i - length + 1)
    local row = start_row
    local col = math.max(1, length - i + 1)

    while row <= length - 3 and col <= length - 3 do
        local c = input[row][col]

        if c == 'X' then
            if (input[row + 1][col + 1] .. input[row + 2][col + 2] .. input[row + 3][col + 3]) == "MAS" then
                total = total + 1
            end
        elseif c == 'S' then
            if (input[row + 1][col + 1] .. input[row + 2][col + 2] .. input[row + 3][col + 3]) == "AMX" then
                total = total + 1
            end
        end

        row = row + 1
        col = col + 1
    end
end

print(total)

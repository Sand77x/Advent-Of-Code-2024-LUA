-- AOC 2024 Day 3 Part 2
-- done on 12/9/24

local input = ""
for line in io.lines("input.txt") do
    input = input .. line
end

local match = "(mul%(%d+,%d+%))"
local total = 0

-- remove everything within a dont and a do
input = string.gsub(input, "don't%(%).-(do%(%))", "---------ERASED--------")

-- remove everything between a dont and end of file
input = string.gsub(input, "don't%(%).-$", "---------ERASED--------")

local mul_iter = string.gmatch(input, match)
for mul in mul_iter do
    local n1, n2 = string.match(mul, "(%d+),(%d+)")
    total = total + n1 * n2
end

print(total)

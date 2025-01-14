-- AOC 2024 Day 19 Part 2
-- done on 1/14/24

local input = {
    patterns = {},
    designs = {}
}

io.input("input.txt")

local line = io.read("l") .. ","
for c in line:gmatch(" ?(.-),") do
    table.insert(input.patterns, c)
end
_ = io.read() -- empty

while true do
    line = io.read()
    if line == nil then break end
    table.insert(input.designs, line)
end

-- solution

local memo = {}

local function is_possible(design, patterns)
    if memo[design] then return memo[design] end

    local ans = 0

    for i = 1, #patterns do
        if patterns[i] == design then
            ans = ans + 1
        else
            if design:sub(1, #patterns[i]) == patterns[i] then
                local subdesign = design:sub(#patterns[i] + 1)
                ans = ans + is_possible(subdesign, patterns)
            end
        end
    end

    memo[design] = ans
    return memo[design]
end

local ans = 0
for _, d in ipairs(input.designs) do
    ans = ans + is_possible(d, input.patterns)
end

print(ans)

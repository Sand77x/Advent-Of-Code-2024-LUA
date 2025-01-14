-- AOC 2024 Day 19 Part 1
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

local memo = {}

local function is_possible(design, patterns)
    if memo[design] ~= nil then return memo[design] end

    local ans = false

    for i = 1, #patterns do
        if patterns[i] == design then
            return true
        end

        if design:sub(1, #patterns[i]) == patterns[i] then
            local subdesign = design:sub(#patterns[i] + 1)
            ans = is_possible(subdesign, patterns)
            if ans then
                memo[subdesign] = true
                return true
            end
        end
    end

    memo[design] = ans
    return memo[design]
end

-- wr, bwu, rb, gb, br

local ans = 0
for _, d in ipairs(input.designs) do
    if is_possible(d, input.patterns) then
        print(d)
        ans = ans + 1
    end
end

print(ans)

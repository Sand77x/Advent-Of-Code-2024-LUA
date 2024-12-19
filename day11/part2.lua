-- AOC 2024 Day 11 Part 2
-- done on 12/19/24

local file = io.open("input.txt", "r")
if not file then return end
local stones = {}
for i in file:read("l"):gmatch("%d+") do
    table.insert(stones, tonumber(i))
end
io.close(file)

-- blink function, returns array of stones after 1 blink
local function blink(stone)
    local digits = #tostring(stone)
    if stone == 0 then
        return 1
    elseif digits % 2 == 0 then
        local f = math.pow(10, digits / 2)
        return { math.floor(stone / f), math.floor(stone % f) }
    else
        return stone * 2024
    end
end

-- blink n times + memoization
local memo = {}
local function blink_ntimes(blinks, stone)
    if blinks == 0 then
        return 1
    end

    -- memo unique key
    local key = string.format("%d %d", blinks, stone)
    if memo[key] ~= nil then
        return memo[key]
    end

    local res = blink(stone)
    if type(res) == "table" then
        memo[key] = blink_ntimes(blinks - 1, res[1]) + blink_ntimes(blinks - 1, res[2])
    else
        memo[key] = blink_ntimes(blinks - 1, res)
    end

    return memo[key]
end

-- run blink on each stone blink times
local blinks = 75
local ans = 0

for stone = 1, #stones do
    ans = ans + blink_ntimes(blinks, stones[stone])
end

-- answer
print(ans)

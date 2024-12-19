-- AOC 2024 Day 11 Part 1
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

-- run blink on each stone blink times
-- brute force solution; to see memoized solution see part2
local blinks = 25
for _ = 1, blinks do
    local after_blinks = {}
    for stone = 1, #stones do
        local res = blink(stones[stone])
        if type(res) == "table" then
            table.insert(after_blinks, res[1])
            table.insert(after_blinks, res[2])
        else
            table.insert(after_blinks, res)
        end
    end
    stones = after_blinks
end

-- answer
print(#stones)

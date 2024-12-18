-- AOC 2024 Day 1 Part 1
-- done on 12/5/24

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

-- merge sort in lua
local function merge(t, set_size)
    if set_size < 2 then return end

    local left = 1
    local right = set_size

    while left <= #t do
        local midpoint = left + set_size / 2
        local ltable = { table.unpack(t, left, midpoint - 1) }
        local rtable = { table.unpack(t, midpoint, right) }

        local lpointer, rpointer, tpointer = 1, 1, left
        while lpointer <= #ltable and rpointer <= #rtable do
            if ltable[lpointer] < rtable[rpointer] then
                t[tpointer] = ltable[lpointer]
                lpointer = lpointer + 1
            else
                t[tpointer] = rtable[rpointer]
                rpointer = rpointer + 1
            end

            tpointer = tpointer + 1
        end

        while lpointer <= #ltable do
            t[tpointer] = ltable[lpointer]
            lpointer = lpointer + 1
            tpointer = tpointer + 1
        end

        while rpointer <= #rtable do
            t[tpointer] = rtable[rpointer]
            rpointer = rpointer + 1
            tpointer = tpointer + 1
        end

        left = left + set_size
        right = math.min(left + set_size - 1, #t)
    end
end

local function merge_sort(t)
    local set_size = 1

    repeat
        set_size = set_size * 2
        merge(t, set_size)
    until (set_size >= #t)
end

-- sort both lists
merge_sort(list1)
merge_sort(list2)

-- iterate and get diff from each item in list
local diff, total = 0, 0
for i = 1, #list1 do
    diff = math.abs(list1[i] - list2[i])
    total = total + diff
end

-- print ans
print(total)

-- AOC 2024 Day 25 Part 1
-- done on 1/20/24

-- input
local keys = {}
local locks = {}

io.input("input.txt")
local file = io.read("a")

local cur_thing = 1
while true do
    if file:sub(cur_thing, cur_thing) == "#" then
        -- if lock
        local lock = {}
        local pillar = cur_thing + 6
        for _ = 1, 5 do
            local ptr = pillar
            local height = 0
            while true do
                if file:sub(ptr, ptr) ~= "#" then break end
                ptr = ptr + 6
                height = height + 1
            end
            pillar = pillar + 1
            table.insert(lock, height)
        end
        table.insert(locks, lock)
    else
        -- if key
        local key = {}
        local pillar = cur_thing + 30
        for _ = 1, 5 do
            local ptr = pillar
            local height = 0
            while true do
                if file:sub(ptr, ptr) ~= "#" then break end
                ptr = ptr - 6
                height = height + 1
            end
            pillar = pillar + 1
            table.insert(key, height)
        end
        table.insert(keys, key)
    end

    cur_thing = file:find("\n\n", cur_thing)

    if not cur_thing then break end
    cur_thing = cur_thing + 2
end

-- main
local ans = 0
for _, key in ipairs(keys) do
    for _, lock in ipairs(locks) do
        for i = 1, 5 do
            if lock[i] + key[i] > 5 then
                goto overlap
            end
        end
        ans = ans + 1
        ::overlap::
    end
end

print(ans)

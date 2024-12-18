-- AOC 2024 Day 5 Part 1
-- done on 12/11/24

local lookup = {}
local updates = {}

-- getting input
local first_part_done = false
for rule in io.lines("input.txt") do
    if rule == "" then goto blank end
    if not first_part_done and rule:sub(3, 3) ~= "|" then first_part_done = true end

    if not first_part_done then
        local l = rule:sub(1, 2)
        local r = rule:sub(-2, -1)

        if not lookup[l] then
            lookup[l] = {}
        end

        table.insert(lookup[l], r)
    else
        local page_iter = rule:gmatch("%d+")
        local update = {}
        for num in page_iter do
            table.insert(update, num)
        end
        table.insert(updates, update)
    end

    ::blank::
end

-- iterate through updates
local ans = 0
for _, update in ipairs(updates) do
    local seen = {}
    for _, page in ipairs(update) do
        -- mark page as seen
        seen[page] = true
        -- see if page follows rules
        for _, num in ipairs(lookup[page]) do
            if seen[num] then goto next_update end
        end
    end
    -- if all pages follow rules
    -- add middle number
    ans = ans + update[math.ceil(#update / 2)]
    ::next_update::
end

print(ans)

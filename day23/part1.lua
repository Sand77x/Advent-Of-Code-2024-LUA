-- AOC 2024 Day 23 Part 1
-- done on 1/17/24

local input = {}
for line in io.lines("input.txt") do
    local l, r = line:match("(%l%l)-(%l%l)")
    if not input[l] then input[l] = { r } else table.insert(input[l], r) end
    if not input[r] then input[r] = { l } else table.insert(input[r], l) end
end

local function connected(x, y)
    if not input[x] or not input[y] then return false end
    for _, v in ipairs(input[y]) do
        if v == x then return true end
    end
    return false
end

local ans = 0
for k, v in pairs(input) do
    if not k:match("^t") then
        goto no_t
    end

    for e1 = 1, #v do
        for e2 = e1 + 1, #v do
            if connected(v[e1], v[e2]) then
                ans = ans + 1
            end
        end
    end

    input[k] = nil

    ::no_t::
end

print(ans)

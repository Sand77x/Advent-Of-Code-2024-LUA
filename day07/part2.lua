-- AOC 2024 Day 7 Part 2
-- done on 12/13/24

local i = 1
local eqs = {}
for line in io.lines("input.txt") do
    local sep = line:find(":")
    local res = line:sub(1, sep - 1)
    eqs[i] = {
        res = tonumber(res),
        nums = {}
    }
    for num in line:sub(sep + 1, #line):gmatch("%d+") do
        table.insert(eqs[i].nums, tonumber(num))
    end
    i = i + 1
end

local function traverse(res, nums, current_total, idx)
    if current_total > res then return false end

    if idx > #nums then
        if current_total == res then
            return true
        else
            return false
        end
    end

    return traverse(res, nums, current_total + nums[idx], idx + 1) or
        traverse(res, nums, current_total * nums[idx], idx + 1) or
        traverse(res, nums, tonumber(tostring(current_total) .. tostring(nums[idx])), idx + 1)
end

local ans = 0
for _, eq in ipairs(eqs) do
    local possible = traverse(eq.res, eq.nums, eq.nums[1], 2)
    if possible then ans = ans + eq.res end
end

print(string.format("%.i", ans))

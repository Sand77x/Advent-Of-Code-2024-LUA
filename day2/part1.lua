-- AOC 2024 Day 2 Part 1
-- done on 12/8/24

local reports = {}

-- put matrix of numbers in reports
for line in io.lines("input.txt") do
    local report = {}

    for n in string.gmatch(line, "%S+") do
        table.insert(report, n)
    end

    table.insert(reports, report)
end

local safe = 0
for i = 1, #reports do
    local decreasing = nil
    local before = reports[i][1]
    local diff
    for j = 2, #reports[i] do
        diff = before - reports[i][j]

        -- if first element check if decreasing or increasing
        if decreasing == nil then
            decreasing = diff > 0 and true or false
        end

        -- check if unsafe
        if (diff > 0 and not decreasing) or
            (diff < 0 and decreasing) or
            (math.abs(diff) < 1) or
            (math.abs(diff) > 3) then
            goto unsafe
        end

        -- set current value as before
        before = reports[i][j]
    end

    -- if safe, increment safe
    safe = safe + 1
    ::unsafe::
end

print(safe)

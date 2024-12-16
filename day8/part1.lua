-- AOC 2024 Day 8 Part 1
-- done on 12/15/24

local ants = {}
local i = 1
local rows, cols

for line in io.lines('input.txt') do
    cols = #line
    for j = 1, #line do
        local c = line:sub(j, j)
        if c ~= "." then
            local node_pos = setmetatable({ i, j },
                {
                    __sub = function(a, b) return { a[1] - b[1], a[2] - b[2] } end,
                    __tostring = function(a)
                        return a[1] ..
                            ", " .. a[2]
                    end
                })
            if ants[c] then
                table.insert(ants[c], node_pos)
            else
                ants[c] = { node_pos }
            end
        end
    end
    i = i + 1
end

rows = i - 1

local function is_oob(x, y)
    return x < 1 or x > rows or y < 1 or y > cols
end

local uniq_ans = {}
for _, positions in pairs(ants) do
    for j = 1, #positions do
        local current_node = positions[j]
        for k = j + 1, #positions do
            local partner_node = positions[k]
            local diff = current_node - partner_node

            if not is_oob(current_node[1] + diff[1], current_node[2] + diff[2]) then
                uniq_ans[tostring(current_node[1] + diff[1] .. "," .. current_node[2] + diff[2])] = true
            end
            if not is_oob(partner_node[1] - diff[1], partner_node[2] - diff[2]) then
                uniq_ans[tostring(partner_node[1] - diff[1] .. "," .. partner_node[2] - diff[2])] = true
            end
        end
    end
end

local ans = 0
for _, _ in pairs(uniq_ans) do
    ans = ans + 1
end

print(ans)

-- AOC 2024 Day 8 Part 2
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

local function get_next_possible_antinode(node, diff, factor, current)
    if current then
        return { node[1] + diff[1] * factor, node[2] + diff[2] * factor }
    else
        return { node[1] - diff[1] * factor, node[2] - diff[2] * factor }
    end
end

local uniq_ans = {}
local factor = 1
for _, positions in pairs(ants) do
    for j = 1, #positions do
        local current_node = positions[j]
        for k = j + 1, #positions do
            local partner_node = positions[k]
            local diff = current_node - partner_node
            local possible_antinode

            factor = 1
            possible_antinode = get_next_possible_antinode(current_node, diff, factor, true)
            while not is_oob(possible_antinode[1], possible_antinode[2]) do
                -- add position to set if not OOB
                uniq_ans[tostring(possible_antinode[1] .. "," .. possible_antinode[2])] = true
                -- increase factor
                factor = factor + 1
                possible_antinode = get_next_possible_antinode(current_node, diff, factor, true)
            end
            -- do it again except in the other direction
            factor = 1
            possible_antinode = get_next_possible_antinode(current_node, diff, factor, false)
            while not is_oob(possible_antinode[1], possible_antinode[2]) do
                uniq_ans[tostring(possible_antinode[1] .. "," .. possible_antinode[2])] = true
                factor = factor + 1
                possible_antinode = get_next_possible_antinode(current_node, diff, factor, false)
            end
        end
    end
    -- original position that we branch out from is also an antinode
    -- if there are more than 1 positions for that node
    if #positions > 1 then
        uniq_ans[tostring(positions[1][1] .. "," .. positions[1][2])] = true
    end
end

local ans = 0
for _, _ in pairs(uniq_ans) do
    ans = ans + 1
end

print(ans)

-- AOC 2024 Day 24 Part 1
-- done on 1/20/24

-- input
io.input("input.txt")
local file = io.read("a")
local sep_line = file:find("\n\n")
local input = {}

for line in file:sub(1, sep_line):gmatch("(.-)\n") do
    local name, out = line:match("(%w+): (%w)")
    input[name] = { out = out }
end

-- ntg XOR fgs -> mjb
for line in file:sub(sep_line + 2):gmatch("(.-)\n") do
    local lhs, op, rhs, res = line:match("(%w+) (%w+) (%w+) %-> (%w+)")
    if not input[res] then input[res] = {} end
    input[res].pre = { lhs, rhs }
    input[res].op = op
end

-- main function
local operation = {
    ["AND"] = function(x, y)
        return (x == "1" and y == "1") and "1" or "0"
    end,
    ["OR"] = function(x, y)
        return (x == "1" or y == "1") and "1" or "0"
    end,
    ["XOR"] = function(x, y)
        return (x ~= y) and "1" or "0"
    end
}

local function find_out(w)
    if input[w].out ~= nil then
        return input[w].out
    end

    return operation[input[w].op](find_out(input[w].pre[1]), find_out(input[w].pre[2]))
end

local function wait_for_z()
    local z_idx = 0
    local ans = ""

    while true do
        local z_wire = string.format("z%02d", z_idx)
        if not input[z_wire] then break end

        -- recursive function
        local out = find_out(z_wire)
        ans = out .. ans

        z_idx = z_idx + 1
    end

    return ans
end

local function bin_str_to_dec(str)
    local ans = 0
    local digit = 0
    for i = #str, 1, -1 do
        if str:sub(i, i) == "1" then
            ans = ans + 2 ^ digit
        end
        digit = digit + 1
    end
    return ans
end

local ans = wait_for_z()
print(bin_str_to_dec(ans))

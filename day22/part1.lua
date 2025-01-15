-- AOC 2024 Day 20 Part 1
-- done on 1/15/24

local u = function(x) print(vim.inspect(x)) end
local input = {}
for line in io.lines("input.txt") do
    table.insert(input, tonumber(line))
end

local function get_next_secret(n)
    local function mix_n_prune(s, val)
        return (s ~ val) & ((1 << 24) - 1)
    end

    n = mix_n_prune(n, n << 6)
    n = mix_n_prune(n, n >> 5)
    n = mix_n_prune(n, n << 11)

    return n
end

local ans = 0
for _, s in ipairs(input) do
    local twothousandth = s
    for _=1, 2000 do
        twothousandth = get_next_secret(twothousandth)
    end

    ans = ans + twothousandth
end

print(ans)

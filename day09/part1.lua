-- AOC 2024 Day 9 Part 1
-- done on 12/16/24

local input = io.open("input.txt", "r")
if input == nil then return end
local unparsed = input:read("l")
io.close(input)

local mem = {}
local memidx = 1
for i = 1, #unparsed do
    if i % 2 == 1 then
        -- memory block
        mem[memidx] = {}
        mem[memidx].sz = tonumber(unparsed:sub(i, i))
    else
        -- free memory
        mem[memidx].spc = tonumber(unparsed:sub(i, i))
        memidx = memidx + 1
    end
end

local function summ(pos, id, spc)
    local ans = 0
    for _ = 1, spc do
        ans = ans + pos * id
        pos = pos + 1
    end
    return ans
end

-- for debugging
local endstring = ""
local function printntimes(num, n)
    for _ = 1, n do
        endstring = endstring .. tostring(num)
    end
end

local position = 0
local ans = 0
local lptr = 1
local rptr = #mem

while lptr < rptr do
    local block = mem[rptr].sz
    local free  = mem[lptr].spc

    -- add lptr sz to sum
    ans         = ans + summ(position, lptr - 1, mem[lptr].sz)
    position    = position + mem[lptr].sz

    -- add transfered block to sum
    if block > free then
        ans          = ans + summ(position, rptr - 1, free)
        position     = position + free

        mem[rptr].sz = block - free
        lptr         = lptr + 1
    elseif free >= block then
        ans      = ans + summ(position, rptr - 1, block)
        position = position + block

        if free == block then
            lptr = lptr + 1
            rptr = rptr - 1
        else
            -- lptr sz == 0 means it has been added already
            mem[lptr].sz  = 0
            mem[lptr].spc = free - block
            rptr          = rptr - 1
        end
    end
end

-- add final block sz that wasn't counted
ans = ans + summ(position, lptr - 1, mem[lptr].sz)

print(ans)

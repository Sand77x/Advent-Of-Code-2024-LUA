-- AOC 2024 Day 7 Part 2
-- done on 12/15/24

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
local fptr = #mem

while lptr < fptr do
    -- add lptr sz to sum
    -- if negative, treat as empty space (after turning it positive)
    if mem[lptr].sz >= 0 then
        ans      = ans + summ(position, lptr - 1, mem[lptr].sz)
        position = position + mem[lptr].sz
    else
        position = position - mem[lptr].sz
    end

    local rptr = fptr

    while lptr < rptr do
        local block = mem[rptr].sz
        local free  = mem[lptr].spc

        -- add transfered block to sum
        if block > free or block < 0 then
            rptr = rptr - 1
        elseif free >= block then
            ans           = ans + summ(position, rptr - 1, block)
            position      = position + block

            -- set rptr sz to negative ver to signify transfer
            mem[rptr].sz  = -mem[rptr].sz
            mem[lptr].spc = free - block
            rptr          = rptr - 1
        end
    end

    position = position + mem[lptr].spc

    mem[lptr].spc = 0
    lptr = lptr + 1
end

ans = ans + summ(position, lptr - 1, mem[lptr].sz)

print(ans)

io.input("input.txt")
local inp = {
    A = tonumber(io.read("l"):match("[-]?%d+")),
    B = tonumber(io.read("l"):match("[-]?%d+")),
    C = tonumber(io.read("l"):match("[-]?%d+")),
    instructions = {}
}

_ = io.read() -- throw away
for i in io.read("l"):gmatch("%d") do
    table.insert(inp.instructions, tonumber(i))
end

local function is_eq(x, y)
    if #x ~= #y then return false end
    for i = 1, #x do
        if tonumber(x[i]) ~= tonumber(y[i]) then return false end
    end
    return true
end

local S = require("./solution")

S.set_instructions(inp.instructions)
S.stdout = {}
S.set_registers(tonumber("111100010010001110100111111011010000110110011101", 2), inp.B, inp.C)
S.run()
S.print_stdout()

-- Create: 2, 4, 1, 1, 7, 5, 4, 0, 0, 3, 1, 6, 5, 5, 3, 0
-- Program:
-- 2 4 
-- B = A % 8
-- set B to last 3 bits of A
-- 1 1
-- B = B XOR 1
-- set B to itself XOR'd with 1
-- 7 5
-- C = A / 2^B
-- set C to A right shifted B times
-- 4 0
-- B = B XOR C
-- set B to itself XOR'd with C
-- 0 3
-- A = A / 2^3
-- set A to A right shifted 3 times
-- 1 6
-- B = B XOR 6
-- set B to B XOR 6
-- 5 5
-- p B % 8
-- print last 3 bits of B
-- 3 0
-- reset if A is not 0
--
-- Proc:
-- B = last 3 bits of A
-- flip z bit of B (xyz)
-- B XOR first 3 A bits after B
-- flip xy bit of B
--
-- 0000000000000010
-- 111101
-- 111000
-- 111000
-- 111000
-- 111011
-- 


-- 0.) 000 -> 111 7
-- 1.) 001 -> 111 7
-- 2.) 010 -> 101 5
-- 3.) 011 -> 100 4
-- 4.) 100 -> 011 3
-- 5.) 101 -> 010 2
-- 6.) 110 -> 001 1
-- 7.) 111 -> 000 0
--
-- 001
-- 110
--
-- 000
-- 001
-- 010
-- 011
-- 100
-- 101
-- 110
-- 111

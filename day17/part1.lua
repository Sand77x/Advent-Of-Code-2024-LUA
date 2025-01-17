-- AOC 2024 Day 17 Part 1
-- done on 1/8/24

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

local S = require("./solution")

S.stdout = {}
S.set_instructions(inp.instructions)
S.set_registers(inp.A, inp.B, inp.C)
S.run()
S.print_stdout()


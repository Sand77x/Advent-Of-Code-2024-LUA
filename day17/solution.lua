local S = {}
S.ax = 0
S.bx = 0
S.cx = 0
S.ip = 1 -- lua is 1 based :(
S.memory = {}
S.stdout = {}

S.procs = {
    -- r1 = literal op, r2 = combo op
    -- ADV ax <- ax / 2^r2
    [0] = function(r1)
        S.ax = math.floor(S.ax / 2 ^ S.combo(r1))
        S.ip = S.ip + 2
    end,
    -- BXL bx <- bx ^ r1
    [1] = function(r1)
        S.bx = S.bx ~ r1
        S.ip = S.ip + 2
    end,
    -- BST bx <- r2 % 8
    [2] = function(r1)
        S.bx = S.combo(r1) % 8
        S.ip = S.ip + 2
    end,
    -- JNZ ip <- r1 if A == 0 else ip
    [3] = function(r1)
        if S.ax ~= 0 then
            S.ip = r1 + 1 -- 1 based
        else
            S.ip = S.ip + 2
        end
    end,
    -- BXC bx <- bx ^ cx
    [4] = function(r1)
        S.bx = S.bx ~ S.cx
        S.ip = S.ip + 2
    end,
    -- OUT stdout <- r2 % 8
    [5] = function(r1)
        table.insert(S.stdout, math.floor(S.combo(r1) % 8))
        S.ip = S.ip + 2
    end,
    -- BDV bx <- ax / 2^r2
    [6] = function(r1)
        S.bx = math.floor(S.ax / 2 ^ S.combo(r1))
        S.ip = S.ip + 2
    end,
    -- CDV cx <- ax / 2^r2
    [7] = function(r1)
        S.cx = math.floor(S.ax / 2 ^ S.combo(r1))
        S.ip = S.ip + 2
    end,
}

function S.combo(lit)
    return ({
        [0] = function() return 0 end,
        [1] = function() return 1 end,
        [2] = function() return 2 end,
        [3] = function() return 3 end,
        [4] = function() return S.ax end,
        [5] = function() return S.bx end,
        [6] = function() return S.cx end,
        [7] = nil, -- invalid
    })[lit]()
end

function S.set_registers(a, b, c)
    S.ax = a
    S.bx = b
    S.cx = c
end

function S.set_instructions(i)
    S.memory = i
end

function S.run()
    S.ip = 1
    while S.ip <= #S.memory do
        local op = S.memory[S.ip]
        local r1 = S.memory[S.ip + 1]
        S.procs[op](r1)
    end
end

function S.print_stdout()
    print(table.concat(S.stdout, ","))
end

return S

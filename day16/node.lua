local node = {}

function node:new(o)
    o = o or {}
    o.x = o.x or 0
    o.y = o.y or 0
    o.char = o.char or ""
    o.gcost = o.gcost or 0
    o.hcost = o.hcost or 0
    o.open = o.open or true
    o.parent = o.parent or nil
    o.dir = o.dir or nil
    setmetatable(o, self)
    self.__index = self
    return o
end

node.__add = function(a, b)
    return node:new({ a.x + b.x, a.y + b.y })
end

node.__sub = function(a, b)
    return node:new({ a.x - b.x, a.y - b.y })
end

node.__tostring = function(a)
    return string.format("(%d, %d) %s", a.x, a.y, a.char)
end

node.__eq = function(a, b)
    return a.x == b.x and a.y == b.y
end

node.__lt = function(a, b)
    return a:fcost() < b:fcost()
end

node.__le = function(a, b)
    return a:fcost() <= b:fcost()
end

function node:fcost()
    return self.gcost + self.hcost
end

function node:action_cost(n)
    return math.abs(self.dir - n.dir) * 1000
end

return node

local file = io.open("input.txt")

if not file then
	return
end

local input = {}
local A, B, prize

while file:read(0) do
	A = file:read("l")
	B = file:read("l")
	prize = file:read("l")
	_ = file:read("l")

	table.insert(input, {
		A = { tonumber(A:match("%d+")), tonumber(A:match("%d+", B:find(","))) },
		B = { tonumber(B:match("%d+")), tonumber(B:match("%d+", B:find(","))) },
		prize = { tonumber(prize:match("%d+")), tonumber(prize:match("%d+", prize:find(","))) },
	})
end

---------- Implementation

local Ax, Ay, Bx, By, Px, Py

local function get_GCF(a, b)
	local bigger = math.max(a, b)
	local smaller = math.min(a, b)
	local temp = -1

	while temp ~= 0 do
		temp = bigger % smaller
		bigger = smaller
		smaller = temp
	end

	return bigger
end

local ans = 0
for _, v in ipairs(input) do
	Ax, Ay = table.unpack(v.A)
	Bx, By = table.unpack(v.B)
	Px, Py = table.unpack(v.prize)

	-- if no solution then skip
	local best = 999
	local n = 0
	local bestn = -1
	local besto = -1
	if Px % get_GCF(Ax, Bx) == 0 and Py % get_GCF(Ay, By) == 0 then
		-- Ax * n + Bx * o = Px
		-- Ay * n + By * o = Py
		-- solution exists
		while n <= Px / Ax and n <= Py / Ay do
			local Px_Axtn = Px - Ax * n
			if Px_Axtn % Bx == 0 then
				local o = Px_Axtn / Bx
				if Ay * n + By * o == Py then
					if n + o < best then
						best = n + o
						bestn = n
						besto = o
					end
				end
			end
			n = n + 1
		end
		if bestn > 0 and besto > 0 then
			ans = ans + bestn * 3 + besto * 1
		end
	end
end

print(ans)

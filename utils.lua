-- math aliases

sqrt = math.sqrt
min = math.min
max = math.max
floor = math.floor
ceil = math.ceil
function round(input)
	return floor(input + 0.5)
end
char = string.char



-- logging

function betterToString(value, tabLevel)
	if type(tabLevel) == "nil" then tabLevel = 1 end
	if type(value) ~= "table" then
		return tostring(value)
	end
	local output = "{"
	local tabString = ""
	for i=1,tabLevel do
		tabString = tabString .. '    '
	end
	for k,v in pairs(value) do
		output = output .. '\n' .. tabString .. betterToString(k, tabLevel + 1) .. ": " .. betterToString(v, tabLevel + 1)
	end
	tabString = string.sub(tabString, 5)
	output = output .. '\n' .. tabString .. '}'
	return output
end

function format(...)
	local inputs = table.pack(...)
	for i=1,#inputs do
		inputs[i] = betterToString(inputs[i])
	end
	return table.concat(inputs, " ")
end

function warn(...)
	local message = format("WARNING:", ...)
	local padding = string.rep("=", string.len(message))
	log(padding)
	log(message)
	log(padding)
end



-- basic stuff

function switch(input, cases, default)
	local usedCase = cases[input]
	if type(usedCase) == "nil" and default then
		usedCase = default
	end
	if type(usedCase) == "function" then
		return usedCase()
	else
		return usedCase
	end
end

function addItem(tableIn, item)
	tableIn[#tableIn+1] = item
end

function addItemIfNotPresent(tableIn, item, testFn)
	testFn = testFn or function(other)
		return item == other
	end
	for _,other in pairs(tableIn) do
		if testFn(other) then return end
	end
	addItem(tableIn, item)
end

function removeItemsFromTable(tableIn, testFn)
	local keysToRemove = {}
	for k,v in pairs(tableIn) do
		if testFn(v) then
			addItem(keysToRemove, k)
		end
	end
	for i=#keysToRemove,1,-1 do
		local k = keysToRemove[i]
		if type(k) == "number" then
			table.remove(tableIn, k)
		else
			tableIn[k] = nil
		end
	end
end

function tableContainsItem(tableIn, item)
	for _,v in pairs(tableIn) do
		if v == item then return true end
	end
	return false
end





-- misc

function incrementOrder(order)
	if not order then return "a" end
	local lastCharNum = string.byte(order, #order, #order)
	local newCharNum = string.char(lastCharNum + 1)
	return string.sub(order, 1, -2) .. newCharNum
end

function setNameNumber(name, new_num)
	local orig_name = name
	while true do
		if string.len(name) == 0 then warn("invalid name: " .. orig_name) error() end
		local last_byte = string.byte(name, -1)
		if last_byte < 48 or last_byte > 57 then break end
		name = string.sub(name, 1, -2)
	end
	return name .. new_num
end

function intToOrder(order_int)
	local first_digit = order_int % 26
	order_int = floor(order_int / 26)
	local second_digit = order_int % 26
	order_int = floor(order_int / 26)
	local third_digit = order_int % 26
	return char(third_digit + 97) .. char(second_digit + 97) .. char(first_digit + 97)
end

local iniParser = {}


local escapeCharactersFrom = {
    ["a"] = "\a",
    ["b"] = "\b",
    ["f"] = "\f",
    ["n"] = "\n",
    ["r"] = "\r",
    ["t"] = "\t",
    ["v"] = "\v",
    ["\\"] = "\\",
    ["\""] = "\"",
    ["\'"] = "\'",
    ["["] = "[",
    ["]"] = "]",
}
local escapeCharactersTo = {
    ["\a"] = "\\a",
    ["\b"] = "\\b",
    ["\f"] = "\\f",
    ["\n"] = "\\n",
    ["\r"] = "\\r",
    ["\t"] = "\\t",
    ["\v"] = "\\v",
    ["\\"] = "\\\\",
    ["\""] = "\\\"",
}


local function parseFromList(listRaw,i)
    local nextComma = listRaw:find(",",i,true)

    if nextComma ~= nil then
        return listRaw:sub(i,nextComma - 1),nextComma + 1
    else -- no more commas, end of list
        return listRaw:sub(i,#listRaw),nil
    end
end

local function parseValue(value)
    -- If it's in quotes, it's a string
    local s = value:match("^\"(.+)\"$") or value:match("^'(.+)'$")

    if s ~= nil then
        -- Replace escape characters with their actual versions
        local length = #s
        local n = ""
        local i = 1

        while (i <= length) do
            local char = s:sub(i,i)

            if char == "\\" then -- reverse bracket, escape character
                local nextChar = s:sub(i+1,i+1)
                local escape = escapeCharactersFrom[nextChar]

                if escape ~= nil then
                    n = n.. escape
                end

                i = i + 2
            else
                n = n.. char

                i = i + 1
            end
        end

        return n
    end

    -- Use tonumber for numbers
    local number = tonumber(value)

    if number ~= nil then
        return number
    end

    -- Interpret square brackets as a list
    local listRaw = value:match("^%[%s*(.+)%s*]$")

    if listRaw ~= nil then
        local list = {}
        local i = 1

        while (true) do
            local rawValue,next = parseFromList(listRaw,i)
            local noSpaces = rawValue:match("^%s*(.+)%s*$")

            if noSpaces ~= nil then
                table.insert(list,parseValue(noSpaces))
            end

            if next ~= nil then
                i = next
            else
                break
            end
        end

        return list
    end

    -- Couldn't find anything matching, just return raw
    return value
end


local function getValueString(value)
    local valueType = type(value)

    if valueType == "string" then
        -- Add escape characters
        local n = ""

        for i = 1,#value do
            local char = value:sub(i,i)

            n = n.. (escapeCharactersTo[char] or char)
        end

        return "\"".. n.. "\""
    elseif valueType == "number" then
        return tostring(value)
    elseif valueType == "table" then
        local count = #value
        local s = "["

        for k,v in ipairs(value) do
            s = s.. getValueString(v)

            if k < count then
                s = s.. ","
            end
        end

        s = s.. "]"

        return s
    end

    error("Type '".. valueType.. "' cannot be encoded into an INI file")
end

local function getDataString(headerData)
    local dataType = type(headerData)
    if dataType ~= "table" then
        error("Data can only be 'table', not '".. dataType.. "'")
    end

    local headerString = ""

    for k,v in pairs(headerData) do
        local kType = type(k)

        if kType == "string" then
            headerString = headerString.. k.. "=".. getValueString(v).. "\n"
        else
            error("Value name can only be 'string', not '".. kType.. "'")
        end
    end

    return headerString
end



function iniParser.read(filename)
    local data = {[""] = {}}

    local currentHeaderName = ""


    for line in Files.lines(filename) do
        local headerName = line:match("^%s*%[%s*([^%s]+)%s*]%s*$")

        if headerName ~= nil then
            -- In brackets; new header.
            data[headerName] = data[headerName] or {}
            currentHeaderName = headerName

            --print("INI PARSE: new header: ".. headerName)
        else
            local key,value = line:match("^%s*(.+)%s*=%s*(.+)%s*$")

            if key ~= nil and value ~= nil then
                -- Equals sign; must be a value, so parse it from the string
                local parsedValue = parseValue(value)

                data[currentHeaderName][key:gsub('%W', '')] = parsedValue

                --print("INI PARSE: new value: ".. key.. ", ".. inspect(parsedValue))
            end
        end
    end
    
    return data
end


function iniParser.write(filename,data)
    local dataString = ""

    -- Add data for data without a header first
    if data[""] ~= nil then
        dataString = dataString.. getDataString(data[""])
    end

    -- Add everything else
    for k,v in pairs(data) do
        if k ~= "" then
            dataString = dataString.. "[".. k.. "]\n".. getDataString(v)
        end
    end

    -- Write everything
    local success,message = Files.write(filename,dataString)

    return success,message
end


return iniParser
local hub = loadstring(game:HttpGet("https://raw.githubusercontent.com/IslamicHubLib/Islam/refs/heads/main/IslamicHubLibOPENSOURCE", true))()
local main = hub:AddTab("Main")

local initialmessage = "Get Handler Key (Start race & die)"
local capturedkey = "No Key Found!"
local isfarming = false

-- Get the source name of this running script to filter it out
local hooksource = ""
pcall(function()
    if debug and debug.info then
        hooksource = debug.info(1, "s")
    elseif getinfo then
        hooksource = getinfo(1).source
    end
end)

main:AddSection("Farm")

local keyinput = main:AddInput("Key:", initialmessage, "Waiting for key...", function(text)
    if text ~= initialmessage then
        capturedkey = text
    end
end)

task.spawn(function()
    while true do
        if capturedkey and capturedkey ~= initialmessage and capturedkey ~= "No Key Found!" then
            print("Captured: " .. capturedkey)
            keyinput:Set(capturedkey)
            break
        end
        task.wait(1)
    end
end)

local function isvalidkey(val)
    if type(val) ~= "string" then return false end
    if #val < 6 or #val > 64 then return false end
    
    local lower = val:lower()
    local ignored = {
        ["enddata"] = true,
        ["result"] = true,
        ["distance"] = true,
        ["closecalls"] = true,
        ["alivetime"] = true,
        ["getnamecallmethod"] = true,
        ["hookmetamethod"] = true,
        ["getcallingscript"] = true,
        ["decompile"] = true,
        ["fireserver"] = true,
        ["generalactions"] = true,
        ["nokeysfound"] = true,
        ["game"] = true,
        ["service"] = true,
        ["replicatedstorage"] = true,
        ["remotes"] = true,
        ["no key found!"] = true
    }
    
    if ignored[lower] then return false end
    return val:match("^%w+$") ~= nil
end

local function scanvalue(val)
    if isvalidkey(val) then return val end
    if type(val) == "table" then
        for k, v in pairs(val) do
            local res = scanvalue(v) or scanvalue(k)
            if res then return res end
        end
    end
    return nil
end

local function scanstack()
    for level = 3, 10 do
        local ok, func = pcall(function()
            if debug and debug.info then
                return debug.info(level, "f")
            elseif getinfo then
                local info = getinfo(level)
                return info and info.func
            end
        end)
        
        if ok and func and type(func) == "function" then
            -- Get the source of the function we are checking
            local srcok, src = pcall(function()
                if debug and debug.info then
                    return debug.info(func, "s")
                elseif getinfo then
                    return getinfo(func).source
                end
            end)
            
            -- If the function is from our hook script, skip it
            if srcok and src == hooksource then
                continue
            end
            
            local gc = getconstants or (debug and debug.getconstants)
            if gc then
                local ok2, consts = pcall(gc, func)
                if ok2 and type(consts) == "table" then
                    for _, c in ipairs(consts) do
                        if isvalidkey(c) then return c end
                    end
                end
            end
            
            local gu = debug and debug.getupvalue
            if gu then
                for i = 1, 100 do
                    local ok2, name, val = pcall(gu, func, i)
                    if not ok2 or not name then break end
                    if isvalidkey(val) then return val end
                    if type(val) == "table" then
                        local res = scanvalue(val)
                        if res then return res end
                    end
                end
            end
        end
        
        local gl = debug and debug.getlocal
        if gl then
            for i = 1, 100 do
                local ok2, name, val = pcall(gl, level, i)
                if not ok2 or not name then break end
                if isvalidkey(val) then return val end
                if type(val) == "table" then
                    local res = scanvalue(val)
                    if res then return res end
                end
            end
        end
    end
    return nil
end

local oldnamecall
oldnamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if method == "FireServer" and self.Name == "GeneralActions" then
        local found = scanstack()
        if found then
            capturedkey = found
        end
        
        if capturedkey == "No Key Found!" or not capturedkey then
            for _, arg in ipairs(args) do
                local res = scanvalue(arg)
                if res then
                    capturedkey = res
                    break
                end
            end
        end
        
        if capturedkey == "No Key Found!" or not capturedkey then
            local callingscript = getcallingscript()
            if callingscript then
                local ok, code = pcall(decompile, callingscript)
                if ok and code then
                    for line in string.gmatch(code, "[^\r\n]+") do
                        local matchedkey = string.match(line, 'Key%s*=%s*["\']([^"\']+)["\']') or string.match(line, 'key%s*=%s*["\']([^"\']+)["\']')
                        if matchedkey then
                            capturedkey = matchedkey
                            break
                        end
                    end
                end
            end
        end
    end
    return oldnamecall(self, ...)
end)

main:AddToggle("Start Farm", false, function(state)
    isfarming = state
    if isfarming then
        task.spawn(function()
            local startfarm = game:GetService("ReplicatedStorage").Remotes.GeneralActions
            while isfarming do
                pcall(function()
                    startfarm:FireServer(
                        "EndData",
                        {
                            Key = capturedkey or "No Key Found!",
                            Result = {
                                Distance = 16.1,
                                CloseCalls = 1,
                                Alivetime = 7
                            }
                        }
                    )
                end)
                task.wait()
            end
        end)
    end
end)

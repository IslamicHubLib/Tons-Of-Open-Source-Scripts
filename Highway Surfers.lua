local hub = loadstring(game:HttpGet("https://raw.githubusercontent.com/IslamicHubLib/Islam/refs/heads/main/IslamicHubLibOPENSOURCE", true))()
local main = hub:AddTab("Main")

local initialmessage = "You need to get your Handler Key! (Start a race to get it and just die after!)"
local capturedkey = nil
local isfarming = false

main:AddSection("Automatics")
main:AddButton("Fire Remote", function()
    local startfarm = game:GetService("ReplicatedStorage").Remotes.GeneralActions
    startfarm:FireServer(
        "EndData",
        {
            Key = capturedkey or "theykeyhere",
            Result = {
                Distance = 16.1,
                CloseCalls = 1,
                Alivetime = 7
            }
        }
    )
end)

main:AddSection("Key Grabber & Farm")

local keyinput = main:AddInput("Key:", initialmessage, "Waiting for key...", function(text)
    if text ~= initialmessage then
        capturedkey = text
    end
end)

task.spawn(function()
    while true do
        if capturedkey and capturedkey ~= initialmessage then
            print("Captured: " .. capturedkey)
            keyinput:Set(capturedkey)
            break
        end
        task.wait(1)
    end
end)

local oldnamecall
oldnamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if method == "FireServer" and self.Name == "GeneralActions" then
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
        
        if not capturedkey and type(args[2]) == "table" and args[2].Key then
            capturedkey = args[2].Key
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
                            Key = capturedkey or "INPUT YOUR KEY NERD ",
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

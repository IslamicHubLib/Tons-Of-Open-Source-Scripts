-- load the library
local hub = loadstring(game:HttpGet("https://raw.githubusercontent.com/IslamicHubLib/Islam/refs/heads/main/IslamicHubLibOPENSOURCE", true))()
local Main = hub:AddTab("Main")

Main:AddSection("Automatics")
Main:AddButton("Auto Rebirth", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/SzWxv6ax", true))()
end)
Main:AddButton("Auto Click (Upgraded)", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/fpeZef0A", true))()
end)

Main:AddSection("Auto Upgrades")

-- Store the current text and loop status in variables
local upgradeToBuy = "put what you want in here"
local autoBuyActive = false

-- TextBox to change what is being bought in-game
Main:AddInput("Upgrade Name", "put what you want in here", "Enter upgrade...", function(text)
    upgradeToBuy = text
end)

-- Toggle to start/stop the loop
Main:AddToggle("Auto Buy Upgrade", false, function(state)
    autoBuyActive = state
    
    if autoBuyActive then
        -- Run the loop in a background thread
        task.spawn(function()
            local remote = game:GetService("ReplicatedStorage").Remotes.BuyUpgrade
            
            while autoBuyActive do
                -- Fires the remote with whatever is currently typed in the textbox
                pcall(function()
                    remote:InvokeServer(upgradeToBuy, 1)
                end)
                
                -- Yield for 1 frame to prevent the game from freezing
                task.wait()
            end
        end)
    end
end)

-- yes i used ai for the last part as i am on time management rn

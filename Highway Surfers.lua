-- BEFORE READING THIS SCRIPT YOU NEED TO READ THE INSTRUCTIONS!! OVER HERE
-- Instructions, first run this loadstring loadstring(game:HttpGet("https://github.com/notpoiu/cobalt/releases/latest/download/Cobalt.luau"))()
-- after you loaded it in HIGHWay surfers go to outgoing section of cobalt, play one match of racing and just die at any time.
-- then after you died you wsill see something called GeneralActions, click that and click EndData inside of it, then scroll down until you see your key
-- after you see your key then make sure you replace the key in this script im about to paste below and run it to get semi infinite cash

local farmingevent = game:GetService("ReplicatedStorage").Remotes.GeneralActions
while true do
farmingevent:FireServer(
    "EndData",
    {
        Key = KEYHERE,
        Result = {
            Distance = 16.1,
            CloseCalls = 1,
            Alivetime = 7
        }
    }
)
task.wait(0)
end

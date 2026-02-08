-- loader.lua
-- Save sebagai file terpisah

local function CheckGame()
    -- List game ID yang didukung
    local supportedGames = {
        [6766156863] = "Strongman Simulator", 
    }
    
    local currentGame = game.PlaceId
    local gameName = supportedGames[currentGame]
    
    if not gameName then
        warn("⚠️ Game tidak didukung!")
        warn("Game ID: " .. currentGame)
        return false
    end
    
    print("🎮 Game: " .. gameName)
    return true
end

local function LoadScript()
    if not CheckGame() then return end
    
    print("📥 Loading script...")
    
    -- URL GitHub Anda (ganti dengan milik Anda)
    local scriptURL = "https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/YOUR_REPO/main/main.lua"
    
    local success, result = pcall(function()
        -- Download script dari GitHub
        local scriptContent = game:HttpGet(scriptURL, true)
        
        if not scriptContent then
            error("Failed to download script")
        end
        
        -- Execute script
        local func, err = loadstring(scriptContent)
        if not func then
            error("Loadstring error: " .. tostring(err))
        end
        
        return func()
    end)
    
    if success then
        print("✅ Script loaded successfully!")
        print("👤 Player: " .. game.Players.LocalPlayer.Name)
        print("🎯 Use RightShift to toggle GUI")
    else
        warn("❌ Error: " .. tostring(result))
        
        -- Fallback ke simple features
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Script Error",
            Text = "Using basic features only",
            Duration = 5
        })
        
        -- Basic features
        local player = game.Players.LocalPlayer
        if player.Character then
            player.Character.Humanoid.WalkSpeed = 50
            player.Character.Humanoid.JumpPower = 100
        end
    end
end

-- Start loading
LoadScript()
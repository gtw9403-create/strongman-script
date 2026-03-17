-- ================================================
-- MAIN.LUA - UI Script dengan Rayfield
-- Diload otomatis oleh loader.lua
-- ================================================

-- Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local player     = Players.LocalPlayer

-- ================================================
-- AUTO FARM LOOP (contoh)
-- ================================================
local autoFarmLoop   = nil
local autoFarmActive = false

local function StartAutoFarm()
    autoFarmActive = true
    autoFarmLoop = RunService.Heartbeat:Connect(function()
        if not autoFarmActive then return end
        -- Tulis logika auto farm kamu di sini
        -- Contoh: klik/collect item terdekat
    end)
end

local function StopAutoFarm()
    autoFarmActive = false
    if autoFarmLoop then
        autoFarmLoop:Disconnect()
        autoFarmLoop = nil
    end
end

-- ================================================
-- BUAT WINDOW
-- ================================================
local Window = Rayfield:CreateWindow({
    Name             = "My Script Hub",
    Icon             = 0,
    LoadingTitle     = "My Script Hub",
    LoadingSubtitle  = "by YourName",
    Theme            = "Default",

    DisableRayfieldPrompts  = false,
    DisableBuildWarnings    = false,

    ConfigurationSaving = {
        Enabled    = true,
        FolderName = "MyScriptHub",
        FileName   = "Config",
    },

    Discord = {
        Enabled      = false,
        Invite       = "your-discord",
        RememberJoins = true,
    },

    KeySystem = false,
    KeySettings = {
        Title    = "Key Required",
        Subtitle = "Enter Key",
        Note     = "Join discord untuk key",
        FileName = "Key",
        SaveKey  = true,
        Key      = {"MyKey123"},
    },
})

-- ================================================
-- TAB
-- ================================================
local MainTab     = Window:CreateTab("⚔️ Main",     4483362458)
local PlayerTab   = Window:CreateTab("🧍 Player",   4483362458)
local SettingsTab = Window:CreateTab("⚙️ Settings", 4483362458)

-- ================================================
-- MAIN TAB
-- ================================================
MainTab:CreateSection("🌾 Farm")

MainTab:CreateToggle({
    Name         = "Auto Farm",
    CurrentValue = false,
    Flag         = "AutoFarm",
    Callback     = function(Value)
        if Value then
            StartAutoFarm()
            Rayfield:Notify({ Title = "Auto Farm", Content = "Auto Farm aktif!", Duration = 3, Image = 4483362458 })
        else
            StopAutoFarm()
            Rayfield:Notify({ Title = "Auto Farm", Content = "Auto Farm dimatikan.", Duration = 3, Image = 4483362458 })
        end
    end,
})

MainTab:CreateButton({
    Name     = "Collect Semua Item",
    Callback = function()
        -- Tulis logika collect di sini
        Rayfield:Notify({ Title = "Collect", Content = "Mengumpulkan item...", Duration = 3, Image = 4483362458 })
    end,
})

MainTab:CreateSection("📍 Teleport")

MainTab:CreateButton({
    Name     = "Teleport ke Spawn",
    Callback = function()
        local char = player.Character
        if char then
            char:MoveTo(Vector3.new(0, 10, 0))
            Rayfield:Notify({ Title = "Teleport", Content = "Berhasil teleport ke Spawn!", Duration = 3, Image = 4483362458 })
        end
    end,
})

MainTab:CreateButton({
    Name     = "Teleport ke Gym",
    Callback = function()
        -- Ganti koordinat sesuai map game
        local char = player.Character
        if char then
            char:MoveTo(Vector3.new(100, 10, 200))
            Rayfield:Notify({ Title = "Teleport", Content = "Berhasil teleport ke Gym!", Duration = 3, Image = 4483362458 })
        end
    end,
})

-- ================================================
-- PLAYER TAB
-- ================================================
PlayerTab:CreateSection("🏃 Movement")

PlayerTab:CreateSlider({
    Name         = "Walk Speed",
    Range        = {16, 300},
    Increment    = 1,
    Suffix       = " Speed",
    CurrentValue = 16,
    Flag         = "WalkSpeed",
    Callback     = function(Value)
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = Value
        end
    end,
})

PlayerTab:CreateSlider({
    Name         = "Jump Power",
    Range        = {50, 500},
    Increment    = 5,
    Suffix       = " Power",
    CurrentValue = 50,
    Flag         = "JumpPower",
    Callback     = function(Value)
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = Value
        end
    end,
})

PlayerTab:CreateSection("🛡️ Combat")

PlayerTab:CreateToggle({
    Name         = "God Mode",
    CurrentValue = false,
    Flag         = "GodMode",
    Callback     = function(Value)
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            if Value then
                char.Humanoid.MaxHealth = math.huge
                char.Humanoid.Health    = math.huge
            else
                char.Humanoid.MaxHealth = 100
                char.Humanoid.Health    = 100
            end
        end
    end,
})

PlayerTab:CreateToggle({
    Name         = "Infinite Jump",
    CurrentValue = false,
    Flag         = "InfJump",
    Callback     = function(Value)
        _G.InfJump = Value
    end,
})

-- Infinite Jump handler
game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfJump then
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- ================================================
-- SETTINGS TAB
-- ================================================
SettingsTab:CreateSection("🎨 UI Settings")

SettingsTab:CreateKeybind({
    Name            = "Toggle UI",
    CurrentKeybind  = "RightShift",
    HoldToInteract  = false,
    Flag            = "ToggleUI",
    Callback        = function()
        -- Rayfield handle sendiri via RightShift
    end,
})

SettingsTab:CreateDropdown({
    Name            = "Theme",
    Options         = {"Default", "AmberGlow", "Amethyst", "BloodMoon", "Carbon", "Ocean"},
    CurrentOption   = {"Default"},
    MultipleOptions = false,
    Flag            = "Theme",
    Callback        = function(Option)
        Rayfield:Notify({ Title = "Theme", Content = "Restart script untuk apply theme: " .. Option, Duration = 4, Image = 4483362458 })
    end,
})

SettingsTab:CreateSection("ℹ️ Info")

SettingsTab:CreateButton({
    Name     = "Script Info",
    Callback = function()
        Rayfield:Notify({
            Title   = "My Script Hub v1.0",
            Content = "By YourName | Strongman Simulator",
            Duration = 5,
            Image   = 4483362458,
        })
    end,
})

-- ================================================
-- NOTIF WELCOME
-- ================================================
Rayfield:Notify({
    Title   = "✅ Script Loaded!",
    Content = "My Script Hub berhasil diload! Selamat bermain.",
    Duration = 5,
    Image   = 4483362458,
})
```

---

## 🚀 Cara Pakai

**Struktur repo GitHub:**
```
YOUR_REPO/
├── loader.lua
└── main.lua-- main.lua
-- Strongman Simulator Script by skyzoxle

--[[
    ===================================
    STRONGMAN SIMULATOR SCRIPT v2.0
    Features:
    - Auto Click (Legal)
    - Auto Walk to Objectives
    - Speed Adjust
    - ESP for Items
    - GUI Interface
    ===================================
]]

-- Wait for game to load
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Initialize Global Table
getgenv().StrongmanScript = {
    Version = "2.0.0",
    Author = "skyzoxle",
    GameID = 1234567890, -- Ganti dengan Game ID Strongman
    Config = {
        AutoClick = false,
        AutoWalk = false,
        WalkSpeed = 16,
        JumpPower = 50,
        ESP = false
    },
    Connections = {},
    Modules = {}
}

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Notification System
function StrongmanScript:Notify(title, message, duration)
    duration = duration or 3
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = message,
        Duration = duration,
        Icon = "rbxassetid://4483345998"
    })
end

-- Save/Load Configuration
function StrongmanScript:SaveConfig()
    local success, err = pcall(function()
        writefile("strongman_config.json", HttpService:JSONEncode(self.Config))
    end)
    return success
end

function StrongmanScript:LoadConfig()
    local success, config = pcall(function()
        return HttpService:JSONDecode(readfile("strongman_config.json"))
    end)
    if success then
        self.Config = config
    end
end

-- Load GUI Library
function StrongmanScript:LoadGUI()
    local guiLoaded, Library = pcall(function()
        -- Coba load dari GitHub
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/fluxteam/UI-Libraries/main/NewFluxLib.lua"))()
    end)
    
    if not guiLoaded then
        -- Fallback ke simple GUI
        Library = {
            New = function(options)
                print("[GUI] Loading: " .. options.Name)
                return {
                    Category = function(catName)
                        return {
                            Button = function(btnName, callback)
                                return {Name = btnName, Callback = callback}
                            end,
                            Toggle = function(toggleName, callback)
                                return {Name = toggleName, Callback = callback}
                            end,
                            Slider = function(sliderName, min, max, default, callback)
                                return {Value = default, Callback = callback}
                            end
                        }
                    end
                }
            end
        }
    end
    
    return Library
end

-- Initialize GUI
function StrongmanScript:InitGUI()
    local Library = self:LoadGUI()
    
    -- Create Window
    local Window = Library.New({
        Name = "Strongman Simulator",
        Description = "by skyzoxle",
        Icon = "⚡",
        Theme = "Dark"
    })
    
    -- Main Category
    local Main = Window:Category("Main Features")
    
    Main:Toggle("Auto Click", function(state)
        self.Config.AutoClick = state
        self:Notify("Auto Click", state and "Enabled" or "Disabled")
        self:SaveConfig()
    end)
    
    Main:Toggle("Auto Walk", function(state)
        self.Config.AutoWalk = state
        self:Notify("Auto Walk", state and "Enabled" or "Disabled")
    end)
    
    Main:Slider("Walk Speed", 16, 200, self.Config.WalkSpeed, function(value)
        self.Config.WalkSpeed = value
        if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end)
    
    Main:Slider("Jump Power", 50, 200, self.Config.JumpPower, function(value)
        self.Config.JumpPower = value
        if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.JumpPower = value
        end
    end)
    
    Main:Toggle("ESP Items", function(state)
        self.Config.ESP = state
        self:ToggleESP(state)
    end)
    
    -- Player Category
    local PlayerCat = Window:Category("Player")
    
    PlayerCat:Button("Reset Character", function()
        LocalPlayer.Character:BreakJoints()
    end)
    
    PlayerCat:Button("Copy Game ID", function()
        setclipboard(tostring(game.PlaceId))
        self:Notify("Copied", "Game ID copied to clipboard")
    end)
    
    PlayerCat:Button("Copy Player ID", function()
        setclipboard(tostring(LocalPlayer.UserId))
        self:Notify("Copied", "Player ID copied")
    end)
    
    -- Info Category
    local InfoCat = Window:Category("Info")
    
    InfoCat:Label("Player: " .. LocalPlayer.Name)
    InfoCat:Label("Account Age: " .. LocalPlayer.AccountAge .. " days")
    InfoCat:Label("Script Version: " .. self.Version)
    
    InfoCat:Button("Join Discord", function()
        setclipboard("https://discord.gg/example")
        self:Notify("Discord", "Link copied to clipboard")
    end)
    
    InfoCat:Button("Destroy GUI", function()
        Window:Destroy()
        self:Notify("GUI", "Interface destroyed")
    end)
    
    return Window
end

-- ESP System
function StrongmanScript:ToggleESP(state)
    if state then
        -- Highlight important items
        for _, item in pairs(workspace:GetDescendants()) do
            if item:IsA("Part") and (item.Name:find("Dumbbell") or item.Name:find("Weight")) then
                local highlight = Instance.new("Highlight")
                highlight.Parent = item
                highlight.FillColor = Color3.fromRGB(0, 255, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            end
        end
    else
        -- Remove highlights
        for _, highlight in pairs(workspace:GetDescendants()) do
            if highlight:IsA("Highlight") then
                highlight:Destroy()
            end
        end
    end
end

-- Auto Click System (LEGAL)
function StrongmanScript:AutoClickSystem()
    spawn(function()
        while true do
            if self.Config.AutoClick and LocalPlayer.Character then
                -- Simulate clicking (visual only, no remote events)
                local humanoid = LocalPlayer.Character.Humanoid
                humanoid:MoveTo(humanoid.RootPart.Position + Vector3.new(0, 0, 0.1))
                task.wait(0.5)
            end
            task.wait()
        end
    end)
end

-- Main Initialization
function StrongmanScript:Init()
    print("=================================")
    print("Strongman Script Loading...")
    print("Version: " .. self.Version)
    print("Player: " .. LocalPlayer.Name)
    print("=================================")
    
    -- Load saved config
    self:LoadConfig()
    
    -- Initialize GUI
    local guiSuccess = pcall(function()
        self.GUI = self:InitGUI()
    end)
    
    if guiSuccess then
        self:Notify("Success", "Script loaded! Press RightShift to toggle GUI", 5)
    else
        self:Notify("Warning", "GUI failed, using basic features", 5)
    end
    
    -- Start systems
    self:AutoClickSystem()
    
    -- Apply settings to character
    LocalPlayer.CharacterAdded:Connect(function(char)
        task.wait(1)
        char.Humanoid.WalkSpeed = self.Config.WalkSpeed
        char.Humanoid.JumpPower = self.Config.JumpPower
    end)
    
    if LocalPlayer.Character then
        LocalPlayer.Character.Humanoid.WalkSpeed = self.Config.WalkSpeed
        LocalPlayer.Character.Humanoid.JumpPower = self.Config.JumpPower
    end
    
    -- Keybind to toggle GUI
    local UIS = game:GetService("UserInputService")
    UIS.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightShift then
            if self.GUI then
                self.GUI.Enabled = not self.GUI.Enabled
            end
        end
    end)
    
    print("[✓] Script initialized successfully!")
end

-- Start the script
StrongmanScript:Init()

return StrongmanScript

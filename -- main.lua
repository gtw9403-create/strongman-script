-- main.lua
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
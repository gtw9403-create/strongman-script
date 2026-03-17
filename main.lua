-- ================================================
-- STRONGMAN HUB - ALL IN ONE
-- by gtw9403
-- ================================================

-- CEK GAME
local supportedGames = {
    [6766156863] = "Strongman Simulator",
}

local gameName = supportedGames[game.PlaceId]
if not gameName then
    warn("⚠️ Game tidak didukung! PlaceId: " .. game.PlaceId)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Error", Text = "Game tidak didukung!", Duration = 5
    })
    return
end

print("🎮 Game: " .. gameName)
print("👤 Player: " .. game.Players.LocalPlayer.Name)

-- ================================================
-- LOAD RAYFIELD
-- ================================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local player     = Players.LocalPlayer

-- ================================================
-- VARIABLES
-- ================================================
_G.AutoLift    = false
_G.AutoRebirth = false
_G.InfJump     = false
_G.SelectedArea = "Area1"

local liftLoop = nil

-- ================================================
-- HELPER
-- ================================================
local function GetHum()
    local char = player.Character
    return char and char:FindFirstChild("Humanoid")
end

local function GetRoot()
    local char = player.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function TeleportTo(pos)
    local root = GetRoot()
    if root then root.CFrame = CFrame.new(pos) end
end

-- ================================================
-- AUTO LIFT
-- ================================================
local function StartAutoLift()
    if liftLoop then liftLoop:Disconnect() end
    liftLoop = RunService.Heartbeat:Connect(function()
        if not _G.AutoLift then return end
        local root = GetRoot()
        if not root then return end
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (
                obj.Name:lower():find("barbell") or
                obj.Name:lower():find("weight") or
                obj.Name:lower():find("dumbbell") or
                obj.Name:lower():find("lift")
            ) then
                local dist = (root.Position - obj.Position).Magnitude
                if dist < 15 then
                    root.CFrame = CFrame.new(obj.Position + Vector3.new(0, 3, 0))
                    local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
                    if remotes then
                        for _, r in pairs(remotes:GetChildren()) do
                            if r:IsA("RemoteEvent") and r.Name:lower():find("lift") then
                                pcall(function() r:FireServer() end)
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end
        end
    end)
end

local function StopAutoLift()
    _G.AutoLift = false
    if liftLoop then liftLoop:Disconnect() liftLoop = nil end
end

-- ================================================
-- AUTO REBIRTH
-- ================================================
local function StartAutoRebirth()
    task.spawn(function()
        while _G.AutoRebirth do
            pcall(function()
                local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
                if remotes then
                    for _, r in pairs(remotes:GetChildren()) do
                        if r:IsA("RemoteEvent") and r.Name:lower():find("rebirth") then
                            r:FireServer()
                        end
                        if r:IsA("RemoteFunction") and r.Name:lower():find("rebirth") then
                            r:InvokeServer()
                        end
                    end
                end
            end)
            task.wait(1)
        end
    end)
end

-- ================================================
-- INFINITE JUMP
-- ================================================
UIS.JumpRequest:Connect(function()
    if _G.InfJump then
        local hum = GetHum()
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- ================================================
-- TELEPORT KE AREA
-- ================================================
local function TeleportToArea(areaName)
    local areas = workspace:FindFirstChild("Areas")
    if not areas then
        Rayfield:Notify({ Title = "Error", Content = "Folder Areas tidak ditemukan!", Duration = 3, Image = 4483362458 })
        return
    end

    local area = areas:FindFirstChild(areaName)
    if not area then
        Rayfield:Notify({ Title = "Error", Content = "Area " .. areaName .. " tidak ditemukan!", Duration = 3, Image = 4483362458 })
        return
    end

    -- Cari SpawnLocation atau Part pertama di area
    local spawnPart = area:FindFirstChildOfClass("SpawnLocation")
        or area:FindFirstChildWhichIsA("BasePart")

    if spawnPart then
        TeleportTo(spawnPart.Position + Vector3.new(0, 5, 0))
        Rayfield:Notify({ Title = "Teleport", Content = "Berhasil ke " .. areaName .. "!", Duration = 3, Image = 4483362458 })
    else
        Rayfield:Notify({ Title = "Error", Content = "Tidak ada spawn di area ini!", Duration = 3, Image = 4483362458 })
    end
end

-- ================================================
-- WINDOW
-- ================================================
local Window = Rayfield:CreateWindow({
    Name             = "Strongman Hub",
    Icon             = 0,
    LoadingTitle     = "Strongman Hub",
    LoadingSubtitle  = "by gtw9403",
    Theme            = "BloodMoon",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings   = false,
    ConfigurationSaving = {
        Enabled    = true,
        FolderName = "StrongmanHub",
        FileName   = "Config",
    },
    Discord = {
        Enabled       = false,
        Invite        = "your-discord",
        RememberJoins = true,
    },
    KeySystem = false,
})

-- ================================================
-- TABS
-- ================================================
local FarmTab     = Window:CreateTab("⚔️ Farm",     4483362458)
local PlayerTab   = Window:CreateTab("🧍 Player",   4483362458)
local TeleportTab = Window:CreateTab("📍 Teleport", 4483362458)
local SettingsTab = Window:CreateTab("⚙️ Settings", 4483362458)

-- ================================================
-- FARM TAB
-- ================================================
FarmTab:CreateSection("🏋️ Auto Farm")

FarmTab:CreateToggle({
    Name = "Auto Lift", CurrentValue = false, Flag = "AutoLift",
    Callback = function(Value)
        _G.AutoLift = Value
        if Value then StartAutoLift() else StopAutoLift() end
        Rayfield:Notify({ Title = "Auto Lift", Content = Value and "Aktif!" or "Dimatikan.", Duration = 3, Image = 4483362458 })
    end,
})

FarmTab:CreateToggle({
    Name = "Auto Rebirth", CurrentValue = false, Flag = "AutoRebirth",
    Callback = function(Value)
        _G.AutoRebirth = Value
        if Value then StartAutoRebirth() end
        Rayfield:Notify({ Title = "Auto Rebirth", Content = Value and "Aktif!" or "Dimatikan.", Duration = 3, Image = 4483362458 })
    end,
})

FarmTab:CreateSlider({
    Name = "Farm Delay", Range = {0, 5}, Increment = 0.1,
    Suffix = "s", CurrentValue = 0.1, Flag = "FarmDelay",
    Callback = function(Value) _G.FarmDelay = Value end,
})

-- ================================================
-- PLAYER TAB
-- ================================================
PlayerTab:CreateSection("🏃 Movement")

PlayerTab:CreateSlider({
    Name = "Walk Speed", Range = {16, 500}, Increment = 1,
    Suffix = " Speed", CurrentValue = 16, Flag = "WalkSpeed",
    Callback = function(Value)
        local hum = GetHum()
        if hum then hum.WalkSpeed = Value end
    end,
})

PlayerTab:CreateSlider({
    Name = "Jump Power", Range = {50, 500}, Increment = 5,
    Suffix = " Power", CurrentValue = 50, Flag = "JumpPower",
    Callback = function(Value)
        local hum = GetHum()
        if hum then hum.JumpPower = Value end
    end,
})

PlayerTab:CreateToggle({
    Name = "Infinite Jump", CurrentValue = false, Flag = "InfJump",
    Callback = function(Value)
        _G.InfJump = Value
        Rayfield:Notify({ Title = "Infinite Jump", Content = Value and "Aktif!" or "Dimatikan.", Duration = 3, Image = 4483362458 })
    end,
})

PlayerTab:CreateSection("🛡️ Defense")

PlayerTab:CreateToggle({
    Name = "God Mode", CurrentValue = false, Flag = "GodMode",
    Callback = function(Value)
        local hum = GetHum()
        if hum then
            hum.MaxHealth = Value and math.huge or 100
            hum.Health    = Value and math.huge or 100
        end
        Rayfield:Notify({ Title = "God Mode", Content = Value and "Aktif!" or "Dimatikan.", Duration = 3, Image = 4483362458 })
    end,
})

PlayerTab:CreateButton({
    Name = "Reset Character",
    Callback = function()
        local hum = GetHum()
        if hum then hum.Health = 0 end
    end,
})

-- ================================================
-- TELEPORT TAB
-- ================================================
TeleportTab:CreateSection("🗺️ Area Teleport")

TeleportTab:CreateDropdown({
    Name = "Pilih Area",
    Options = {
        "Area1",
        "Area10_Candyland",
        "Area11_ScienceLab",
        "Area12_Tropical",
        "Area13_Dinoland",
        "Area14_Retro",
        "Area15_IceWorld",
        "Area16_DeepSea",
        "Area17_OldWest",
        "Area18_Apartment",
        "Area19_Treasury",
        "Area20_Princess",
        "Area21_Asian",
        "Area22_Kitchen",
        "Area23_Sewer",
        "Area24_Mineshaft",
        "Area25_RobotFactory",
        "Area26_Magic",
        "Area27_Football",
        "Area28_Prison",
    },
    CurrentOption   = {"Area1"},
    MultipleOptions = false,
    Flag            = "SelectedArea",
    Callback        = function(Option)
        _G.SelectedArea = Option
    end,
})

TeleportTab:CreateButton({
    Name = "🚀 Teleport ke Area",
    Callback = function()
        if _G.SelectedArea then
            TeleportToArea(_G.SelectedArea)
        else
            Rayfield:Notify({ Title = "Error", Content = "Pilih area dulu!", Duration = 3, Image = 4483362458 })
        end
    end,
})

TeleportTab:CreateSection("👥 Teleport ke Player")

TeleportTab:CreateDropdown({
    Name = "Pilih Player",
    Options = (function()
        local list = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player then table.insert(list, p.Name) end
        end
        if #list == 0 then list = {"(Tidak ada player lain)"} end
        return list
    end)(),
    CurrentOption = {}, MultipleOptions = false, Flag = "TargetPlayer",
    Callback = function(Option) _G.TargetPlayer = Option end,
})

TeleportTab:CreateButton({
    Name = "Teleport ke Player",
    Callback = function()
        if _G.TargetPlayer and _G.TargetPlayer ~= "(Tidak ada player lain)" then
            local target = Players:FindFirstChild(_G.TargetPlayer)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                TeleportTo(target.Character.HumanoidRootPart.Position + Vector3.new(0, 3, 0))
                Rayfield:Notify({ Title = "Teleport", Content = "Berhasil ke " .. _G.TargetPlayer, Duration = 3, Image = 4483362458 })
            end
        else
            Rayfield:Notify({ Title = "Error", Content = "Pilih player dulu!", Duration = 3, Image = 4483362458 })
        end
    end,
})

-- ================================================
-- SETTINGS TAB
-- ================================================
SettingsTab:CreateSection("⌨️ Keybind")

SettingsTab:CreateKeybind({
    Name = "Toggle UI", CurrentKeybind = "RightShift",
    HoldToInteract = false, Flag = "ToggleUI",
    Callback = function() end,
})

SettingsTab:CreateSection("ℹ️ Info")

SettingsTab:CreateButton({
    Name = "Script Info",
    Callback = function()
        Rayfield:Notify({
            Title   = "Strongman Hub v1.0",
            Content = "By gtw9403 | Strongman Simulator",
            Duration = 5,
            Image   = 4483362458,
        })
    end,
})

-- ================================================
-- WELCOME
-- ================================================
Rayfield:Notify({
    Title   = "✅ Strongman Hub Loaded!",
    Content = "Selamat datang, " .. player.Name .. "!",
    Duration = 5,
    Image   = 4483362458,
})

-- ================================================
-- LOADER.LUA
-- Jalankan file ini di executor
-- ================================================

local CONFIG = {
    ScriptName  = "My Script Hub",
    Version     = "v1.0",
    Author      = "YourName",
    ScriptURL   = "https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/main.lua",
    
    SupportedGames = {
        [6766156863] = "Strongman Simulator",
        -- Tambah game lain di sini:
        -- [1234567890] = "Nama Game",
    },
}

-- ================================================
-- FUNGSI UTILITIES
-- ================================================
local function Log(emoji, msg)
    print(emoji .. " [" .. CONFIG.ScriptName .. "] " .. msg)
end

local function NotifyError(title, text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 5,
        })
    end)
end

-- ================================================
-- CEK GAME
-- ================================================
local function CheckGame()
    local placeId   = game.PlaceId
    local gameName  = CONFIG.SupportedGames[placeId]

    if not gameName then
        warn("⚠️ Game tidak didukung! PlaceId: " .. placeId)
        NotifyError("Tidak Didukung", "Game ini belum disupport!")
        return false
    end

    Log("🎮", "Game terdeteksi: " .. gameName)
    return true
end

-- ================================================
-- LOAD MAIN SCRIPT
-- ================================================
local function LoadScript()
    Log("🚀", "Memulai " .. CONFIG.ScriptName .. " " .. CONFIG.Version)
    Log("👤", "Player: " .. game.Players.LocalPlayer.Name)

    if not CheckGame() then return end

    Log("📥", "Mengunduh script dari GitHub...")

    local success, result = pcall(function()
        local content = game:HttpGet(CONFIG.ScriptURL, true)

        if not content or content == "" then
            error("Download gagal atau file kosong!")
        end

        Log("📦", "Download selesai! (" .. #content .. " bytes)")

        local func, err = loadstring(content)
        if not func then
            error("Compile error: " .. tostring(err))
        end

        return func()
    end)

    if success then
        Log("✅", "Script berhasil diload!")
        Log("🎯", "Tekan RightShift untuk toggle GUI")
    else
        warn("❌ Gagal: " .. tostring(result))
        NotifyError("Load Error", "Script gagal dimuat! Cek console.")
    end
end

-- ================================================
-- START
-- ================================================
LoadScript()

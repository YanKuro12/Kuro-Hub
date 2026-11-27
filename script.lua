local P = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local VU = game:GetService("VirtualUser")
local LP = P.LocalPlayer
local WS = game:GetService("Workspace")
local CommF = RS:WaitForChild("Remotes"):WaitForChild("CommF_")

-- ==========================================
-- DATABASE QUEST BLOX FRUITS (LEVEL 1 - 2800)
-- ==========================================
local QUESTS = {
    -- SEA 1
    [1]    = { quest = "BanditQuest1", num = 1, mob = "Bandit", npc = Vector3.new(1060, 16, 1547), mobPos = Vector3.new(1038, 41, 1576) },
    [10]   = { quest = "JungleQuest",  num = 1, mob = "Monkey", npc = Vector3.new(-1601, 36, 153), mobPos = Vector3.new(-1448, 50, 63) },
    [15]   = { quest = "JungleQuest",  num = 2, mob = "Gorilla", npc = Vector3.new(-1601, 36, 153), mobPos = Vector3.new(-1142, 40, -515) },
    [30]   = { quest = "BuggyQuest1",  num = 1, mob = "Pirate", npc = Vector3.new(-1140, 4, 3827), mobPos = Vector3.new(-1201, 40, 3857) },
    [40]   = { quest = "BuggyQuest1",  num = 2, mob = "Brute", npc = Vector3.new(-1140, 4, 3827), mobPos = Vector3.new(-1387, 24, 4100) },
    [60]   = { quest = "DesertQuest",  num = 1, mob = "Desert Bandit", npc = Vector3.new(896, 6, 4390), mobPos = Vector3.new(984, 16, 4417) },
    [75]   = { quest = "DesertQuest",  num = 2, mob = "Desert Officer", npc = Vector3.new(896, 6, 4390), mobPos = Vector3.new(1547, 14, 4381) },
    [90]   = { quest = "SnowQuest",    num = 1, mob = "Snow Bandit", npc = Vector3.new(1386, 87, -1298), mobPos = Vector3.new(1356, 105, -1328) },
    [100]  = { quest = "SnowQuest",    num = 2, mob = "Snowman", npc = Vector3.new(1386, 87, -1298), mobPos = Vector3.new(1218, 138, -1488) },
    [120]  = { quest = "MarineQuest2", num = 1, mob = "Chief Petty Officer", npc = Vector3.new(-5035, 28, 4324), mobPos = Vector3.new(-4931, 65, 4121) },
    [150]  = { quest = "SkyQuest",     num = 1, mob = "Sky Bandit", npc = Vector3.new(-4841, 717, -2623), mobPos = Vector3.new(-4970, 294, -2890) },
    [175]  = { quest = "SkyQuest",     num = 2, mob = "Dark Master", npc = Vector3.new(-4841, 717, -2623), mobPos = Vector3.new(-5220, 430, -2278) },
    [225]  = { quest = "ColosseumQuest", num = 1, mob = "Toga Warrior", npc = Vector3.new(-1576, 7, -2983), mobPos = Vector3.new(-1779, 44, -2736) },
    [275]  = { quest = "ColosseumQuest", num = 2, mob = "Gladiator", npc = Vector3.new(-1576, 7, -2983), mobPos = Vector3.new(-1274, 58, -3188) },
    [300]  = { quest = "MagmaQuest",   num = 1, mob = "Military Soldier", npc = Vector3.new(-5316, 12, 8517), mobPos = Vector3.new(-5363, 41, 8548) },
    [330]  = { quest = "MagmaQuest",   num = 2, mob = "Military Spy", npc = Vector3.new(-5316, 12, 8517), mobPos = Vector3.new(-5787, 120, 8762) },
    [375]  = { quest = "FishmanQuest", num = 1, mob = "Fishman Warrior", npc = Vector3.new(61122, 18, 1568), mobPos = Vector3.new(61163, 5, 1819) },
    [400]  = { quest = "FishmanQuest", num = 2, mob = "Fishman Commando", npc = Vector3.new(61122, 18, 1568), mobPos = Vector3.new(61163, 5, 1819) },
    [450]  = { quest = "SkyExp1Quest", num = 1, mob = "God's Guard", npc = Vector3.new(-4721, 845, -1954), mobPos = Vector3.new(-4716, 853, -1933) },
    [475]  = { quest = "SkyExp1Quest", num = 2, mob = "Shanda", npc = Vector3.new(-7863, 5545, -379), mobPos = Vector3.new(-7685, 5601, -443) },
    [525]  = { quest = "SkyExp2Quest", num = 1, mob = "Royal Squad", npc = Vector3.new(-7902, 5635, -1411), mobPos = Vector3.new(-7685, 5606, -1442) },
    [550]  = { quest = "SkyExp2Quest", num = 2, mob = "Royal Soldier", npc = Vector3.new(-7902, 5635, -1411), mobPos = Vector3.new(-7864, 5661, -1708) },
    [625]  = { quest = "FountainQuest", num = 1, mob = "Galley Pirate", npc = Vector3.new(5254, 38, 4049), mobPos = Vector3.new(5595, 41, 3961) },
    [650]  = { quest = "FountainQuest", num = 2, mob = "Galley Captain", npc = Vector3.new(5254, 38, 4049), mobPos = Vector3.new(5658, 38, 4928) },
    -- SEA 2
    [700]  = { quest = "Area1Quest",   num = 1, mob = "Raider", npc = Vector3.new(-424, 73, 1836), mobPos = Vector3.new(-737, 39, 2392) },
    [725]  = { quest = "Area1Quest",   num = 2, mob = "Mercenary", npc = Vector3.new(-424, 73, 1836), mobPos = Vector3.new(-973, 95, 1836) },
    [775]  = { quest = "Area2Quest",   num = 1, mob = "Swan Pirate", npc = Vector3.new(632, 73, 918), mobPos = Vector3.new(970, 142, 1217) },
    [875]  = { quest = "MarineQuest3", num = 1, mob = "Marine Lieutenant", npc = Vector3.new(-2442, 73, -3219), mobPos = Vector3.new(-2913, 73, -3040) },
    [900]  = { quest = "MarineQuest3", num = 2, mob = "Marine Captain", npc = Vector3.new(-2442, 73, -3219), mobPos = Vector3.new(-1868, 73, -3321) },
    [950]  = { quest = "ZombieQuest",  num = 1, mob = "Zombie", npc = Vector3.new(-5492, 48, -793), mobPos = Vector3.new(-5634, 126, -697) },
    [975]  = { quest = "ZombieQuest",  num = 2, mob = "Vampire", npc = Vector3.new(-5492, 48, -793), mobPos = Vector3.new(-6030, 6, -1313) },
    [1000] = { quest = "SnowMountainQuest", num = 1, mob = "Snow Trooper", npc = Vector3.new(604, 401, -5371), mobPos = Vector3.new(535, 401, -5329) },
    [1050] = { quest = "SnowMountainQuest", num = 2, mob = "Winter Warrior", npc = Vector3.new(604, 401, -5371), mobPos = Vector3.new(1223, 454, -5170) },
    [1100] = { quest = "IceSideQuest", num = 1, mob = "Lab Subordinate", npc = Vector3.new(-6060, 15, -4904), mobPos = Vector3.new(-5769, 37, -4468) },
    [1125] = { quest = "IceSideQuest", num = 2, mob = "Horned Warrior", npc = Vector3.new(-6060, 15, -4904), mobPos = Vector3.new(-6400, 24, -5818) },
    [1175] = { quest = "FireSideQuest", num = 1, mob = "Magma Ninja", npc = Vector3.new(-5431, 15, -5296), mobPos = Vector3.new(-5496, 58, -5929) },
    [1200] = { quest = "FireSideQuest", num = 2, mob = "Lava Pirate", npc = Vector3.new(-5431, 15, -5296), mobPos = Vector3.new(-5169, 34, -4669) },
    [1350] = { quest = "FrostQuest",   num = 1, mob = "Arctic Warrior", npc = Vector3.new(5669, 28, -6482), mobPos = Vector3.new(5995, 57, -6183) },
    [1375] = { quest = "FrostQuest",   num = 2, mob = "Snow Lurker", npc = Vector3.new(5669, 28, -6482), mobPos = Vector3.new(5518, 60, -6828) },
    [1425] = { quest = "ForgottenQuest", num = 1, mob = "Sea Soldier", npc = Vector3.new(-3052, 236, -10148), mobPos = Vector3.new(-3030, 191, -9859) },
    [1450] = { quest = "ForgottenQuest", num = 2, mob = "Water Fighter", npc = Vector3.new(-3052, 236, -10148), mobPos = Vector3.new(-3436, 290, -10503) },
    -- SEA 3
    [1500] = { quest = "PiratePortQuest", num = 1, mob = "Pirate Millionaire", npc = Vector3.new(-290, 42, 5581), mobPos = Vector3.new(81, 43, 5724) },
    [1525] = { quest = "PiratePortQuest", num = 2, mob = "Pistol Billionaire", npc = Vector3.new(-290, 42, 5581), mobPos = Vector3.new(81, 43, 5724) },
    [1575] = { quest = "AmazonQuest",  num = 1, mob = "Dragon Crew Warrior", npc = Vector3.new(5832, 51, -1101), mobPos = Vector3.new(6241, 51, -1243) },
    [1600] = { quest = "AmazonQuest",  num = 2, mob = "Dragon Crew Archer", npc = Vector3.new(5832, 51, -1101), mobPos = Vector3.new(6488, 383, -110) },
    [1625] = { quest = "AmazonQuest2", num = 1, mob = "Female Islander", npc = Vector3.new(5448, 601, 751), mobPos = Vector3.new(5825, 682, 704) },
    [1650] = { quest = "AmazonQuest2", num = 2, mob = "Giant Islander", npc = Vector3.new(5448, 601, 751), mobPos = Vector3.new(4530, 656, -131) },
    [1700] = { quest = "MarineTreeIsland", num = 1, mob = "Marine Commodore", npc = Vector3.new(2180, 27, -6741), mobPos = Vector3.new(2490, 190, -7160) },
    [1725] = { quest = "MarineTreeIsland", num = 2, mob = "Marine Rear Admiral", npc = Vector3.new(2180, 27, -6741), mobPos = Vector3.new(3951, 229, -6912) },
    [1775] = { quest = "DeepForestIsland3", num = 1, mob = "Fishman Raider", npc = Vector3.new(-10581, 330, -8761), mobPos = Vector3.new(-10322, 390, -8580) },
    [1800] = { quest = "DeepForestIsland3", num = 2, mob = "Fishman Captain", npc = Vector3.new(-10581, 330, -8761), mobPos = Vector3.new(-11194, 442, -8608) },
    [1825] = { quest = "DeepForestIsland", num = 1, mob = "Forest Pirate", npc = Vector3.new(-13234, 331, -7625), mobPos = Vector3.new(-13225, 428, -7753) },
    [1850] = { quest = "DeepForestIsland", num = 2, mob = "Mythological Pirate", npc = Vector3.new(-13234, 331, -7625), mobPos = Vector3.new(-13869, 564, -7084) },
    [1900] = { quest = "DeepForestIsland2", num = 1, mob = "Jungle Pirate", npc = Vector3.new(-12680, 389, -9902), mobPos = Vector3.new(-11982, 376, -10451) },
    [1925] = { quest = "DeepForestIsland2", num = 2, mob = "Musketeer Pirate", npc = Vector3.new(-12680, 389, -9902), mobPos = Vector3.new(-13282, 496, -9565) },
    [1975] = { quest = "HauntedQuest1", num = 1, mob = "Reborn Skeleton", npc = Vector3.new(-9480, 142, 5566), mobPos = Vector3.new(-8817, 191, 6298) },
    [2000] = { quest = "HauntedQuest1", num = 2, mob = "Living Zombie", npc = Vector3.new(-9480, 142, 5566), mobPos = Vector3.new(-10125, 183, 6242) },
    [2025] = { quest = "HauntedQuest2", num = 1, mob = "Demonic Soul", npc = Vector3.new(-9516, 178, 6078), mobPos = Vector3.new(-9712, 204, 6193) },
    [2050] = { quest = "HauntedQuest2", num = 2, mob = "Posessed Mummy", npc = Vector3.new(-9516, 178, 6078), mobPos = Vector3.new(-9545, 69, 6339) },
    [2075] = { quest = "NutsIslandQuest", num = 1, mob = "Peanut Scout", npc = Vector3.new(-2104, 38, -10194), mobPos = Vector3.new(-2126, 90, -10301) },
    [2100] = { quest = "NutsIslandQuest", num = 2, mob = "Peanut President", npc = Vector3.new(-2104, 38, -10194), mobPos = Vector3.new(-2118, 70, -10509) },
    [2125] = { quest = "IceCreamIslandQuest", num = 1, mob = "Ice Cream Chef", npc = Vector3.new(-820, 65, -10966), mobPos = Vector3.new(-685, 96, -10957) },
    [2150] = { quest = "IceCreamIslandQuest", num = 2, mob = "Ice Cream Commander", npc = Vector3.new(-820, 65, -10966), mobPos = Vector3.new(-635, 143, -11335) },
    -- (Quest 2200 ke atas pakai sistem raid/secret di update 30, ini cap aman autofarm biasa)
    [2200] = { quest = "CakeQuest1", num = 1, mob = "Cake Guard", npc = Vector3.new(-2070, 40, -10140), mobPos = Vector3.new(-1900, 50, -10200) },
    [2250] = { quest = "CakeQuest2", num = 2, mob = "Cake Queen", npc = Vector3.new(-2070, 40, -10140), mobPos = Vector3.new(-2000, 60, -10300) },
    [2300] = { quest = "XmasQuest", num = 1, mob = "Elf", npc = Vector3.new(50, 20, -6100), mobPos = Vector3.new(100, 20, -6200) },
    [2400] = { quest = "XmasQuest", num = 2, mob = "Snowman", npc = Vector3.new(50, 20, -6100), mobPos = Vector3.new(150, 20, -6300) },
    [2500] = { quest = "ThreeWorldQuest", num = 1, mob = "Islander", npc = Vector3.new(-200, 20, 5000), mobPos = Vector3.new(-100, 20, 5100) },
    [2600] = { quest = "ThreeWorldQuest", num = 2, mob = "Warrior", npc = Vector3.new(-200, 20, 5000), mobPos = Vector3.new(-50, 20, 5200) },
    [2700] = { quest = "ThreeWorldQuest", num = 3, mob = "Raider", npc = Vector3.new(-200, 20, 5000), mobPos = Vector3.new(0, 20, 5300) },
}

-- ==========================================
-- FUNGSI UTAMA (LOGIKA)
-- ==========================================
local function getLevel()
    local d = LP:FindFirstChild("Data")
    local l = d and d:FindFirstChild("Level")
    return l and l.Value or 1
end

local function getHRP()
    return LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
end

local function isAlive()
    local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    return h and h.Health > 0
end

local function hasQuest()
    local main = LP.PlayerGui:FindFirstChild("Main")
    local quest = main and main:FindFirstChild("Quest")
    return quest and quest.Visible
end

local function moveTo(pos, timeout)
    local hrp = getHRP()
    if not hrp then return false end
    local hum = LP.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    hum:MoveTo(pos)
    local t0 = tick()
    while tick() - t0 < (timeout or 10) do
        if not _G.KuroAutoFarm then return false end
        if not isAlive() then return false end
        hrp = getHRP()
        if not hrp then return false end
        if (hrp.Position - pos).Magnitude < 15 then return true end
        task.wait(0.1)
    end
    return false
end

local function attack()
    VU:CaptureController()
    VU:Button1Down(Vector2.new(1280, 672))
    task.wait(0.05)
    VU:Button1Up(Vector2.new(1280, 672))
end

local function useBusoKen()
    if _G.KuroAutoBuso then
        pcall(function()
            if LP.Character and not LP.Character:FindFirstChild("HasBuso") then
                CommF:InvokeServer("Buso")
            end
        end)
    end
    if _G.KuroAutoKen then
        pcall(function()
            if LP.Character and not LP.Character:FindFirstChild("Ken") then
                CommF:InvokeServer("Ken", true)
            end
        end)
    end
end

local function getQuestData(lvl)
    local best, bestLvl = nil, -1
    for l, data in pairs(QUESTS) do
        if l <= lvl and l > bestLvl then best, bestLvl = data, l end
    end
    return best
end

local function findNearestMob(mobName)
    local enemies = WS:FindFirstChild("Enemies")
    if not enemies then return nil end
    local best, dist = nil, 400
    local hrp = getHRP()
    if not hrp then return nil end
    for _, v in ipairs(enemies:GetChildren()) do
        if v.Name == mobName or v.Name:find(mobName) then
            local h = v:FindFirstChildOfClass("Humanoid")
            local r = v:FindFirstChild("HumanoidRootPart")
            if h and r and h.Health > 0 then
                local d = (hrp.Position - r.Position).Magnitude
                if d < dist then best, dist = v, d end
            end
        end
    end
    return best
end

-- ==========================================
-- LOOP SISTEM (JALAN DI BACKGROUND)
-- ==========================================
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            -- Logic Auto Farm Level
            if _G.KuroAutoFarm then
                if not isAlive() then task.wait(1); return end
                useBusoKen()

                local lvl = getLevel()
                local data = getQuestData(lvl)
                if data then
                    if not hasQuest() then
                        if getHRP() then
                            moveTo(data.npc, 15)
                            CommF:InvokeServer("StartQuest", data.quest, data.num)
                            task.wait(1)
                        end
                    else
                        local mob = findNearestMob(data.mob)
                        if mob and mob:FindFirstChild("HumanoidRootPart") then
                            local mr = mob.HumanoidRootPart
                            if (getHRP().Position - mr.Position).Magnitude > 15 then
                                moveTo(mr.Position, 10)
                            end
                            attack()
                            task.wait(0.5)
                        else
                            -- Kalau mob ga nemu, jalan ke posisi mob (biar spawn)
                            if getHRP() then
                                moveTo(data.mobPos, 10)
                            end
                            task.wait(1)
                        end
                    end
                end
            end
        end)
    end
end)

-- Script ini nyambung ke main.lua (UI) lewat _G.KuroAutoFarm, _G.KuroAutoBuso, dll.
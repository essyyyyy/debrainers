local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local success, bodyEffects = pcall(function()
    return workspace:WaitForChild("Players"):WaitForChild(LocalPlayer.Name):WaitForChild("BodyEffects")
end)

if not success or not bodyEffects then return end

local armorValue = bodyEffects:FindFirstChild("Armor")
if not armorValue then
    armorValue = bodyEffects:FindFirstChild("ArmorValue") or 
                 bodyEffects:FindFirstChildOfClass("NumberValue") or
                 bodyEffects:FindFirstChildOfClass("IntValue")
end

if not armorValue then return end

local targetArmor = workspace.Ignored.Shop["[High-Medium Armor] - $2589"]
if not targetArmor then return end

local armorPart = targetArmor:FindFirstChild("Head", true)
if not armorPart then return end

local armorPos = armorPart.Position
local tpPos = armorPos + Vector3.new(0, -2, 0)

local function getRoot()
    local char = LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
end

repeat task.wait() until LocalPlayer.Character and getRoot()

local isBuying = false
local savePos = nil

local function savePos()
    local root = getRoot()
    if root then savePos = root.Position end
end

local function restorePos()
    local root = getRoot()
    if root and savePos then
        root.Position = savePos
        savePos = nil
    end
end

local function moveMouse()
    local screenPos, onScreen = WorldToScreen(armorPos)
    if onScreen then
        mousemoveabs(screenPos.X, screenPos.Y)
    else
        local viewport = workspace.CurrentCamera.ViewportSize
        if viewport then mousemoveabs(viewport.X / 2, viewport.Y / 2) end
    end
end

local function lookDown()
    task.wait(0.01)
    for i = 1, 30 do
        keypress(0x28)
        keyrelease(0x28)
    end
end

local function zoomIn()
    for i = 1, 8 do
        keypress(0x49)
        keyrelease(0x49)
    end
end

local function clickLoop()
    local root = getRoot()
    if not root then return false end
    
    task.wait(0.01)
    root.Position = tpPos
    
    moveMouse()
    
    local attempts = 0
    repeat
        task.wait(0.01)
        mouse1click()
        if armorValue.Value >= 65 then return true end
        attempts = attempts + 1
    until attempts >= 50
    
    return false
end

local function buyArmor()
    if isBuying then return end
    isBuying = true
    
    savePos()
    
    local root = getRoot()
    if not root then 
        isBuying = false
        return 
    end
    
    for i = 1, 3 do mouse2release() end
    
    zoomIn()
    lookDown()
    clickLoop()
    restorePos()
    
    isBuying = false
end

local function checkAndBuy()
    if isBuying then return end
    if armorValue.Value < 65 then buyArmor() end
end

checkAndBuy()

if armorValue.Changed then
    armorValue.Changed:Connect(function(newValue)
        if isBuying then return end
        if newValue < 65 then buyArmor() end
    end)
end

task.spawn(function()
    while true do
        task.wait(0.05)
        checkAndBuy()
    end
end)

while true do task.wait() end

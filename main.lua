-- [[ 개발자 설정 구역 ]]
local KEY_LINK = "https://your-link-here.com"
local SECRET_KEY = "WasteTime_67"
local BYPASS_ATTR = "AntiCheat_Ignore"

-- [[ 시스템 변수 ]]
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local isAutoFarm = false

-- [[ 드래그 기능 함수 ]]
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- [[ UI 생성 ]]
local ScreenGui = Instance.new("ScreenGui", player.PlayerGui)
ScreenGui.Name = "WasteTime_AprilFools"
ScreenGui.ResetOnSpawn = false

-- [열기 버튼 (작은 버튼)]
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 50, 0, 50)
OpenBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
OpenBtn.Text = "UI"
OpenBtn.TextColor3 = Color3.new(1, 1, 1)
OpenBtn.Visible = false
makeDraggable(OpenBtn) -- 작은 버튼도 드래그 가능

-- [메인 컨테이너 (키 프레임과 메인 메뉴를 담을 베이스)]
local MainContainer = Instance.new("Frame", ScreenGui)
MainContainer.Size = UDim2.new(0, 350, 0, 320)
MainContainer.Position = UDim2.new(0.5, -175, 0.5, -160)
MainContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainContainer.BorderSizePixel = 0
makeDraggable(MainContainer)

-- [X 버튼 (닫기)]
local CloseBtn = Instance.new("TextButton", MainContainer)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.SourceSansBold

-- [키 입력 프레임]
local KeyFrame = Instance.new("Frame", MainContainer)
KeyFrame.Size = UDim2.new(1, 0, 1, 0)
KeyFrame.BackgroundTransparency = 1

local GetKeyBtn = Instance.new("TextButton", KeyFrame)
GetKeyBtn.Size = UDim2.new(0, 260, 0, 45)
GetKeyBtn.Position = UDim2.new(0.5, -130, 0.15, 0)
GetKeyBtn.Text = "Get Key (Link)"
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(55, 80, 200)
GetKeyBtn.TextColor3 = Color3.new(1, 1, 1)

local KeyInput = Instance.new("TextBox", KeyFrame)
KeyInput.Size = UDim2.new(0, 260, 0, 45)
KeyInput.Position = UDim2.new(0.5, -130, 0.4, 0)
KeyInput.PlaceholderText = "Paste Key Here..."
KeyInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
KeyInput.TextColor3 = Color3.new(1, 1, 1)

local SubmitBtn = Instance.new("TextButton", KeyFrame)
SubmitBtn.Size = UDim2.new(0, 260, 0, 45)
SubmitBtn.Position = UDim2.new(0.5, -130, 0.7, 0)
SubmitBtn.Text = "LOGIN"
SubmitBtn.BackgroundColor3 = Color3.fromRGB(60, 160, 60)
SubmitBtn.TextColor3 = Color3.new(1, 1, 1)

-- [메인 메뉴 프레임]
local MainFrame = Instance.new("Frame", MainContainer)
MainFrame.Visible = false
MainFrame.Size = UDim2.new(1, 0, 1, 0)
MainFrame.BackgroundTransparency = 1

local function createLabel(text, pos, parent)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size = UDim2.new(0, 250, 0, 20)
    lbl.Position = pos
    lbl.Text = text
    lbl.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    lbl.BackgroundTransparency = 1
    return lbl
end

createLabel("Auto Farm Interval (Minutes):", UDim2.new(0.5, -125, 0.1, 0), MainFrame)
local IntervalInput = Instance.new("TextBox", MainFrame)
IntervalInput.Size = UDim2.new(0, 250, 0, 40)
IntervalInput.Position = UDim2.new(0.5, -125, 0.2, 0)
IntervalInput.Text = "13"

createLabel("Teleport Delay (Seconds):", UDim2.new(0.5, -125, 0.4, 0), MainFrame)
local DelayInput = Instance.new("TextBox", MainFrame)
DelayInput.Size = UDim2.new(0, 250, 0, 40)
DelayInput.Position = UDim2.new(0.5, -125, 0.5, 0)
DelayInput.Text = "1"

local AutoFarmBtn = Instance.new("TextButton", MainFrame)
AutoFarmBtn.Size = UDim2.new(0, 250, 0, 50)
AutoFarmBtn.Position = UDim2.new(0.5, -125, 0.75, 0)
AutoFarmBtn.Text = "Auto Eons: OFF"
AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
AutoFarmBtn.TextColor3 = Color3.new(1, 1, 1)

-- [[ UI 로직 ]]

-- 닫기/열기 토글
CloseBtn.MouseButton1Click:Connect(function()
    MainContainer.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    MainContainer.Visible = true
    OpenBtn.Visible = false
end)

-- 로그인 및 기타 로직
GetKeyBtn.MouseButton1Click:Connect(function()
    print("Your Key Link: " .. KEY_LINK)
    KeyInput.Text = "Check F9 Console"
end)

SubmitBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == SECRET_KEY then
        KeyFrame.Visible = false
        MainFrame.Visible = true
    else
        KeyInput.PlaceholderText = "WRONG KEY!"
        KeyInput.Text = ""
    end
end)

AutoFarmBtn.MouseButton1Click:Connect(function()
    isAutoFarm = not isAutoFarm
    AutoFarmBtn.Text = isAutoFarm and "Auto Eons: ON" or "Auto Eons: OFF"
    AutoFarmBtn.BackgroundColor3 = isAutoFarm and Color3.fromRGB(60, 160, 60) or Color3.fromRGB(150, 50, 50)
end)

-- [[ 오토팜 루프 (동일) ]]
local function findYellowButton()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            if (obj.Name:lower():find("button") or obj.BrickColor.Name:find("Yellow")) and obj.Size.Y < 2 then
                return obj
            end
        end
    end
    return nil
end

task.spawn(function()
    while true do
        task.wait(1)
        if isAutoFarm then
            local waitMinutes = tonumber(IntervalInput.Text) or 13
            task.wait(waitMinutes * 60)
            if not isAutoFarm then continue end
            local button = findYellowButton()
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if button and hrp then
                local lastPos = hrp.CFrame
                character:SetAttribute(BYPASS_ATTR, true)
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.CFrame = CFrame.new(button.Position + Vector3.new(0, 3, 0))
                task.wait(tonumber(DelayInput.Text) or 1)
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.CFrame = lastPos * CFrame.new(0, 6, 0)
                task.wait(1)
                character:SetAttribute(BYPASS_ATTR, false)
            end
        end
    end
end)


local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- [ 기본 설정 ]
local SECRET_KEY = "WasteTime_67"
local BYPASS_ATTR = "AntiCheat_Ignore"
local isAutoFarm = false

-- [ 1. UI 생성부 ]
local ScreenGui = Instance.new("ScreenGui", player.PlayerGui)
ScreenGui.Name = "AprilFools_Final"

-- 키 입력 창
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.new(0, 300, 0, 150)
KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
KeyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
KeyFrame.BorderSizePixel = 0

local KeyInput = Instance.new("TextBox", KeyFrame)
KeyInput.Size = UDim2.new(0, 220, 0, 40)
KeyInput.Position = UDim2.new(0.5, -110, 0.3, -20)
KeyInput.PlaceholderText = "Enter Key..."
KeyInput.Text = ""

local SubmitBtn = Instance.new("TextButton", KeyFrame)
SubmitBtn.Size = UDim2.new(0, 100, 0, 40)
SubmitBtn.Position = UDim2.new(0.5, -50, 0.7, -20)
SubmitBtn.Text = "Login"
SubmitBtn.BackgroundColor3 = Color3.fromRGB(60, 160, 60)
SubmitBtn.TextColor3 = Color3.new(1, 1, 1)

-- 메인 메뉴 (로그인 성공 시 표시)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Visible = false
MainFrame.Size = UDim2.new(0, 350, 0, 300)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local function createLabel(text, pos, parent)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size = UDim2.new(0, 250, 0, 20)
    lbl.Position = pos
    lbl.Text = text
    lbl.TextColor3 = Color3.new(1,1,1)
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
AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
AutoFarmBtn.TextColor3 = Color3.new(1,1,1)

-- [ 2. 기능 로직 ]

-- 노란색 발판(Button) 찾기 함수
local function findYellowButton()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name == "Button" or obj.BrickColor.Name:find("Yellow") or obj.BrickColor.Name:find("Yeller")) then
            -- 소파 같은 큰 가구 제외 (버튼은 보통 납작함)
            if obj.Size.Y < 2 then return obj end
        end
    end
    return nil
end

-- 로그인 체크
SubmitBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == SECRET_KEY then
        KeyFrame.Visible = false
        MainFrame.Visible = true
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "Wrong Key!"
    end
end)

-- 오토팜 토글
AutoFarmBtn.MouseButton1Click:Connect(function()
    isAutoFarm = not isAutoFarm
    AutoFarmBtn.Text = isAutoFarm and "Auto Eons: ON" or "Auto Eons: OFF"
    AutoFarmBtn.BackgroundColor3 = isAutoFarm and Color3.fromRGB(60, 160, 60) or Color3.fromRGB(180, 60, 60)
end)

-- [ 3. 오토팜 핵심 루프 ]
task.spawn(function()
    while true do
        task.wait(1)
        if isAutoFarm then
            local waitTime = (tonumber(IntervalInput.Text) or 13) * 60
            task.wait(waitTime)
            
            if not isAutoFarm then continue end
            
            local button = findYellowButton()
            local hrp = character:FindFirstChild("HumanoidRootPart")
            
            if button and hrp then
                local lastPos = hrp.CFrame
                local delayTime = tonumber(DelayInput.Text) or 1
                
                -- 1. 안티치트 우회 속성 부여
                character:SetAttribute(BYPASS_ATTR, true)
                
                -- 2. 노란색 발판으로 순간이동 (물리력 초기화 포함)
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.CFrame = CFrame.new(button.Position + Vector3.new(0, 3, 0)) 
                
                task.wait(delayTime) -- 설정한 지연 시간만큼 밟고 있기
                
                -- 3. 원래 위치 6스터드 위로 복귀
                hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                hrp.CFrame = lastPos * CFrame.new(0, 6, 0)
                
                task.wait(1)
                character:SetAttribute(BYPASS_ATTR, false) -- 우회 종료
            end
        end
    end
end)

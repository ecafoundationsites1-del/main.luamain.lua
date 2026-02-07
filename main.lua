-- [[ 개발자 설정 구역 ]]
local KEY_LINK = "https://your-link-here.com" -- 키를 받을 수 있는 링크를 입력하세요.
local SECRET_KEY = "WasteTime_67"              -- 접속용 비밀키
local BYPASS_ATTR = "AntiCheat_Ignore"         -- 안티치트 우회용 속성 이름

-- [[ 시스템 변수 ]]
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local isAutoFarm = false

-- [[ 1. UI 생성 및 배치 ]]
local ScreenGui = Instance.new("ScreenGui", player.PlayerGui)
ScreenGui.Name = "WasteTime_AprilFools"

-- [키 입력 프레임]
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.new(0, 300, 0, 220)
KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -110)
KeyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
KeyFrame.BorderSizePixel = 0

-- 1-1. 키 받기 버튼 (최상단)
local GetKeyBtn = Instance.new("TextButton", KeyFrame)
GetKeyBtn.Size = UDim2.new(0, 260, 0, 45)
GetKeyBtn.Position = UDim2.new(0.5, -130, 0.1, 0)
GetKeyBtn.Text = "Get Key (Link)"
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(55, 80, 200)
GetKeyBtn.TextColor3 = Color3.new(1, 1, 1)
GetKeyBtn.Font = Enum.Font.SourceSansBold
GetKeyBtn.TextSize = 20

-- 1-2. 키 입력창
local KeyInput = Instance.new("TextBox", KeyFrame)
KeyInput.Size = UDim2.new(0, 260, 0, 45)
KeyInput.Position = UDim2.new(0.5, -130, 0.4, 0)
KeyInput.PlaceholderText = "Paste Key Here..."
KeyInput.Text = ""
KeyInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
KeyInput.TextColor3 = Color3.new(1, 1, 1)

-- 1-3. 로그인 버튼
local SubmitBtn = Instance.new("TextButton", KeyFrame)
SubmitBtn.Size = UDim2.new(0, 260, 0, 45)
SubmitBtn.Position = UDim2.new(0.5, -130, 0.7, 0)
SubmitBtn.Text = "LOGIN"
SubmitBtn.BackgroundColor3 = Color3.fromRGB(60, 160, 60)
SubmitBtn.TextColor3 = Color3.new(1, 1, 1)
SubmitBtn.Font = Enum.Font.SourceSansBold

-- [메인 메뉴 프레임 (초기 비활성)]
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Visible = false
MainFrame.Size = UDim2.new(0, 350, 0, 300)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

local function createLabel(text, pos, parent)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size = UDim2.new(0, 250, 0, 20)
    lbl.Position = pos
    lbl.Text = text
    lbl.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    return lbl
end

-- 주기(분) 입력
createLabel("Auto Farm Interval (Minutes):", UDim2.new(0.5, -125, 0.1, 0), MainFrame)
local IntervalInput = Instance.new("TextBox", MainFrame)
IntervalInput.Size = UDim2.new(0, 250, 0, 40)
IntervalInput.Position = UDim2.new(0.5, -125, 0.2, 0)
IntervalInput.Text = "13"

-- 지연(초) 입력
createLabel("Teleport Delay (Seconds):", UDim2.new(0.5, -125, 0.4, 0), MainFrame)
local DelayInput = Instance.new("TextBox", MainFrame)
DelayInput.Size = UDim2.new(0, 250, 0, 40)
DelayInput.Position = UDim2.new(0.5, -125, 0.5, 0)
DelayInput.Text = "1"

-- 실행 버튼
local AutoFarmBtn = Instance.new("TextButton", MainFrame)
AutoFarmBtn.Size = UDim2.new(0, 250, 0, 50)
AutoFarmBtn.Position = UDim2.new(0.5, -125, 0.75, 0)
AutoFarmBtn.Text = "Auto Eons: OFF"
AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
AutoFarmBtn.TextColor3 = Color3.new(1, 1, 1)

-- [[ 2. 기능 로직 ]]

-- 키 링크 처리 (클립보드 안내)
GetKeyBtn.MouseButton1Click:Connect(function()
    print("Your Key Link: " .. KEY_LINK)
    KeyInput.Text = "Link printed in F9 Console!"
end)

-- 로그인 처리
SubmitBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == SECRET_KEY then
        KeyFrame.Visible = false
        MainFrame.Visible = true
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "WRONG KEY!"
    end
end)

-- 오토팜 토글
AutoFarmBtn.MouseButton1Click:Connect(function()
    isAutoFarm = not isAutoFarm
    AutoFarmBtn.Text = isAutoFarm and "Auto Eons: ON" or "Auto Eons: OFF"
    AutoFarmBtn.BackgroundColor3 = isAutoFarm and Color3.fromRGB(60, 160, 60) or Color3.fromRGB(150, 50, 50)
end)

-- 발판 탐색 함수 (이름/색상/크기 기준)
local function findYellowButton()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            -- 노란색 계열이면서 'Button' 이름이거나 적당히 납작한 경우
            if (obj.Name:lower():find("button") or obj.BrickColor.Name:find("Yellow")) and obj.Size.Y < 2 then
                return obj
            end
        end
    end
    return nil
end

-- [[ 3. 오토팜 메인 루프 ]]
task.spawn(function()
    while true do
        task.wait(1)
        if isAutoFarm then
            local waitMinutes = tonumber(IntervalInput.Text) or 13
            task.wait(waitMinutes * 60) -- 분 단위 대기
            
            if not isAutoFarm then continue end
            
            local button = findYellowButton()
            local hrp = character:FindFirstChild("HumanoidRootPart")
            
            if button and hrp then
                local lastPos = hrp.CFrame
                local delayTime = tonumber(DelayInput.Text) or 1
                
                -- 안티치트 우회 활성화
                character:SetAttribute(BYPASS_ATTR, true)
                
                -- 1. 버튼 좌표로 강제 이동 (물리 속도 제거)
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.CFrame = CFrame.new(button.Position + Vector3.new(0, 3, 0)) 
                
                task.wait(delayTime) -- 버튼 밟는 시간
                
                -- 2. 원래 자리에서 6스터드 위로 복귀
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.CFrame = lastPos * CFrame.new(0, 6, 0)
                
                task.wait(1)
                character:SetAttribute(BYPASS_ATTR, false) -- 우회 비활성화
            end
        end
    end
end)


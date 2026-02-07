local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- [1. UI 생성 부분]
local ScreenGui = Instance.new("ScreenGui", player.PlayerGui)
ScreenGui.Name = "AprilFoolsMenu"

-- 키 입력 창
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.new(0, 300, 0, 150)
KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
KeyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local KeyInput = Instance.new("TextBox", KeyFrame)
KeyInput.Size = UDim2.new(0, 200, 0, 40)
KeyInput.Position = UDim2.new(0.5, -100, 0.3, -20)
KeyInput.PlaceholderText = "Enter Key..."
KeyInput.Text = ""

local SubmitBtn = Instance.new("TextButton", KeyFrame)
SubmitBtn.Size = UDim2.new(0, 100, 0, 40)
SubmitBtn.Position = UDim2.new(0.5, -50, 0.7, -20)
SubmitBtn.Text = "Login"
SubmitBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)

-- 메인 핵 메뉴 (처음엔 숨김)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Visible = false
MainFrame.Size = UDim2.new(0, 350, 0, 250)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local DelayInput = Instance.new("TextBox", MainFrame)
DelayInput.Size = UDim2.new(0, 250, 0, 40)
DelayInput.Position = UDim2.new(0.5, -125, 0.2, 0)
DelayInput.PlaceholderText = "Teleport Delay (seconds)"
DelayInput.Text = "0.5"

local AutoFarmBtn = Instance.new("TextButton", MainFrame)
AutoFarmBtn.Size = UDim2.new(0, 250, 0, 40)
AutoFarmBtn.Position = UDim2.new(0.5, -125, 0.5, 0)
AutoFarmBtn.Text = "Auto Eons: OFF"
AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)

-- [2. 로직 처리]
local key = "WasteTime_67"
local isAutoFarm = false
local teleportDelay = 0.5

-- 키 확인 로직
SubmitBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == key then
        KeyFrame.Visible = false
        MainFrame.Visible = true
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "Wrong Key!"
    end
end)

-- 오토팜 설정
AutoFarmBtn.MouseButton1Click:Connect(function()
    isAutoFarm = not isAutoFarm
    AutoFarmBtn.Text = isAutoFarm and "Auto Eons: ON" or "Auto Eons: OFF"
    AutoFarmBtn.BackgroundColor3 = isAutoFarm and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(150, 50, 50)
end)

-- [3. 오토팜 핵심 루프: 13분 주기]
task.spawn(function()
    while true do
        task.wait(1)
        if isAutoFarm then
            -- 13분 대기 (테스트를 위해 시간을 줄이려면 13 * 60 수정)
            task.wait(13 * 60) 
            
            local button = workspace:FindFirstChild("Button", true) -- Eons 발판 찾기
            if button and isAutoFarm then
                local lastPos = hrp.CFrame
                teleportDelay = tonumber(DelayInput.Text) or 0.5
                
                -- 안티치트 우회 속성 활성화
                character:SetAttribute("AntiCheat_Ignore", true)
                
                -- 1. 발판으로 순간이동
                hrp.CFrame = button.CFrame * CFrame.new(0, 3, 0)
                
                -- 2. 설정된 지연 시간만큼 대기 (먹는 판정)
                task.wait(teleportDelay)
                
                -- 3. 원래 위치에서 6스터드 위로 이동
                hrp.CFrame = lastPos * CFrame.new(0, 6, 0)
                
                task.wait(1)
                character:SetAttribute("AntiCheat_Ignore", false)
            end
        end
    end
end)

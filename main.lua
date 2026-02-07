local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- [설정값]
local SECRET_KEY = "WasteTime_67"
local AUTO_FARM_INTERVAL = 13 * 60 -- 13분
local EONS_BUTTON_NAME = "Button"
local BYPASS_ATTR = "AntiCheat_Ignore"

-- [1. UI 생성]
local ScreenGui = Instance.new("ScreenGui", player.PlayerGui)
ScreenGui.Name = "AprilFools_Hack"

-- 키 입력 프레임
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

-- 메인 메뉴 (비공개 상태)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Visible = false
MainFrame.Size = UDim2.new(0, 350, 0, 200)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local DelayInput = Instance.new("TextBox", MainFrame)
DelayInput.Size = UDim2.new(0, 250, 0, 40)
DelayInput.Position = UDim2.new(0.5, -125, 0.2, 0)
DelayInput.PlaceholderText = "Delay (Current: 1)"
DelayInput.Text = "1"

local AutoFarmBtn = Instance.new("TextButton", MainFrame)
AutoFarmBtn.Size = UDim2.new(0, 250, 0, 40)
AutoFarmBtn.Position = UDim2.new(0.5, -125, 0.6, 0)
AutoFarmBtn.Text = "Auto Eons: OFF"
AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)

-- [2. 핵심 함수: 경로 무관 파트 찾기]
local function findTargetPart(name)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name == name and obj:IsA("BasePart") then
            return obj
        end
    end
    return nil
end

-- [3. 로직 연결]
local isAutoFarm = false

SubmitBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == SECRET_KEY then
        KeyFrame.Visible = false
        MainFrame.Visible = true
    else
        KeyInput.PlaceholderText = "Wrong!"
        KeyInput.Text = ""
    end
end)

AutoFarmBtn.MouseButton1Click:Connect(function()
    isAutoFarm = not isAutoFarm
    AutoFarmBtn.Text = isAutoFarm and "Auto Eons: ON" or "Auto Eons: OFF"
    AutoFarmBtn.BackgroundColor3 = isAutoFarm and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(150, 50, 50)
end)

-- [4. 오토팜 루프]
task.spawn(function()
    while true do
        task.wait(1)
        if isAutoFarm then
            print("Next Eons Farm in 13 minutes...")
            task.wait(AUTO_FARM_INTERVAL)
            
            local button = findTargetPart(EONS_BUTTON_NAME)
            local hrp = character:FindFirstChild("HumanoidRootPart")
            
            if button and hrp and isAutoFarm then
                local lastPos = hrp.CFrame
                local delayTime = tonumber(DelayInput.Text) or 1
                
                -- 안티치트 일시 우회
                character:SetAttribute(BYPASS_ATTR, true)
                
                -- 이동 1: 버튼 위치
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.CFrame = button.CFrame * CFrame.new(0, 3, 0)
                
                task.wait(delayTime)
                
                -- 이동 2: 원래 위치 6스터드 위로 복귀
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.CFrame = lastPos * CFrame.new(0, 6, 0)
                
                task.wait(1)
                character:SetAttribute(BYPASS_ATTR, false)
                print("Farm Cycle Completed.")
            end
        end
    end
end)

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

-- [설정값]
local SECRET_KEY = "WasteTime_67"
local AUTO_FARM_INTERVAL = 13 * 60 -- 13분
local EONS_BUTTON_NAME = "Button"
local BYPASS_ATTR = "AntiCheat_Ignore"

-- [1. UI 생성]
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "AprilFools_Fixed"

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

-- 메인 메뉴
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Visible = false
MainFrame.Size = UDim2.new(0, 350, 0, 200)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local DelayInput = Instance.new("TextBox", MainFrame)
DelayInput.Size = UDim2.new(0, 250, 0, 40)
DelayInput.Position = UDim2.new(0.5, -125, 0.2, 0)
DelayInput.PlaceholderText = "Delay (Default: 1)"
DelayInput.Text = "1"

local AutoFarmBtn = Instance.new("TextButton", MainFrame)
AutoFarmBtn.Size = UDim2.new(0, 250, 0, 40)
AutoFarmBtn.Position = UDim2.new(0.5, -125, 0.6, 0)
AutoFarmBtn.Text = "Auto Eons: OFF"
AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)

-- [2. 핵심 함수]
local function findTargetPart(name)
    -- 가급적이면 FindFirstChild를 쓰는 것이 성능에 좋으나, 경로가 유동적이라면 Descendants 유지
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
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "Wrong Key!"
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
        task.wait(0.5) -- 반응성을 위해 루프 주기는 짧게 설정
        
        if isAutoFarm then
            local character = player.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            local button = findTargetPart(EONS_BUTTON_NAME)
            
            if hrp and button then
                print("Starting Farm Cycle...")
                local lastPos = hrp.CFrame
                local delayTime = tonumber(DelayInput.Text) or 1
                
                -- 안티치트 우회 시도
                character:SetAttribute(BYPASS_ATTR, true)
                
                -- 버튼으로 이동
                hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                hrp.CFrame = button.CFrame * CFrame.new(0, 3, 0)
                
                task.wait(delayTime)
                
                -- 원래 위치로 복귀
                hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                hrp.CFrame = lastPos * CFrame.new(0, 6, 0)
                
                character:SetAttribute(BYPASS_ATTR, false)
                print("Farm Cycle Completed. Waiting 13 minutes...")
                
                -- 13분 대기를 나눌 수 있게 처리 (중간에 껐을 때 바로 멈추도록)
                local waited = 0
                while waited < AUTO_FARM_INTERVAL and isAutoFarm do
                    task.wait(1)
                    waited = waited + 1
                end
            end
        end
    end
end)


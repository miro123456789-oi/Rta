-- GUI Automática v1
local player = game.Players.LocalPlayer
local Players = game:GetService("Players")
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "PainelAutoV1"

-- Janela Principal
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

-- Título
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "Painel Ultimate v1"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

-- Abas
local tabButtons = {}
local tabs = {"Player","Troll","Admin"}
local currentTab = "Player"

local tabFrame = Instance.new("Frame", mainFrame)
tabFrame.Size = UDim2.new(0, 400, 0, 30)
tabFrame.Position = UDim2.new(0,0,0,40)
tabFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton", tabFrame)
    btn.Size = UDim2.new(0, 130, 1, 0)
    btn.Position = UDim2.new((i-1)*0.33, 0, 0, 0)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    tabButtons[name] = btn
end

-- Área de Conteúdo
local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1, 0, 1, -70)
contentFrame.Position = UDim2.new(0, 0, 0, 70)
contentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

-- Funções auxiliares
local function clearContent()
    for _, v in ipairs(contentFrame:GetChildren()) do
        v:Destroy()
    end
end

local function addButton(text, callback)
    local btn = Instance.new("TextButton", contentFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, #contentFrame:GetChildren()*0.1, 0)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    btn.MouseButton1Click:Connect(callback)
end

-- Funções do Painel
local function showPlayerTab()
    clearContent()
    addButton("Aumentar Velocidade", function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = player.Character.Humanoid.WalkSpeed + 10
        end
    end)
    addButton("Diminuir Velocidade", function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = player.Character.Humanoid.WalkSpeed - 10
        end
    end)
    addButton("Aumentar Pulo", function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = player.Character.Humanoid.JumpPower + 10
        end
    end)
    addButton("Resetar Personagem", function()
        if player.Character then player.Character:BreakJoints() end
    end)
end

local function showTrollTab()
    clearContent()
    addButton("Explodir TODOS", function()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local exp = Instance.new("Explosion")
                exp.BlastRadius = 10
                exp.Position = plr.Character.HumanoidRootPart.Position
                exp.Parent = workspace
            end
        end
    end)
    addButton("Jumpscare TODOS", function()
        local JumpscareID = "rbxassetid://6754147732"
        for _, plr in pairs(Players:GetPlayers()) do
            local gui = Instance.new("ScreenGui")
            gui.IgnoreGuiInset = true
            local img = Instance.new("ImageLabel", gui)
            img.Size = UDim2.new(1, 0, 1, 0)
            img.Image = JumpscareID
            img.BackgroundTransparency = 1
            gui.Parent = plr:WaitForChild("PlayerGui")
            task.delay(1.5, function() gui:Destroy() end)
        end
    end)
end

local function showAdminTab()
    clearContent()
    addButton("Instalar HD Admin", function()
        local success, err = pcall(function()
            local model = game:GetObjects("rbxassetid://3239236979")[1]
            if model then
                model.Parent = workspace
            end
        end)
        if not success then warn(err) end
    end)
    addButton("Forçar Owner (HD Admin)", function()
        local hd = game:GetService("ReplicatedStorage"):FindFirstChild("HDAdmin")
        if hd and hd.Signals and hd.Signals:FindFirstChild("RequestCommand") then
            hd.Signals.RequestCommand:FireServer("setrank me owner")
        end
    end)
end

-- Alternar abas
tabButtons.Player.MouseButton1Click:Connect(showPlayerTab)
tabButtons.Troll.MouseButton1Click:Connect(showTrollTab)
tabButtons.Admin.MouseButton1Click:Connect(showAdminTab)

-- Exibir aba inicial
showPlayerTab()

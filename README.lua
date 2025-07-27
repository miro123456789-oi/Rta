-- Carregar Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Painel Ultimate v3.1",
    TabWidth = 160,
    Size = UDim2.fromOffset(620, 420),
    Theme = "Dark"
})

-- Abas principais
local Tabs = {
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Troll = Window:AddTab({ Title = "Troll Pro", Icon = "alert-triangle" }),
    Visual = Window:AddTab({ Title = "Visual", Icon = "eye" }),
    Admin = Window:AddTab({ Title = "Admin", Icon = "shield" }),
    Creditos = Window:AddTab({ Title = "Créditos", Icon = "info" })
}

Fluent:Notify({ Title = "Painel", Content = "Painel Ultimate v3.1 iniciado com sucesso!" })

local player = game.Players.LocalPlayer
local Players = game:GetService("Players")

---------------------------------------------------
-- FUNÇÕES AUXILIARES
---------------------------------------------------
local function getHumanoid()
    return player.Character and player.Character:FindFirstChild("Humanoid")
end

---------------------------------------------------
-- PLAYER
---------------------------------------------------
Tabs.Player:AddSlider("Velocidade", {
    Title = "Velocidade",
    Default = 16,
    Min = 0,
    Max = 100,
    Callback = function(value)
        if getHumanoid() then
            getHumanoid().WalkSpeed = value
        end
    end
})

Tabs.Player:AddSlider("Pulo", {
    Title = "Força do Pulo",
    Default = 50,
    Min = 0,
    Max = 200,
    Callback = function(value)
        if getHumanoid() then
            getHumanoid().JumpPower = value
        end
    end
})

Tabs.Player:AddSlider("Gravidade", {
    Title = "Gravidade",
    Default = 196.2,
    Min = 0,
    Max = 400,
    Callback = function(value)
        workspace.Gravity = value
    end
})

Tabs.Player:AddButton({
    Title = "Resetar Personagem",
    Callback = function()
        if player.Character then
            player.Character:BreakJoints()
        end
    end
})

Tabs.Player:AddButton({
    Title = "Invisibilidade",
    Callback = function()
        local char = player.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = part.Transparency == 0 and 0.7 or 0
                end
            end
        end
    end
})

---------------------------------------------------
-- TROLL PRO
---------------------------------------------------
local JumpscareID = "rbxassetid://6754147732"

local function jumpscareAll()
    for _, plr in pairs(Players:GetPlayers()) do
        local gui = Instance.new("ScreenGui")
        gui.IgnoreGuiInset = true
        gui.ResetOnSpawn = false
        local img = Instance.new("ImageLabel")
        img.Size = UDim2.new(1, 0, 1, 0)
        img.BackgroundTransparency = 1
        img.Image = JumpscareID
        img.Parent = gui
        gui.Parent = plr:WaitForChild("PlayerGui")
        task.delay(1.5, function()
            gui:Destroy()
        end)
    end
end

local function explodeAll()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local exp = Instance.new("Explosion")
            exp.BlastRadius = 10
            exp.Position = plr.Character.HumanoidRootPart.Position
            exp.Parent = workspace
        end
    end
end

local function freezeAll()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            plr.Character.HumanoidRootPart.Anchored = true
        end
    end
    Fluent:Notify({ Title = "Troll", Content = "Todos os jogadores foram presos no ar!" })
end

local function modeCaos()
    Fluent:Notify({ Title = "Modo Caos", Content = "Caos ativado em todos os jogadores!" })
    task.spawn(jumpscareAll)
    task.spawn(explodeAll)
    task.spawn(freezeAll)
end

Tabs.Troll:AddButton({ Title = "Jumpscare em TODOS", Callback = jumpscareAll })
Tabs.Troll:AddButton({ Title = "Explodir TODOS", Callback = explodeAll })
Tabs.Troll:AddButton({ Title = "Prender TODOS", Callback = freezeAll })
Tabs.Troll:AddButton({ Title = "Ativar Modo Caos", Callback = modeCaos })

---------------------------------------------------
-- VISUAL
---------------------------------------------------
local ESPEnabled = false

Tabs.Visual:AddToggle("ESP", {
    Title = "Ativar ESP",
    Default = false,
    Callback = function(state)
        ESPEnabled = state
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                for _, part in ipairs(plr.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        if state and not part:FindFirstChild("ESPHighlight") then
                            local highlight = Instance.new("Highlight")
                            highlight.Name = "ESPHighlight"
                            highlight.FillColor = Color3.fromRGB(255, 255, 0)
                            highlight.FillTransparency = 0.5
                            highlight.Parent = part
                        elseif not state and part:FindFirstChild("ESPHighlight") then
                            part.ESPHighlight:Destroy()
                        end
                    end
                end
            end
        end
    end
})

---------------------------------------------------
-- ADMIN
---------------------------------------------------
local function installHDAdmin()
    local success, err = pcall(function()
        local model = game:GetObjects("rbxassetid://3239236979")[1]
        if model then
            model.Parent = workspace
            Fluent:Notify({ Title = "Admin", Content = "HD Admin instalado no jogo!" })
        else
            Fluent:Notify({ Title = "Erro", Content = "Falha ao carregar o HD Admin." })
        end
    end)
    if not success then warn(err) end
end

local function forceAdmin()
    local hd = game:GetService("ReplicatedStorage"):FindFirstChild("HDAdmin")
    if hd and hd.Signals and hd.Signals:FindFirstChild("RequestCommand") then
        hd.Signals.RequestCommand:FireServer("setrank me owner")
        Fluent:Notify({ Title = "Admin", Content = "Você foi promovido a Owner no HD Admin!" })
    else
        Fluent:Notify({ Title = "Erro", Content = "HD Admin não está instalado." })
    end
end

Tabs.Admin:AddButton({ Title = "Instalar HD Admin", Callback = installHDAdmin })
Tabs.Admin:AddButton({ Title = "Forçar Owner (HD Admin)", Callback = forceAdmin })

---------------------------------------------------
-- CRÉDITOS
---------------------------------------------------
Tabs.Creditos:AddParagraph({
    Title = "Painel Ultimate v3.1",
    Content = "Base estável com Troll Pro, ESP e Admin."
})

Window:SelectTab(1)

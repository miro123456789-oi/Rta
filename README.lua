-- Carregar Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Painel Ultimate v3.2",
    TabWidth = 160,
    Size = UDim2.fromOffset(640, 450),
    Theme = "Dark"
})

-- Abas
local Tabs = {
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Troll = Window:AddTab({ Title = "Troll Pro", Icon = "alert-triangle" }),
    Visual = Window:AddTab({ Title = "Visual", Icon = "eye" }),
    Admin = Window:AddTab({ Title = "Admin", Icon = "shield" }),
    Creditos = Window:AddTab({ Title = "Créditos", Icon = "info" })
}

Fluent:Notify({ Title = "Painel", Content = "Painel Ultimate v3.2 iniciado com sucesso!" })

local player = game.Players.LocalPlayer
local Players = game:GetService("Players")

---------------------------------------------------
-- FUNÇÕES AUXILIARES
---------------------------------------------------
local function getHumanoid()
    return player.Character and player.Character:FindFirstChild("Humanoid")
end

local function updatePlayerList()
    local names = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            table.insert(names, plr.Name)
        end
    end
    return names
end

---------------------------------------------------
-- PODERES AVANÇADOS - PLAYER
---------------------------------------------------
local SuperForca = false
local SelectedPlayer = ""

-- Dropdown para teleport
local DropdownPlayers = Tabs.Player:AddDropdown("PlayersDropdown", {
    Title = "Selecionar Jogador",
    Values = updatePlayerList(),
    Default = 1,
    Multi = false
})
DropdownPlayers:OnChanged(function(value)
    SelectedPlayer = value
end)

-- Sliders básicos
Tabs.Player:AddSlider("Velocidade", {
    Title = "Velocidade",
    Default = 16, Min = 0, Max = 100,
    Callback = function(val)
        if getHumanoid() then getHumanoid().WalkSpeed = val end
    end
})
Tabs.Player:AddSlider("Pulo", {
    Title = "Pulo",
    Default = 50, Min = 0, Max = 200,
    Callback = function(val)
        if getHumanoid() then getHumanoid().JumpPower = val end
    end
})
Tabs.Player:AddSlider("Gravidade", {
    Title = "Gravidade",
    Default = 196.2, Min = 0, Max = 400,
    Callback = function(val)
        workspace.Gravity = val
    end
})

-- Botões de poderes
Tabs.Player:AddButton({
    Title = "Teleport até Jogador",
    Callback = function()
        local target = Players:FindFirstChild(SelectedPlayer)
        if target and target.Character and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            local thrp = target.Character:FindFirstChild("HumanoidRootPart")
            if hrp and thrp then
                hrp.CFrame = thrp.CFrame + Vector3.new(0, 3, 0)
            end
        else
            Fluent:Notify({ Title = "Teleport", Content = "Selecione um jogador válido!" })
        end
    end
})

Tabs.Player:AddButton({
    Title = "Virar Gigante",
    Callback = function()
        if getHumanoid() and player.Character:FindFirstChild("HumanoidRootPart") then
            for _, scale in pairs(player.Character:GetDescendants()) do
                if scale:IsA("NumberValue") and scale.Name:find("Scale") then
                    scale.Value = 3
                end
            end
        end
    end
})

Tabs.Player:AddButton({
    Title = "Virar Minúsculo",
    Callback = function()
        if getHumanoid() and player.Character:FindFirstChild("HumanoidRootPart") then
            for _, scale in pairs(player.Character:GetDescendants()) do
                if scale:IsA("NumberValue") and scale.Name:find("Scale") then
                    scale.Value = 0.5
                end
            end
        end
    end
})

Tabs.Player:AddButton({
    Title = "Resetar Tamanho",
    Callback = function()
        if getHumanoid() and player.Character:FindFirstChild("HumanoidRootPart") then
            for _, scale in pairs(player.Character:GetDescendants()) do
                if scale:IsA("NumberValue") and scale.Name:find("Scale") then
                    scale.Value = 1
                end
            end
        end
    end
})

Tabs.Player:AddToggle("SuperForca", {
    Title = "Super Força",
    Default = false,
    Callback = function(state)
        SuperForca = state
        Fluent:Notify({ Title = "Player", Content = state and "Dano triplicado!" or "Dano normal." })
    end
})

Tabs.Player:AddButton({
    Title = "Invisibilidade",
    Callback = function()
        if player.Character then
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = part.Transparency == 0 and 0.7 or 0
                end
            end
        end
    end
})

---------------------------------------------------
-- ARMAS RÁPIDAS
---------------------------------------------------
local function createWeapon(name, size, damage)
    local tool = Instance.new("Tool")
    tool.Name = name
    tool.RequiresHandle = true
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = size
    handle.Color = Color3.fromRGB(120, 120, 120)
    handle.Parent = tool
    tool.Activated:Connect(function()
        handle.Touched:Connect(function(hit)
            local hum = hit.Parent:FindFirstChild("Humanoid")
            if hum and hum ~= getHumanoid() then
                hum:TakeDamage(SuperForca and damage * 3 or damage)
            end
        end)
    end)
    tool.Parent = player.Backpack
end

Tabs.Player:AddButton({
    Title = "Dar Todas as Armas",
    Callback = function()
        createWeapon("Espada", Vector3.new(1, 4, 1), 20)
        createWeapon("Faca", Vector3.new(1, 2, 0.5), 15)
        createWeapon("Bazuca", Vector3.new(1, 2, 4), 30)
        Fluent:Notify({ Title = "Armas", Content = "Todas as armas adicionadas!" })
    end
})

---------------------------------------------------
-- VISUAL (ESP)
---------------------------------------------------
local ESPEnabled = false
local function updateESP(state)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            for _, part in ipairs(plr.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    if state and not part:FindFirstChild("ESPHighlight") then
                        local h = Instance.new("Highlight")
                        h.Name = "ESPHighlight"
                        h.FillColor = Color3.fromRGB(255, 255, 0)
                        h.Parent = part
                    elseif not state and part:FindFirstChild("ESPHighlight") then
                        part.ESPHighlight:Destroy()
                    end
                end
            end
        end
    end
end

Tabs.Visual:AddToggle("ESP", {
    Title = "Ativar ESP",
    Default = false,
    Callback = function(state)
        ESPEnabled = state
        updateESP(state)
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
    Title = "Painel Ultimate v3.2",
    Content = "Agora com poderes avançados, teleport e todas as armas."
})

Window:SelectTab(1)

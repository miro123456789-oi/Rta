-- Carregar Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Painel Ultimate v3.0",
    TabWidth = 160,
    Size = UDim2.fromOffset(670, 500),
    Theme = "Dark"
})

-- Abas
local Tabs = {
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Armas = Window:AddTab({ Title = "Armas", Icon = "sword" }),
    Troll = Window:AddTab({ Title = "Troll", Icon = "alert-triangle" }),
    Visual = Window:AddTab({ Title = "Visual", Icon = "eye" }),
    Admin = Window:AddTab({ Title = "Admin", Icon = "shield" }),
    Creditos = Window:AddTab({ Title = "Créditos", Icon = "info" })
}

local player = game.Players.LocalPlayer
local Players = game:GetService("Players")

---------------------------------------------------
-- FUNÇÕES GERAIS
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
-- ABA ADMIN
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
-- ABA PLAYER – PODERES NORMAIS
---------------------------------------------------
local AdminMode = false -- alterna entre modo normal e HD admin

Tabs.Player:AddToggle("AdminMode", {
    Title = "Ativar Modo Admin Powers",
    Default = false,
    Callback = function(state)
        AdminMode = state
        Fluent:Notify({
            Title = "Player",
            Content = state and "Usando comandos HD Admin." or "Usando poderes normais."
        })
    end
})

-- Invisibilidade
Tabs.Player:AddButton({
    Title = "Invisibilidade",
    Callback = function()
        if AdminMode then
            game.ReplicatedStorage.HDAdmin.Signals.RequestCommand:FireServer(":invisible me")
        else
            local char = player.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Transparency = part.Transparency == 0 and 0.7 or 0
                    end
                end
            end
        end
    end
})

-- Super força
local SuperForca = false
Tabs.Player:AddToggle("SuperForca", {
    Title = "Super Força",
    Default = false,
    Callback = function(state)
        SuperForca = state
        Fluent:Notify({ Title = "Player", Content = state and "Dano triplicado!" or "Dano normal." })
    end
})

-- Sliders
Tabs.Player:AddSlider("Velocidade", {
    Title = "Velocidade",
    Default = 16, Min = 0, Max = 100,
    Callback = function(val)
        if AdminMode then
            game.ReplicatedStorage.HDAdmin.Signals.RequestCommand:FireServer(":speed me " .. val)
        elseif getHumanoid() then
            getHumanoid().WalkSpeed = val
        end
    end
})

Tabs.Player:AddSlider("JumpPower", {
    Title = "Pulo",
    Default = 50, Min = 0, Max = 200,
    Callback = function(val)
        if AdminMode then
            game.ReplicatedStorage.HDAdmin.Signals.RequestCommand:FireServer(":jumpPower me " .. val)
        elseif getHumanoid() then
            getHumanoid().JumpPower = val
        end
    end
})

-- Teleport
local SelectedPlayer = ""
local DropdownPlayers = Tabs.Player:AddDropdown("PlayersDropdown", {
    Title = "Selecionar Jogador",
    Values = updatePlayerList(),
    Default = 1,
    Multi = false
})
DropdownPlayers:OnChanged(function(val)
    SelectedPlayer = val
end)

Tabs.Player:AddButton({
    Title = "Teleport até Jogador",
    Callback = function()
        local target = Players:FindFirstChild(SelectedPlayer)
        if target and target.Character and player.Character then
            local myHRP = player.Character:FindFirstChild("HumanoidRootPart")
            local tgtHRP = target.Character:FindFirstChild("HumanoidRootPart")
            if myHRP and tgtHRP then
                if AdminMode then
                    game.ReplicatedStorage.HDAdmin.Signals.RequestCommand:FireServer(":tp me " .. target.Name)
                else
                    myHRP.CFrame = tgtHRP.CFrame + Vector3.new(0, 3, 0)
                end
            end
        end
    end
})

-- Tamanho
Tabs.Player:AddButton({
    Title = "Virar Gigante",
    Callback = function()
        if AdminMode then
            game.ReplicatedStorage.HDAdmin.Signals.RequestCommand:FireServer(":size me 10")
        elseif getHumanoid() then
            player.Character.Humanoid.BodyHeightScale.Value = 3
            player.Character.Humanoid.BodyWidthScale.Value = 3
            player.Character.Humanoid.BodyDepthScale.Value = 3
        end
    end
})

Tabs.Player:AddButton({
    Title = "Virar Minúsculo",
    Callback = function()
        if AdminMode then
            game.ReplicatedStorage.HDAdmin.Signals.RequestCommand:FireServer(":size me 0.5")
        elseif getHumanoid() then
            player.Character.Humanoid.BodyHeightScale.Value = 0.5
            player.Character.Humanoid.BodyWidthScale.Value = 0.5
            player.Character.Humanoid.BodyDepthScale.Value = 0.5
        end
    end
})

---------------------------------------------------
-- ESP (ABA VISUAL)
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
})

---------------------------------------------------
-- ARMAS (com dano ajustável)
---------------------------------------------------
local function createMelee(name, size, baseDamage)
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
                local dmg = SuperForca and baseDamage * 3 or baseDamage
                hum:TakeDamage(dmg)
            end
        end)
    end)
    tool.Parent = player.Backpack
end

Tabs.Armas:AddButton({ Title = "Espada", Callback = function() createMelee("Espada", Vector3.new(1, 4, 1), 20) end })
Tabs.Armas:AddButton({ Title = "Faca", Callback = function() createMelee("Faca", Vector3.new(1, 2, 0.5), 15) end })

---------------------------------------------------
-- CRÉDITOS
---------------------------------------------------
Tabs.Creditos:AddParagraph({
    Title = "Painel Ultimate v3.0",
    Content = "HD Admin + Poderes + Troll + ESP. Código revisado e otimizado."
})

Window:SelectTab(1)

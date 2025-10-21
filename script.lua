-- Auto Attack with Axe
local AutoAttackEnabled = false
local AttackRange = 25
local AttackSpeed = 0.5

-- Список мобів для атаки
local AttackTargets = {
    "Alpha Wolf", "Wolf", "Crossbow Cultist", "Cultist", "Bear", "Bunny", "Deer"
}

-- Основна функція атаки
local function autoAttackLoop()
    while true do
        if AutoAttackEnabled then
            local character = LocalPlayer.Character
            if character and character:FindFirstChildOfClass("Tool") then
                local tool = character:FindFirstChildOfClass("Tool")
                local playerPos = character.HumanoidRootPart.Position
                
                -- Шукаємо найближчого моба
                local closestMob = nil
                local closestDistance = AttackRange
                
                for _, mob in pairs(workspace:GetDescendants()) do
                    if mob:IsA("Model") and table.find(AttackTargets, mob.Name) then
                        if mob:FindFirstChild("HumanoidRootPart") then
                            local mobPos = mob.HumanoidRootPart.Position
                            local distance = (playerPos - mobPos).Magnitude
                            
                            if distance <= closestDistance then
                                closestMob = mob
                                closestDistance = distance
                            end
                        end
                    end
                end
                
                -- Атакуємо найближчого моба
                if closestMob then
                    -- Телепортуємося до моба
                    character:PivotTo(closestMob.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3))
                    task.wait(0.1)
                    
                    -- Симулюємо клік миші для атаки
                    mouse1click()
                    
                    -- Повідомлення в чат (опціонально)
                    sendChatMessage("⚔️ Атакую " .. closestMob.Name .. "!")
                end
            else
                Rayfield:Notify({
                    Title = "Auto Attack",
                    Content = "Тримай топір в руках!",
                    Duration = 3,
                })
            end
        end
        task.wait(AttackSpeed)
    end
end

-- Запускаємо цикл атаки
task.spawn(autoAttackLoop)

-- Додаємо перемикач в GUI
HomeTab:CreateToggle({
    Name = "Auto Attack Mobs",
    CurrentValue = false,
    Callback = function(value)
        AutoAttackEnabled = value
        Rayfield:Notify({
            Title = "Auto Attack",
            Content = value and "Авто-атака увімкнена!" or "Авто-атака вимкнена!",
            Duration = 4,
            Image = 4483362458,
        })
    end
})

-- Слайдер для налаштування радіусу атаки
HomeTab:CreateSlider({
    Name = "Attack Range",
    Range = {10, 50},
    Increment = 1,
    Suffix = "Studs",
    CurrentValue = AttackRange,
    Callback = function(value)
        AttackRange = value
    end
})

-- Слайдер для швидкості атаки
HomeTab:CreateSlider({
    Name = "Attack Speed",
    Range = {0.2, 2},
    Increment = 0.1,
    Suffix = "Seconds",
    CurrentValue = AttackSpeed,
    Callback = function(value)
        AttackSpeed = value
    end
})

-- Функція для вибору цілей атаки
local AttackTab = Window:CreateTab("⚔️ Attack Settings ⚔️", 4483362458)

for _, mobName in ipairs(AttackTargets) do
    AttackTab:CreateToggle({
        Name = "Attack " .. mobName,
        CurrentValue = true,
        Callback = function(value)
            if value then
                table.insert(AttackTargets, mobName)
            else
                for i, name in ipairs(AttackTargets) do
                    if name == mobName then
                        table.remove(AttackTargets, i)
                        break
                    end
                end
            end
        end
    })
end

local menuOpen = false
local societyMoney = 0
local canWash = false
local grades = {}
local employees = {}
local selectedEmployee = nil
local pendingRecruit = nil

local pos = BossRageUI.Position or { X = 0, Y = 0 }
local mainMenu = RageUI.CreateMenu(BossRageUI.Title, BossRageUI.Subtitle, pos.X, pos.Y)
local moneyMenu = RageUI.CreateSubMenu(mainMenu, BossRageUI.Title, locale('money_options'), pos.X, pos.Y)
local announceMenu = RageUI.CreateSubMenu(mainMenu, BossRageUI.Title, locale('announce_'), pos.X, pos.Y)
local gradeMenu = RageUI.CreateSubMenu(mainMenu, BossRageUI.Title, locale('grade_options'), pos.X, pos.Y)
local employeeMenu = RageUI.CreateSubMenu(mainMenu, BossRageUI.Title, locale('employee_options'), pos.X, pos.Y)
local employeeActionsMenu = RageUI.CreateSubMenu(employeeMenu, BossRageUI.Title, 'Employé', pos.X, pos.Y)
local recruitConfirmMenu = RageUI.CreateSubMenu(mainMenu, BossRageUI.Title, BossRageUI.Texts.recruitConfirm, pos.X, pos.Y)

local allMenus = { mainMenu, moneyMenu, announceMenu, gradeMenu, employeeMenu, employeeActionsMenu, recruitConfirmMenu }
for i = 1, #allMenus do
    local c = BossRageUI.Banner
    if c then allMenus[i]:SetRectangleBanner(c.R, c.G, c.B, c.A) end
end

local function notify(message)
    ESX.ShowNotification(message)
end

local function keyboardInput(title, defaultText, maxLength)
    AddTextEntry('ATO_BOSS_INPUT', title)
    DisplayOnscreenKeyboard(1, 'ATO_BOSS_INPUT', '', defaultText or '', '', '', '', maxLength or BossRageUI.InputMaxLength or 60)
    while UpdateOnscreenKeyboard() == 0 do Wait(0) end
    if UpdateOnscreenKeyboard() == 1 then return GetOnscreenKeyboardResult() end
    return nil
end

local function getClosestPlayer(maxDistance)
    local myPed = PlayerPedId()
    local myCoords = GetEntityCoords(myPed)
    local closestPlayer, closestDistance
    for _, player in ipairs(GetActivePlayers()) do
        if player ~= PlayerId() then
            local ped = GetPlayerPed(player)
            if DoesEntityExist(ped) then
                local distance = #(GetEntityCoords(ped) - myCoords)
                if distance <= maxDistance and (not closestDistance or distance < closestDistance) then
                    closestPlayer, closestDistance = player, distance
                end
            end
        end
    end
    return closestPlayer, closestDistance
end

local function closeMenus()
    menuOpen = false
    for i = 1, #allMenus do RageUI.Visible(allMenus[i], false) end
end

local function openMain()
    if menuOpen then closeMenus() return end
    menuOpen = true
    RageUI.Visible(mainMenu, true)

    CreateThread(function()
        while menuOpen do
            RageUI.IsVisible(mainMenu, function()
                local job = ESX.PlayerData.job or {}
                RageUI.Separator((locale('your_society') .. '~r~%s'):format(job.label or job.name or '?'))
                RageUI.Separator((BossRageUI.Texts.societyFunds):format(societyMoney))

                RageUI.Button(locale('recruit'), locale('desc_recruit'), { RightLabel = '→' }, true, {
                    onSelected = function()
                        local player = getClosestPlayer(BossRageUI.RecruitDistance or 5.0)
                        if not player then return notify(BossRageUI.Texts.noPlayer) end
                        pendingRecruit = GetPlayerServerId(player)
                    end
                }, recruitConfirmMenu)

                RageUI.Button(locale('announce_'), locale('desc_announce'), { RightLabel = '→→' }, true, {}, announceMenu)
                RageUI.Button(locale('grade_options'), locale('grade_options_desc'), { RightLabel = '→→' }, true, {
                    onSelected = function() TriggerServerEvent('ato:societyboss:gradeOptions') end
                }, gradeMenu)
                RageUI.Button(locale('employee_options'), locale('employee_options_desc'), { RightLabel = '→→' }, true, {
                    onSelected = function() TriggerServerEvent('ato:societyboss:employeeOptions') end
                }, employeeMenu)
                RageUI.Button(locale('money_options'), locale('money_options_desc'), { RightLabel = '→→' }, true, {}, moneyMenu)
            end)

            RageUI.IsVisible(recruitConfirmMenu, function()
                RageUI.Separator(('ID joueur : ~r~%s'):format(pendingRecruit or '?'))
                RageUI.Button('Confirmer', 'Recruter ce joueur dans votre entreprise.', {}, pendingRecruit ~= nil, {
                    onSelected = function()
                        if pendingRecruit then TriggerServerEvent('ato:societyboss:recruit', pendingRecruit) end
                        pendingRecruit = nil
                        RageUI.GoBack()
                    end
                })
                RageUI.Button('Annuler', 'Annuler le recrutement.', {}, true, {
                    onSelected = function()
                        pendingRecruit = nil
                        RageUI.GoBack()
                    end
                })
            end)

            RageUI.IsVisible(announceMenu, function()
                RageUI.Button(BossRageUI.Texts.employeeAnnouncement, 'Envoyer une annonce à tous les employés.', {}, true, {
                    onSelected = function()
                        local title = keyboardInput(locale('announce_title'), '', 40)
                        if not title or title == '' then return end
                        local desc = keyboardInput(locale('announce_desc'), '', 120)
                        if not desc or desc == '' then return end
                        TriggerServerEvent('ato:societyboss:announceEmployee', title, desc)
                    end
                })
                RageUI.Button(BossRageUI.Texts.publicAnnouncement, 'Envoyer une annonce à tous les joueurs.', {}, true, {
                    onSelected = function()
                        local title = keyboardInput(locale('announce_title'), '', 40)
                        if not title or title == '' then return end
                        local desc = keyboardInput(locale('announce_desc'), '', 120)
                        if not desc or desc == '' then return end
                        TriggerServerEvent('ato:societyboss:players', title, desc)
                    end
                })
            end)

            RageUI.IsVisible(moneyMenu, function()
                RageUI.Separator((BossRageUI.Texts.societyFunds):format(societyMoney))
                RageUI.Button(locale('deposit_money'), locale('deposit_money_desc'), {}, true, {
                    onSelected = function()
                        local amount = tonumber(keyboardInput(locale('ammount'), '', 10))
                        if not amount or amount <= 0 then return notify(BossRageUI.Texts.invalidAmount) end
                        TriggerServerEvent('ato:societyboss:moneyGestion', 'deposit', math.floor(amount))
                    end
                })
                RageUI.Button(locale('withtdraw_money'), locale('withtdraw_money_desc'), {}, true, {
                    onSelected = function()
                        local amount = tonumber(keyboardInput(locale('ammount'), '', 10))
                        if not amount or amount <= 0 then return notify(BossRageUI.Texts.invalidAmount) end
                        TriggerServerEvent('ato:societyboss:moneyGestion', 'withdraw', math.floor(amount))
                    end
                })
                RageUI.Button(locale('wash_money'), locale('desc_wash_money'), {}, canWash, {
                    onSelected = function()
                        local amount = tonumber(keyboardInput(locale('ammount'), '', 10))
                        if not amount or amount <= 0 then return notify(BossRageUI.Texts.invalidAmount) end
                        TriggerServerEvent('ato:societyboss:washMoney', math.floor(amount))
                    end
                })
            end)

            RageUI.IsVisible(gradeMenu, function()
                if #grades == 0 then RageUI.Separator('~c~Chargement des grades...') end
                for i = 1, #grades do
                    local data = grades[i]
                    local current = tonumber(data.grade) == tonumber(ESX.PlayerData.job.grade)
                    RageUI.Button(('%s ~c~(Salaire: $%s)'):format(data.gradeLabel, data.gradeSalary), current and locale('rework_disabled') or locale('rework_enabled'), {}, not current, {
                        onSelected = function()
                            local label = keyboardInput(locale('rework_name'), data.gradeLabel, 40)
                            if not label or label == '' then return end
                            local salary = tonumber(keyboardInput(locale('rework_salary'), tostring(data.gradeSalary), 8))
                            if not salary or salary < 0 or salary > Shared.maxSalary then
                                return notify(locale('error_max_salary') .. Shared.maxSalary)
                            end
                            TriggerServerEvent('ato:societyboss:updateGrade', data.grade, math.floor(salary), label)
                        end
                    })
                end
            end)

            RageUI.IsVisible(employeeMenu, function()
                RageUI.Separator((BossRageUI.Texts.employeeCount):format(#employees))
                if #employees == 0 then RageUI.Separator('~c~Aucun employé à afficher.') end
                for i = 1, #employees do
                    local data = employees[i]
                    RageUI.Button(('%s %s'):format(data.firstname or '', data.lastname or ''), ('Grade: %s | Né(e): %s'):format(data.grade or '?', data.dob or '?'), { RightLabel = '→→' }, true, {
                        onSelected = function() selectedEmployee = data end
                    }, employeeActionsMenu)
                end
            end)

            RageUI.IsVisible(employeeActionsMenu, function()
                if not selectedEmployee then return end
                RageUI.Separator(('~r~%s %s'):format(selectedEmployee.firstname or '', selectedEmployee.lastname or ''))
                RageUI.Separator(('Grade : ~c~%s | Sexe : ~c~%s | Taille : ~c~%s'):format(selectedEmployee.grade or '?', selectedEmployee.sex or '?', selectedEmployee.height or '?'))
                RageUI.Button(BossRageUI.Texts.promote, 'Augmenter le grade de cet employé.', {}, true, {
                    onSelected = function() TriggerServerEvent('ato:societyboss:promote', selectedEmployee.identifier) end
                })
                RageUI.Button(BossRageUI.Texts.downgrade, 'Descendre le grade de cet employé.', {}, true, {
                    onSelected = function() TriggerServerEvent('ato:societyboss:downgrade', selectedEmployee.identifier) end
                })
                RageUI.Button(BossRageUI.Texts.fire, 'Expulser cet employé de l’entreprise.', {}, true, {
                    onSelected = function() TriggerServerEvent('ato:societyboss:expulse', selectedEmployee.identifier) end
                })
            end)

            Wait(0)
        end
    end)
end

RegisterNetEvent('ato:societyboss:openBossMenu', function(money, washAllowed)
    societyMoney = tonumber(money) or 0
    canWash = washAllowed == true
    grades = {}
    employees = {}
    openMain()
end)

RegisterNetEvent('ato:societyboss:gradeList', function(optionsGrade)
    grades = optionsGrade or {}
end)

RegisterNetEvent('ato:societyboss:employeeList', function(optionsEmployee)
    employees = optionsEmployee or {}
end)

RegisterNetEvent('ato:societyboss:updateMoney', function(money)
    societyMoney = tonumber(money) or societyMoney
end)

RegisterNetEvent('ato:societyboss:refreshEmployees', function()
    selectedEmployee = nil
    TriggerServerEvent('ato:societyboss:employeeOptions')
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then closeMenus() end
end)

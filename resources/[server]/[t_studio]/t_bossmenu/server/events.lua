lib.locale()

local function getSociety(jobName)
    for i = 1, #Shared.society do
        if Shared.society[i].name == jobName then return Shared.society[i] end
    end
end

local function getBoss(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return nil end
    local job = xPlayer.getJob()
    local society = getSociety(job.name)
    if not society or tonumber(job.grade) < tonumber(society.bossGrade) then return nil end
    return xPlayer, society, job
end

local function validAmount(value)
    value = tonumber(value)
    if not value or value <= 0 or value ~= value or value == math.huge then return nil end
    return math.floor(value)
end

local function cleanText(value, maxLength)
    if type(value) ~= 'string' then return nil end
    value = value:gsub('^%s+', ''):gsub('%s+$', '')
    if value == '' then return nil end
    return value:sub(1, maxLength)
end

local function refreshMoney(src, jobName)
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. jobName, function(account)
        if account then TriggerClientEvent('ato:societyboss:updateMoney', src, account.money or 0) end
    end)
end

RegisterNetEvent('ato:societyboss:svopenBossMenu', function()
    local src = source
    local xPlayer, society, job = getBoss(src)
    if not xPlayer then return end

    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. job.name, function(account)
        if not account then return end
        TriggerClientEvent('ato:societyboss:openBossMenu', src, account.money or 0, society.washMoney == true)
    end)
end)

RegisterNetEvent('ato:societyboss:recruit', function(playerId)
    local src = source
    local boss, _, job = getBoss(src)
    if not boss then return end

    playerId = tonumber(playerId)
    local target = playerId and ESX.GetPlayerFromId(playerId)
    if not target or target.source == src then return end
    if not ESX.DoesJobExist(job.name, 0) then return end

    target.setJob(job.name, 0)
    MySQL.update('UPDATE users SET job = ?, job_grade = ? WHERE identifier = ?', { job.name, 0, target.identifier })
    sendServerNotify(src, 'Information', 'Vous avez bien recruté : ' .. target.getName(), 'inform')
    sendServerNotify(target.source, 'Information', 'Vous avez été recruté dans ' .. (job.label or job.name), 'inform')
    sendLogs(Shared.logs.recruit, 'Recrutement', ('Patron: %s\nEmployé: %s\nMétier: %s'):format(boss.identifier, target.identifier, job.name))
end)

RegisterNetEvent('ato:societyboss:announceEmployee', function(title, desc)
    local src = source
    local boss, _, job = getBoss(src)
    if not boss then return end
    title, desc = cleanText(title, 40), cleanText(desc, 120)
    if not title or not desc then return end

    local xPlayers = ESX.GetExtendedPlayers('job', job.name)
    for i = 1, #xPlayers do sendServerNotify(xPlayers[i].source, title, desc, 'inform') end
    sendLogs(Shared.logs.announce, 'Annonce Employés', ('Patron: %s\nTitre: %s\nMessage: %s'):format(boss.identifier, title, desc))
end)

RegisterNetEvent('ato:societyboss:players', function(title, desc)
    local src = source
    local boss = getBoss(src)
    if not boss then return end
    title, desc = cleanText(title, 40), cleanText(desc, 120)
    if not title or not desc then return end

    sendServerNotify(-1, title, desc, 'inform')
    sendLogs(Shared.logs.announce, 'Annonce Publique', ('Patron: %s\nTitre: %s\nMessage: %s'):format(boss.identifier, title, desc))
end)

RegisterNetEvent('ato:societyboss:washMoney', function(amount)
    local src = source
    local player, society = getBoss(src)
    if not player or not society.washMoney then return end
    amount = validAmount(amount)
    if not amount then return end

    local account = player.getAccount('black_money')
    if not account or account.money < amount then
        return sendServerNotify(src, locale('error'), locale('not_enough_money'), 'error')
    end

    local cleanAmount = math.floor(amount * Shared.whiteningPercentage)
    player.removeAccountMoney('black_money', amount)
    player.addMoney(cleanAmount)
    sendLogs(Shared.logs.washMoney, 'Blanchiment d\'argent', ('Player: %s\nMontant sale: %s\nMontant reçu: %s'):format(player.identifier, amount, cleanAmount))
end)

RegisterNetEvent('ato:societyboss:gradeOptions', function()
    local src = source
    local _, _, job = getBoss(src)
    if not job then return end

    MySQL.query('SELECT grade, name, label, salary FROM job_grades WHERE job_name = ? ORDER BY grade ASC', { job.name }, function(result)
        local options = {}
        for i = 1, #(result or {}) do
            local row = result[i]
            options[#options + 1] = {
                grade = row.grade,
                gradeName = row.name,
                gradeLabel = row.label,
                gradeSalary = row.salary
            }
        end
        TriggerClientEvent('ato:societyboss:gradeList', src, options)
    end)
end)

RegisterNetEvent('ato:societyboss:updateGrade', function(grade, newSalary, newGradeLabel)
    local src = source
    local player, _, job = getBoss(src)
    if not player then return end

    grade, newSalary = tonumber(grade), validAmount(newSalary)
    newGradeLabel = cleanText(newGradeLabel, 40)
    if grade == nil or not newSalary or not newGradeLabel or newSalary > Shared.maxSalary then return end
    if tonumber(job.grade) == grade or grade > tonumber(job.grade) then return end

    MySQL.update('UPDATE job_grades SET salary = ?, label = ? WHERE job_name = ? AND grade = ?', {
        newSalary, newGradeLabel, job.name, grade
    }, function(rowsChanged)
        if not rowsChanged or rowsChanged < 1 then return end
        ESX.RefreshJobs()
        local xPlayers = ESX.GetExtendedPlayers('job', job.name)
        for _, target in pairs(xPlayers) do
            if tonumber(target.job.grade) == grade then target.setJob(job.name, grade) end
        end
        sendLogs(Shared.logs.reworkGrade, 'Modification de grade', ('Patron: %s\nGrade: %s\nNouveau label: %s\nNouveau salaire: %s'):format(player.identifier, grade, newGradeLabel, newSalary))
    end)
end)

RegisterNetEvent('ato:societyboss:employeeOptions', function()
    local src = source
    local player, _, job = getBoss(src)
    if not player then return end

    MySQL.query('SELECT identifier, job, job_grade, firstname, lastname, dateofbirth, sex, height FROM users WHERE job = ?', { job.name }, function(result)
        local options = {}
        for i = 1, #(result or {}) do
            local row = result[i]
            if row.identifier ~= player.identifier then
                options[#options + 1] = {
                    identifier = row.identifier,
                    job = row.job,
                    grade = row.job_grade,
                    firstname = row.firstname,
                    lastname = row.lastname,
                    dob = row.dateofbirth,
                    sex = row.sex,
                    height = row.height
                }
            end
        end
        TriggerClientEvent('ato:societyboss:employeeList', src, options, #options)
    end)
end)

local function getEmployeeForBoss(src, identifier, cb)
    local boss, _, job = getBoss(src)
    if not boss or type(identifier) ~= 'string' then return end
    MySQL.single('SELECT identifier, job, job_grade FROM users WHERE identifier = ? LIMIT 1', { identifier }, function(row)
        if not row or row.job ~= job.name or row.identifier == boss.identifier then return end
        cb(boss, job, row)
    end)
end

RegisterNetEvent('ato:societyboss:promote', function(identifier)
    local src = source
    getEmployeeForBoss(src, identifier, function(boss, job, employee)
        local oldGrade = tonumber(employee.job_grade) or 0
        local newGrade = oldGrade + 1
        if newGrade >= tonumber(job.grade) or not ESX.DoesJobExist(job.name, newGrade) then
            return sendServerNotify(src, locale('error'), locale('no_grade'), 'error')
        end

        MySQL.update('UPDATE users SET job_grade = ? WHERE identifier = ? AND job = ?', { newGrade, identifier, job.name })
        local target = ESX.GetPlayerFromIdentifier(identifier)
        if target then target.setJob(job.name, newGrade) end
        sendLogs(Shared.logs.reworkGrade, 'Promotion', ('Patron: %s\nEmployé: %s\nNouveau grade: %s'):format(boss.identifier, identifier, newGrade))
        TriggerClientEvent('ato:societyboss:refreshEmployees', src)
    end)
end)

RegisterNetEvent('ato:societyboss:downgrade', function(identifier)
    local src = source
    getEmployeeForBoss(src, identifier, function(boss, job, employee)
        local oldGrade = tonumber(employee.job_grade) or 0
        if oldGrade <= 0 then return sendServerNotify(src, locale('error'), locale('no_grade'), 'error') end
        local newGrade = oldGrade - 1

        MySQL.update('UPDATE users SET job_grade = ? WHERE identifier = ? AND job = ?', { newGrade, identifier, job.name })
        local target = ESX.GetPlayerFromIdentifier(identifier)
        if target then target.setJob(job.name, newGrade) end
        sendLogs(Shared.logs.reworkGrade, 'Rétrogradation', ('Patron: %s\nEmployé: %s\nNouveau grade: %s'):format(boss.identifier, identifier, newGrade))
        TriggerClientEvent('ato:societyboss:refreshEmployees', src)
    end)
end)

RegisterNetEvent('ato:societyboss:expulse', function(identifier)
    local src = source
    getEmployeeForBoss(src, identifier, function(boss, job)
        MySQL.update('UPDATE users SET job = ?, job_grade = ? WHERE identifier = ? AND job = ?', {
            Shared.unemployedJob, Shared.unemployedGrade, identifier, job.name
        })
        local target = ESX.GetPlayerFromIdentifier(identifier)
        if target then target.setJob(Shared.unemployedJob, Shared.unemployedGrade) end
        sendLogs(Shared.logs.reworkGrade, 'Licenciement', ('Patron: %s\nEmployé: %s'):format(boss.identifier, identifier))
        TriggerClientEvent('ato:societyboss:refreshEmployees', src)
    end)
end)

RegisterNetEvent('ato:societyboss:moneyGestion', function(action, amount)
    local src = source
    local player, _, job = getBoss(src)
    if not player then return end
    amount = validAmount(amount)
    if not amount then return end

    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. job.name, function(account)
        if not account then return end

        if action == 'deposit' then
            if player.getMoney() < amount then
                return sendServerNotify(src, locale('error'), locale('not_enough_money'), 'error')
            end
            player.removeMoney(amount)
            account.addMoney(amount)
            sendLogs(Shared.logs.moneyInteraction, 'Dépôt société', ('Patron: %s\nSociété: %s\nMontant: %s'):format(player.identifier, job.name, amount))
        elseif action == 'withdraw' then
            if account.money < amount then
                return sendServerNotify(src, locale('error'), locale('society_not_enough_money'), 'error')
            end
            account.removeMoney(amount)
            player.addMoney(amount)
            sendLogs(Shared.logs.moneyInteraction, 'Retrait société', ('Patron: %s\nSociété: %s\nMontant: %s'):format(player.identifier, job.name, amount))
        else
            return
        end

        refreshMoney(src, job.name)
    end)
end)

--Fichier modifié par Nexora Developments pour intégration du job2
--Note: ne pas modifier si vous ne savez pas ce que vous faites
local Jobs2 = {}

function OpenBossMenu(society, close, options)
    options = options or {}
    local elements = {
        {unselectable = true, icon = "fas fa-user", title = TranslateCap('boss_menu')}
    }

    ESX.TriggerServerCallback('esx_society:isBoss', function(isBoss)
        ESX.TriggerServerCallback('esx_society:isBoss2', function(isBoss2)
            if isBoss or isBoss2 then
                local defaultOptions = {
                    checkBal = true,
                    withdraw = true,
                    deposit = true,
                    wash = true,
                    employees = true,
                    salary = true,
                    grades = true
                }

                for k,v in pairs(defaultOptions) do
                    if options[k] == nil then
                        options[k] = v
                    end
                end

                if options.checkBal then
                    elements[#elements+1] = {icon = "fas fa-wallet", title = TranslateCap('check_society_balance'), value = "check_society_balance"}
                end
                if options.withdraw then
                    elements[#elements+1] = {icon = "fas fa-wallet", title = TranslateCap('withdraw_society_money'), value = "withdraw_society_money"}
                end
                if options.deposit then
                    elements[#elements+1] = {icon = "fas fa-wallet", title = TranslateCap('deposit_society_money'), value = "deposit_money"}
                end
                if options.wash then
                    elements[#elements+1] = {icon = "fas fa-wallet", title = TranslateCap('wash_money'), value = "wash_money"}
                end
                if options.employees then
                    elements[#elements+1] = {icon = "fas fa-users", title = TranslateCap('employee_management'), value = "manage_employees"}
                end
                if options.salary then
                    elements[#elements+1] = {icon = "fas fa-wallet", title = TranslateCap('salary_management'), value = "manage_salary"}
                end
                if options.grades then
                    elements[#elements+1] = {icon = "fas fa-scroll", title = TranslateCap('grade_management'), value = "manage_grades"}
                end

                ESX.OpenContext("right", elements, function(menu, element)
                    if element.value == "check_society_balance" then
                        TriggerServerEvent('esx_society:checkSocietyBalance', society)
                    elseif element.value == "withdraw_society_money" then
                        OpenAmountMenu(society, "withdraw")
                    elseif element.value == "deposit_money" then
                        OpenAmountMenu(society, "deposit")
                    elseif element.value == "wash_money" then
                        OpenAmountMenu(society, "wash")
                    elseif element.value == "manage_employees" then
                        OpenManageEmployeesMenu(society, options)
                    elseif element.value == "manage_salary" then
                        OpenManageSalaryMenu(society, options)
                    elseif element.value == "manage_grades" then
                        OpenManageGradesMenu(society, options)
                    elseif element.value == "return" then
                        if close then close() end
                    end
                end, close)
            end
        end, society)
    end, society)
end

function OpenAmountMenu(society, type)
    local labels = {
        withdraw = TranslateCap('withdraw_amount'),
        deposit = TranslateCap('deposit_amount'),
        wash = TranslateCap('wash_money_amount')
    }

    local descriptions = {
        withdraw = TranslateCap('withdraw_description'),
        deposit = TranslateCap('deposit_description'),
        wash = TranslateCap('wash_money_description')
    }

    local confirmEvents = {
        withdraw = 'esx_society:withdrawMoney',
        deposit = 'esx_society:depositMoney',
        wash = 'esx_society:washMoney'
    }

    local elements = {
        {unselectable = true, icon = "fas fa-wallet", title = labels[type], description = descriptions[type]},
        {icon = "fas fa-wallet", title = TranslateCap('amount_title'), input = true, inputType = "number", inputPlaceholder = TranslateCap(type.."_amount_placeholder"), inputMin = 1, inputMax = 250000, name = "amount"},
        {icon = "fas fa-check", title = TranslateCap('confirm'), value = "confirm"},
        {icon = "fas fa-arrow-left", title = TranslateCap('return'), value = "return"}
    }

    ESX.OpenContext("right", elements, function(menu, element)
        if element.value == "confirm" then
            local amount = tonumber(menu.eles[2].inputValue)
            if not amount then
                ESX.ShowNotification(TranslateCap('invalid_amount'))
            else
                TriggerServerEvent(confirmEvents[type], society, amount)
                ESX.CloseContext()
            end
        elseif element.value == "return" then
            OpenBossMenu(society)
        end
    end)
end

function OpenManageEmployeesMenu(society, options)
    local elements = {
        {unselectable = true, icon = "fas fa-users", title = TranslateCap('employee_management')},
        {icon = "fas fa-users", title = TranslateCap('employee_list'), value = "employee_list"},
        {icon = "fas fa-users", title = TranslateCap('recruit'), value = "recruit"},
        {icon = "fas fa-arrow-left", title = TranslateCap('return'), value = "return"}
    }

    ESX.OpenContext("right", elements, function(menu, element)
        if element.value == "employee_list" then
            OpenEmployeeList(society, options)
        elseif element.value == "recruit" then
            OpenRecruitMenu(society, options)
        elseif element.value == "return" then
            OpenBossMenu(society, nil, options)
        end
    end)
end

function OpenEmployeeList(society, options)
    ESX.TriggerServerCallback('esx_society:getEmployees', function(employees)
        local elements = {
            {unselectable = true, icon = "fas fa-user", title = TranslateCap('employees_title')}
        }

        for i=1, #employees, 1 do
            local gradeLabel1 = (employees[i].job.grade_label == '' and employees[i].job.label or employees[i].job.grade_label)
            local gradeLabel2 = (employees[i].job2.grade_label == '' and employees[i].job2.label or employees[i].job2.grade_label)

            elements[#elements+1] = {
                icon = "fas fa-user",
                title = employees[i].name .. " | " .. gradeLabel1 .. " | " .. gradeLabel2,
                gradeLabel1 = gradeLabel1,
                gradeLabel2 = gradeLabel2,
                data = employees[i]
            }
        end

        elements[#elements+1] = {icon = "fas fa-arrow-left", title = TranslateCap('return'), value = "return"}

        ESX.OpenContext("right", elements, function(menu, element)
            if element.value == "return" then
                OpenManageEmployeesMenu(society, options)
            else
                OpenEmployeeActionMenu(society, element.data, options)
            end
        end)
    end, society)
end

function OpenEmployeeActionMenu(society, employee, options)
    local elements = {
        {unselectable = true, icon = "fas fa-user", title = employee.name},
        {icon = "fas fa-user", title = TranslateCap('promote_job1'), value = "promote_job1"},
        {icon = "fas fa-user", title = TranslateCap('promote_job2'), value = "promote_job2"},
        {icon = "fas fa-user", title = TranslateCap('fire'), value = "fire"},
        {icon = "fas fa-arrow-left", title = TranslateCap('return'), value = "return"}
    }

    ESX.OpenContext("right", elements, function(menu, element)
        if element.value == "return" then
            OpenEmployeeList(society, options)
        elseif element.value == "promote_job1" then
            OpenPromoteMenu(society, employee, "job")
        elseif element.value == "promote_job2" then
            OpenPromoteMenu(society, employee, "job2")
        elseif element.value == "fire" then
            ESX.ShowNotification(TranslateCap('you_have_fired', employee.name))
            ESX.TriggerServerCallback('esx_society:setJob', function()
                OpenEmployeeList(society, options)
            end, employee.identifier, 'unemployed', 0, 'fire')
            ESX.TriggerServerCallback('esx_society:setJob2', function()
                OpenEmployeeList(society, options)
            end, employee.identifier, 'unemployed', 0, 'fire')
        end
    end)
end

function OpenRecruitMenu(society, options)
    ESX.TriggerServerCallback('esx_society:getOnlinePlayers', function(players)
        local elements = {
            {unselectable = true, icon = "fas fa-user", title = TranslateCap('recruiting')}
        }

        for i=1, #players do
            if players[i].job.name ~= society or players[i].job2.name ~= society then
                elements[#elements+1] = {
                    icon = "fas fa-user",
                    title = players[i].name,
                    value = players[i].source,
                    name = players[i].name,
                    identifier = players[i].identifier
                }
            end
        end

        elements[#elements+1] = {icon = "fas fa-arrow-left", title = TranslateCap('return'), value = "return"}

        ESX.OpenContext("right", elements, function(menu, element)
            if element.value == "return" then
                OpenManageEmployeesMenu(society, options)
            else
                local elements2 = {
                    {unselectable = true, icon = "fas fa-user", title = TranslateCap('confirm')},
                    {icon = "fas fa-times", title = TranslateCap('no'), value = "no"},
                    {icon = "fas fa-check", title = TranslateCap('yes'), value = "yes"}
                }
                ESX.OpenContext("right", elements2, function(menu2, element2)
                    if element2.value == "yes" then
                        ESX.ShowNotification(TranslateCap('you_have_hired', element.name))
                        ESX.TriggerServerCallback('esx_society:setJob', function()
                            OpenRecruitMenu(society, options)
                        end, element.identifier, society, 0, 'hire')
                        ESX.TriggerServerCallback('esx_society:setJob2', function()
                            OpenRecruitMenu(society, options)
                        end, element.identifier, society, 0, 'hire')
                    end
                end)
            end
        end)
    end)
end

function OpenPromoteMenu(society, employee, jobType)
    local callbackName = (jobType == "job") and "esx_society:getJob" or "esx_society:getJob2"

    ESX.TriggerServerCallback(callbackName, function(jobData)
        if not jobData then return end

        local elements = {
            {unselectable = true, icon = "fas fa-user", title = TranslateCap('promote_employee', employee.name)}
        }

        for i=1, #jobData.grades do
            local gradeLabel = (jobData.grades[i].label == '' and jobData.label or jobData.grades[i].label)
            local selected = (employee[jobType].grade == jobData.grades[i].grade)
            elements[#elements+1] = {icon = "fas fa-user", title = gradeLabel, value = jobData.grades[i].grade, selected = selected}
        end

        elements[#elements+1] = {icon = "fas fa-arrow-left", title = TranslateCap('return'), value = "return"}

        ESX.OpenContext("right", elements, function(menu, element)
            if element.value == "return" then
                OpenEmployeeList(society)
            else
                local cbSetJob = (jobType == "job") and 'esx_society:setJob' or 'esx_society:setJob2'
                ESX.ShowNotification(TranslateCap('you_have_promoted', employee.name, element.title))
                ESX.TriggerServerCallback(cbSetJob, function()
                    OpenEmployeeList(society)
                end, employee.identifier, society, element.value, 'promote')
            end
        end)
    end, society)
end

function OpenManageSalaryMenu(society, options)
    OpenManageJobMenu(society, "salary")
end

function OpenManageGradesMenu(society, options)
    OpenManageJobMenu(society, "grades")
end

function OpenManageJobMenu(society, menuType)
    local cbJob = (menuType == "salary") and 'esx_society:getJob' or 'esx_society:getJob2'
    ESX.TriggerServerCallback(cbJob, function(jobData)
        if not jobData then return end

        local elements = {{unselectable=true, icon="fas fa-wallet", title=(menuType == "salary" and TranslateCap('salary_management') or TranslateCap('grade_management'))}}

        for i=1, #jobData.grades do
            local gradeLabel = jobData.grades[i].label == '' and jobData.label or jobData.grades[i].label
            local display = (menuType == "salary") and ('%s - $%s'):format(gradeLabel, ESX.Math.GroupDigits(jobData.grades[i].salary)) or gradeLabel
            elements[#elements+1] = {icon="fas fa-wallet", title=display, value=jobData.grades[i].grade}
        end

        elements[#elements+1] = {icon="fas fa-arrow-left", title=TranslateCap('return'), value="return"}

        ESX.OpenContext("right", elements, function(menu, element)
            if element.value == "return" then
                OpenBossMenu(society)
            else
                local inputElements = {
                    {unselectable=true, icon="fas fa-wallet", title=element.title, value=element.value},
                    {icon="fas fa-wallet", title=(menuType=="salary" and TranslateCap('amount_title') or TranslateCap('change_label_title')), input=true, inputType=(menuType=="salary" and "number" or "text"), inputPlaceholder=(menuType=="salary" and TranslateCap('change_salary_placeholder') or TranslateCap('change_label_placeholder')), name=(menuType=="salary" and "gradesalary" or "gradelabel")},
                    {icon="fas fa-check", title=TranslateCap('confirm'), value="confirm"},
                    {icon="fas fa-arrow-left", title=TranslateCap('return'), value="return"}
                }

                ESX.RefreshContext(inputElements)
                if menu.eles[3].value == "confirm" then
                    local cbName = (menuType=="salary") and ((jobData.name and 'esx_society:setJobSalary') or 'esx_society:setJob2Salary') or ((jobData.name and 'esx_society:setJobLabel') or 'esx_society:setJob2Label')
                    local val = menu.eles[2].inputValue
                    ESX.TriggerServerCallback(cbName, function()
                        OpenManageJobMenu(society, menuType)
                    end, jobData.name, element.value, val)
                elseif menu.eles[3].value == "return" then
                    OpenBossMenu(society)
                end
            end
        end)
    end, society)
end


AddEventHandler('esx_society:openBossMenu', function(society, close, options)
    OpenBossMenu(society, close, options)
end)
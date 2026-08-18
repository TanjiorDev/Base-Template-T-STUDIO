local state = {}

local isActive = false
local showVignette = GetConvarInt('ox_target:vignette', 1) == 1
local ownsFocus = false

---@return boolean
function state.isActive()
    return isActive
end

---@param value boolean
function state.setActive(value)
    isActive = value

    if value then
        SendNuiMessage(json.encode({
            event = 'visible',
            state = true,
            vignette = showVignette
        }))
        SetNuiFocus(true, true)
        SetNuiFocusKeepInput(true)
        ownsFocus = true
    else
        if ownsFocus then
            SetNuiFocus(false, false)
            ownsFocus = false
        end
    end
end

local nuiFocus = false

---@return boolean
function state.isNuiFocused()
    return nuiFocus
end

---@param value boolean
function state.setNuiFocus(value, cursor)
    nuiFocus = value
    if value then
        SetNuiFocus(value, cursor or false)
        SetNuiFocusKeepInput(value)
        ownsFocus = true
    elseif ownsFocus then
        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)
        ownsFocus = false
    end
end

local isDisabled = false

---@return boolean
function state.isDisabled()
    return isDisabled
end

---@param value boolean
function state.setDisabled(value)
    isDisabled = value
end

return state

---@type table
local SettingsSeparator = {
    Rectangle = { Width = 400, Height = 45 },
    Text = { Y = 14, Scale = 0.35 },
}

---Affiche un séparateur centré et correctement aligné avec les autres items RageUI.
---@param Label string
function RageUI.Separator(Label)
    local CurrentMenu = RageUI.CurrentMenu
    if CurrentMenu ~= nil and CurrentMenu() then
        local Option = RageUI.Options + 1

        if CurrentMenu.Pagination.Minimum <= Option and CurrentMenu.Pagination.Maximum >= Option then
            if Label ~= nil then
                -- Même origine verticale que les boutons :
                -- CurrentMenu.Y + 20 + SubtitleHeight + ItemOffset.
                -- Le X utilise le vrai centre du menu afin d'éviter le décalage à gauche.
                local centerX = CurrentMenu.X + ((SettingsSeparator.Rectangle.Width + CurrentMenu.WidthOffset) / 2)
                local textY = 20 + CurrentMenu.Y + SettingsSeparator.Text.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset

                RenderText(
                    Label,
                    centerX,
                    textY,
                    fontIdSeparator or fontId,
                    SettingsSeparator.Text.Scale,
                    255, 255, 255, 255,
                    1
                )
            end

            RageUI.ItemOffset = RageUI.ItemOffset + SettingsSeparator.Rectangle.Height

            -- Un séparateur n'est pas sélectionnable : saute automatiquement l'item.
            if CurrentMenu.Index == Option then
                if RageUI.LastControl then
                    CurrentMenu.Index = Option - 1
                    if CurrentMenu.Index < 1 then
                        CurrentMenu.Index = RageUI.CurrentMenu.Options
                    end
                else
                    CurrentMenu.Index = Option + 1
                end
            end
        end

        RageUI.Options = RageUI.Options + 1
    end
end

---@type table
local SettingsTitle = {
    Text = { X = -13, Y = 4, Scale = 0.25 },
}

function RageUI.Title(Label)
    local CurrentMenu = RageUI.CurrentMenu
    if CurrentMenu ~= nil and CurrentMenu() then
        if Label ~= nil then
            RenderText(Label, x, y, 255, SettingsTitle.Text.Scale, 255, 255, 255, 255)
        end
    end
end

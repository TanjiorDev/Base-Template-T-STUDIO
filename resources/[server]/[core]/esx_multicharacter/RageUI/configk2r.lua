Configk2rUI = Configk2rUI or {}

local rageConfig = (Config and Config.RageUI) or {}
local menuConfig = rageConfig.Menu or {}
local colors = menuConfig.Colors or {}
local selected = colors.SelectedButton or { R = 190, G = 20, B = 20 }
local gradient = colors.BannerGradient or { R = 255, G = 0, B = 0 }

-- Pont entre la configuration esx_multicharacter et cette version de RageUI V2.
Configk2rUI.Menu = {
    TitreMenu = menuConfig.Title or 'MULTICHARACTER',
    CouleurBouton = {
        R = selected.R or 190,
        G = selected.G or 20,
        B = selected.B or 20
    },
    DegraderBanniere = {
        R = gradient.R or 255,
        G = gradient.G or 0,
        B = gradient.B or 0
    }
}

-- Applique les touches personnalisées à RageUI.
if RageUI and RageUI.Settings and RageUI.Settings.Controls then
    local configured = rageConfig.Controls or {}
    local controls = RageUI.Settings.Controls

    local function setControl(action, controlId)
        if controls[action] and type(controlId) == 'number' then
            controls[action].Keys = {
                { 0, controlId },
                { 1, controlId },
                { 2, controlId }
            }
        end
    end

    setControl('Up', configured.Up)
    setControl('Down', configured.Down)
    setControl('Left', configured.Left)
    setControl('Right', configured.Right)
    setControl('SliderLeft', configured.Left)
    setControl('SliderRight', configured.Right)
    setControl('Select', configured.Select)
    setControl('Back', configured.Back)
end

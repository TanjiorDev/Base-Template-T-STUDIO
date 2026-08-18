---@type table sd-phone config root (configs/config.lua) - config.ApiKeys holds the media token.
local config = require 'configs.config'

---@type table Uploader module; the table returned at end of file.
local uploader = {}

-- Response shape: { data = { id, url }, status = "ok" }.
---@type string Fivemanage media upload endpoint (v3 base64 route).
local UPLOAD_URL = 'https://api.fivemanage.com/api/v3/file/base64'

-- Media key: configs/server/apikeys.lua (FivemanageMedia), else the legacy convar below.
---@type string Legacy convar name still honoured when the config key is blank.
local CONVAR_KEY = 'sd_fivemanage_key'

---Returns the Fivemanage Media token: configs/server/apikeys.lua first, else the legacy
---convar; read fresh on every upload.
---@return string key the media token, or '' when unconfigured
local function mediaKey()
    local k = (config.ApiKeys or {}).FivemanageMedia
    if type(k) == 'string' and k ~= '' then return k end
    return GetConvar(CONVAR_KEY, '')
end

---Uploads a base64 data-URL to Fivemanage and hands back the hosted CDN URL. Asynchronous:
---calls `cb(url|nil, err)` exactly once.
---@param base64Image string media as a base64 data-URL (data:image/...;base64,...)
---@param filename string suggested filename stored alongside the upload
---@param cb fun(url: string|nil, err: string|nil)
function uploader.uploadMedia(base64Image, filename, cb)
    local key = mediaKey()

    if key == '' then
        print('^1[sd-phone:photos]^0 aborting — no Fivemanage key configured')
        cb(nil, 'No Fivemanage key configured. Set FivemanageMedia in configs/server/apikeys.lua.')
        return
    end

    if type(base64Image) ~= 'string' or base64Image == '' then
        print('^1[sd-phone:photos]^0 aborting — empty image payload')
        cb(nil, 'Empty image payload')
        return
    end


    local body = json.encode({
        base64   = base64Image,
        filename = filename or ('sdphone-%d.jpg'):format(os.time()),
    })


    PerformHttpRequest(UPLOAD_URL, function(status, responseBody, _headers)

        if status ~= 200 and status ~= 201 then
            cb(nil, ('Fivemanage upload failed: HTTP %s'):format(tostring(status)))
            return
        end

        if not responseBody or responseBody == '' then
            cb(nil, 'Empty response from Fivemanage')
            return
        end

        local okJson, decoded = pcall(json.decode, responseBody)
        if not okJson or type(decoded) ~= 'table' then
            cb(nil, 'Could not parse Fivemanage response')
            return
        end

        local url = type(decoded.data) == 'table' and decoded.data.url or nil
        if type(url) ~= 'string' or url == '' then
            cb(nil, 'Fivemanage returned no URL')
            return
        end

        cb(url, nil)
    end, 'POST', body, {
        ['Content-Type']  = 'application/json',
        ['Authorization'] = key,
    })
end

return uploader

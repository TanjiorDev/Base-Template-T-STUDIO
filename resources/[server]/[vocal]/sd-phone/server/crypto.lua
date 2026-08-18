---@type table Crypto module; the table returned at end of file.
local crypto = {}

---@type string This resource's name, used to reach the Node helper's exports.
local RESOURCE = GetCurrentResourceName()

---@type boolean|nil Cached result of the helper probe; nil until first use.
local ready

---Calls one of the Node helper's exports, swallowing a missing runtime.
---@param name string export name
---@param ... any arguments
---@return boolean okCall, any result
local function call(name, ...)
    return pcall(function(...) return exports[RESOURCE][name](exports[RESOURCE], ...) end, ...)
end

---True when the Node crypto helper answered. Probed once, then cached; a miss is announced so a
---server on a runtime without it is not silently left on the legacy hash.
---@return boolean available
function crypto.available()
    if ready == nil then
        local okCall, res = call('sdCryptoReady')
        ready = okCall and res == true
        if not ready then
            print('^1[sd-phone:crypto]^0 Node crypto helper did not load. Passwords stay on the legacy hash and saved Passwords stay unencrypted.')
        end
    end
    return ready
end

---Hashes a password with scrypt. Nil when the helper is unavailable.
---@param plain string plaintext password
---@return string|nil hash
function crypto.hashPassword(plain)
    if not crypto.available() then return nil end
    local okCall, res = call('sdCryptoHashPassword', plain)
    return (okCall and type(res) == 'string') and res or nil
end

---Checks a plaintext password against a scrypt hash.
---@param plain string plaintext password
---@param stored string stored scrypt hash
---@return boolean verified
function crypto.verifyPassword(plain, stored)
    if not crypto.available() then return false end
    local okCall, res = call('sdCryptoVerifyPassword', plain, stored)
    return okCall and res == true
end

---Encrypts a vault secret. Nil when the helper is unavailable.
---@param plain string
---@return string|nil blob
function crypto.encrypt(plain)
    if not crypto.available() then return nil end
    local okCall, res = call('sdCryptoEncrypt', plain)
    return (okCall and type(res) == 'string') and res or nil
end

---Decrypts a vault secret. Nil when the helper is unavailable or the blob is not ours.
---@param blob string
---@return string|nil plain
function crypto.decrypt(blob)
    if not crypto.available() then return nil end
    local okCall, res = call('sdCryptoDecrypt', blob)
    return (okCall and type(res) == 'string') and res or nil
end

return crypto

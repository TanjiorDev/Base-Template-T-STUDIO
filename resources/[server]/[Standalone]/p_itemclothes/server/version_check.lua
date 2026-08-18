local versionCheckUrl = "https://gist.githubusercontent.com/PiotreeQ/fda64b55595f2e7404e57363bd97892a/raw/b3f1c5ef3685c0fb403acf26bdced1a49b8cef8b/gistfile1.txt"
local currentVersion = GetResourceMetadata(GetCurrentResourceName(), "version", 0)

function parseVersion(versionString)
    if not versionString then
        return nil
    end
    versionString = versionString:gsub("^v", "")
    local major, minor, patch = versionString:match("(%d+)%.(%d+)%.(%d+)")
    if not major then
        return nil
    end
    return {
        major = tonumber(major),
        minor = tonumber(minor),
        patch = tonumber(patch),
        original = versionString,
    }
end

function isRemoteVersionNewer(currentParsed, remoteParsed)
    if not currentParsed or not remoteParsed then
        return false
    end
    if remoteParsed.major > currentParsed.major then
        return true
    end
    if remoteParsed.major < currentParsed.major then
        return false
    end
    if remoteParsed.minor > currentParsed.minor then
        return true
    end
    if remoteParsed.minor < currentParsed.minor then
        return false
    end
    return remoteParsed.patch > currentParsed.patch
end

function checkForUpdates()
    print("^3[Version Check]^7 Checking for updates...")
    print("^3[Version Check]^7 Current version: ^5" .. (currentVersion or "Unknown") .. "^7")
    PerformHttpRequest(versionCheckUrl, function(statusCode, responseBody)
        if statusCode ~= 200 then
            if statusCode == 404 then
                print("^1[Version Check]^7 Error: Version file not found (404)")
                print("^1[Version Check]^7 Check your Gist URL!")
            else
                print("^1[Version Check]^7 Error: HTTP " .. statusCode)
            end
            return
        end
        local decodeSuccess, versionData = pcall(json.decode, responseBody)
        if not decodeSuccess or not versionData or not versionData.version then
            print("^1[Version Check]^7 Error: Invalid JSON response")
            return
        end
        local currentParsed = parseVersion(currentVersion)
        local remoteParsed = parseVersion(versionData.version)
        if not currentParsed then
            print("^1[Version Check]^7 Error: Could not parse current version")
            return
        end
        if not remoteParsed then
            print("^1[Version Check]^7 Error: Could not parse remote version")
            return
        end
        if isRemoteVersionNewer(currentParsed, remoteParsed) then
            print("^2[Version Check]^7 ========================================")
            print("^2[Version Check]^7 UPDATE AVAILABLE!")
            print("^2[Version Check]^7 Current Version: ^5v" .. currentParsed.original .. "^7")
            print("^2[Version Check]^7 Latest Version:  ^2v" .. remoteParsed.original .. "^7")
            print("^2[Version Check]^7 ========================================")
            if versionData.changelog then
                print("^2[Version Check]^7 Changelog:")
                for _, changelogEntry in ipairs(versionData.changelog) do
                    print("^2[Version Check]^7   - " .. changelogEntry)
                end
                print("^2[Version Check]^7 ========================================")
            end
            if versionData.download_url then
                print("^2[Version Check]^7 Download: ^3" .. versionData.download_url .. "^7")
            end
            if versionData.notes then
                print("^2[Version Check]^7 " .. versionData.notes)
            end
            print("^2[Version Check]^7 ========================================")
        else
            print("^2[Version Check]^7 You are running the latest version!")
        end
    end, "GET", "", {})
end

Citizen.CreateThread(function()
    Citizen.Wait(5000)
    checkForUpdates()
end)

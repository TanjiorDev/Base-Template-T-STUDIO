function sendLogs(webhook, title, message)
    if type(webhook) ~= 'string' or webhook == '' then return end
    local embed = {{
        color = 16448250,
        title = title,
        description = message,
        footer = { text = 'Ato Logs' }
    }}
    PerformHttpRequest(webhook, function() end, 'POST', json.encode({ username = 'Society Logs', embeds = embed }), { ['Content-Type'] = 'application/json' })
end

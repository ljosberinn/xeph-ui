--- @type table<string, true>
local triggers = {}

for _, text in pairs(aura_env.config.triggerList) do
    if text.phrase ~= nil then
        triggers["%f[%a]" .. text.phrase:lower() .. "%f[^%a]"] = true
    end
end

--- @param message string
--- @return boolean
aura_env.isTriggerPhrase = function(message)
    local msg = message:lower()

    for pattern in pairs(triggers) do
        if msg:match(pattern) then
            return true
        end
    end

    return false
end
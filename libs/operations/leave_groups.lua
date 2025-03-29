-- libraries
local http  = require('http')
local stdio = require('stdio')


-- shortcuts
local insert = table.insert


-- module
return {
    name = 'leave groupchats',
    call = function() 
        local res = http:get('users/@me/channels')

        if not res.success then
            stdio:error('couldn\'t get your groupchats.')

            return stdio:pause()
        end

        local gcs = {}

        for _, v in ipairs(res.data) do
            if v.type == 3 then
                insert(gcs, v)
            end
        end

        local input  = stdio:prompt('add any exceptions (ex: id, id, id)')
        local except = string.split(input, ', ')

        for _, v in ipairs(gcs) do
            if not table.includes(except, v.id) then
                local res   = http:delete('channels/' .. v.id)
                local chan  = stdio:color('dim', 'underline', '"' .. v.name .. '"')

                if res.success then
                    stdio:success(('left groupchat: %s'):format(chan))
                else
                    stdio:success(('couldn\'t leave groupchat: %s'):format(chan))
                end
            end
        end
        
        stdio:pause()
    end
}
-- libraries
local http  = require('../http')
local stdio = require('../stdio')


-- shortcuts
local insert = table.insert


-- module
return {
    name = 'close dms',
    call = function() 
        local res = http:get('users/@me/channels')

        if not res.success then
            stdio:error('couldn\'t get your dms.')

            return stdio:pause()
        end

        local dms = {}

        for _, v in ipairs(res.data) do
            if v.type == 1 then
                insert(dms, v)
            end
        end

        local input  = stdio:prompt('add any exceptions (ex: id, id, id)')
        local except = string.split(input, ', ')

        for _, v in ipairs(dms) do
            if not table.includes(except, v.id) then
                local res   = http:delete('channels/' .. v.id)
                local recip = v.recipients[1]
                local user  = stdio:color('dim', 'underline', '@' .. recip.username)

                if res.success then
                    stdio:success(('closed dm with %s'):format(user))
                else
                    stdio:success(('couldn\'t close dm with %s'):format(user))
                end
            end
        end
        
        stdio:pause()
    end
}
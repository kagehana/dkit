-- libraries
local http  = require('../http')
local stdio = require('../stdio')
local store = require('../store')


-- module
return {
    name = 'check current login',
    call = function()
        local res = http:get('users/@me')
        
        if res.success then
            print(('%s %s'):format(
                stdio:color('dim', 'underline', '@' .. res.data.username),
                res.data.email or 'no email'
            ))
        end

        stdio:pause()
    end
}
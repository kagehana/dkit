-- libraries
local http  = require('http')
local stdio = require('stdio')
local store = require('store')


-- module
return {
    name = 'change saved token',
    call = function()
        while true do
            local token = stdio:prompt('enter your token (\'exit\' to stop)')
            
            if token:lower() == 'exit' then
                stdio:info('token change cancelled')

                stdio:pause()
            else
                http:setauth(token)

                local res = http:get('users/@me')
                
                if res.success then
                    store:set('token', token)

                    stdio:success(('token saved! logged in as %s'):format(
                        stdio:color('dim', 'underline', '@' .. res.data.username)
                    ))

                    return stdio:pause()
                else
                    stdio:error('invalid token - please try again!')
                end
            end
        end
    end
}
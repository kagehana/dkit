-- libraries
local http    = require('../http')
local stdio   = require('../stdio')


-- shorcuts
local openf  = io.open
local insert = table.insert
local concat = table.concat


-- module
return {
    name = 'backup account',
    call = function()
        stdio:info('backing up account...')
        
        local files = {
            friends = {},
            blocks  = {},
            servers = {}
        }

        local res = http:get('users/@me/relationships')

        if res.success then
            for _, v in ipairs(res.data) do
                coroutine.wrap(function()
                    insert(
                        v.type == 1 and files.friends or files.blocks,
                        '@' .. v.user.username
                    )
                end)()
            end
        end

        local res = http:get('users/@me/guilds')

        if res.success then
            for _, v in ipairs(res.data) do
                local res    = http:get('guilds/' .. v.id)
                local vanity = nil

                if res.success then
                    vanity = res.data.vanity_url_code
                end
            
                local res  = http:get('guilds/' .. v.id .. '/channels')
                local chan = nil
            
                if res.success then
                    for _, v in ipairs(res.data) do
                        if v.type == 0 then
                            chan = v.id

                            break
                        end
                    end
                end

                local invite = '[couldn\'t make an invite]'

                if vanity then
                    invite = 'https://discord.gg/' .. vanity
                else
                    if chan then
                        local res = http:post('channels/' .. chan .. '/invites', {
                            max_age   = 0,
                            max_uses  = 0,
                            temporary = false
                        })

                        local data = res.data
      
                        if vanity then
                            invite = 'https://discord.gg/' .. vanity
                        elseif res.success and res.data and data.code and data.code ~= 50013 then
                            invite = 'https://discord.gg/' .. data.code
                        end
                    end
                end

                insert(files.servers, ('%s\n%s\n'):format(v.name, invite))
            end
        end
        

        for k, v in pairs(files) do
            openf(k .. '.txt', 'w'):write(concat(v, '\n')):close()

            stdio:success(('backed up %s %s'):format(stdio:color('dim', 'underline', tostring(#v)), k))
        end

        stdio:pause()
    end
}

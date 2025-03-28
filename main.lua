-- libraries
local stdio = require('./stdio')
local store = require('./store')
local ops   = require('./operations')
local http  = require('./http')


-- shortcuts
local insert = table.insert
local concat = table.concat


-- extensions
function string.split(str, sep)
    local res = {}
    local pat = ('([^%s]+)'):format(sep or ' ')

    for match in str:gmatch(pat) do
        insert(res, match)
    end

    return res
end

function table.includes(tbl, i)
    for k, v in ipairs(tbl) do
        if v == i then
            return true
        end
    end
end


-- setup
stdio:clear()
stdio:title('://dkit')
stdio:banner()

ops:load()

store:load()
http:settoken(store:get('token'))


-- silly C boundaries
coroutine.wrap(function()
    -- authenticate their token
    while true do
        if not store:isempty() and http:checktoken() then
            break
        else
            store:set('token', nil)
        end
        
        stdio:error('token is invalid!')

        local token = stdio:prompt('enter a new token')

        http:settoken(token)

        local res = http:get('users/@me')

        if res.success then
            store:set('token', token)
            store:save()

            stdio:success('token saved! logged in as ' .. stdio:color('dim', 'underline', '@' .. res.data.username))

            break
        end
end


-- main functionality
    while true do
        stdio:clear()
        stdio:banner()
        
        local list = {}
        local maxd = #tostring(#ops.mods)
        
        for k, v in ipairs(ops.mods) do
            insert(list, ('%' .. maxd .. 'd  ┃  %s'):format(k, v.name))
        end

        print(stdio:color('dim', concat(list, '\n')) .. '\n')
        
        local pick = stdio:prompt('pick an operation')
        local choice = tonumber(pick)
        local op = ops:get(choice)

        if op then
            op.call()
        end
    end
end)()
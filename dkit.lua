local write  = io.write
local openf  = io.open
local exec   = os.execute
local concat = table.concat
local insert = table.insert

exec('cls')
exec('title ://dkit')

local json  = require('json')
local http  = require('coro-http')
local fs    = require('fs')
local timer = require('timer')

local decode  = json.decode
local encode  = json.encode
local request = http.request
local sleep   = timer.sleep




local colors = {
    reset         = '\27[0m',
    bold          = '\27[1m',
    dim           = '\27[2m',
    italic        = '\27[3m',
    underline     = '\27[4m',
    blink         = '\27[5m',
    inverse       = '\27[7m',
    hidden        = '\27[8m',
    strikethrough = '\27[9m',

    black   = '\27[30m',
    red     = '\27[31m',
    green   = '\27[32m',
    yellow  = '\27[33m',
    blue    = '\27[34m',
    magenta = '\27[35m',
    cyan    = '\27[36m',
    white   = '\27[37m',

    brightblack   = '\27[90m',
    brightred     = '\27[91m',
    brightgreen   = '\27[92m',
    brightyellow  = '\27[93m',
    brightblue    = '\27[94m',
    brightmagenta = '\27[95m',
    brightcyan    = '\27[96m',
    brightwhite   = '\27[97m',

    bgblack   = '\27[40m',
    bgred     = '\27[41m',
    bggreen   = '\27[42m',
    bgyellow  = '\27[43m',
    bgblue    = '\27[44m',
    bgmagenta = '\27[45m',
    bgcyan    = '\27[46m',
    bgwhite   = '\27[47m',

    bgbrightblack   = '\27[100m',
    bgbrightred     = '\27[101m',
    bgbrightgreen   = '\27[102m',
    bgbrightyellow  = '\27[103m',
    bgbrightblue    = '\27[104m',
    bgbrightmagenta = '\27[105m',
    bgbrightcyan    = '\27[106m',
    bgbrightwhite   = '\27[107m',
}

local function color(...)
    local args  = {...}
    local str   = table.remove(args, #args)
    local codes = ''

    for _, name in ipairs(args) do
        if colors[name] then
            codes = codes .. colors[name]
        end
    end

    return codes .. str .. colors.reset
end

local function trademark()
    print(color('cyan', [[
     █████ █████       ███   █████   
    ░░███ ░░███       ░░░   ░░███    
  ███████  ░███ █████ ████  ███████  
 ███░░███  ░███░░███ ░░███ ░░░███░   
░███ ░███  ░██████░   ░███   ░███    
░███ ░███  ░███░░███  ░███   ░███ ███
░░████████ ████ █████ █████  ░░█████ 
 ░░░░░░░░ ░░░░ ░░░░░ ░░░░░    ░░░░░ v1.0.0, https://github.com/kagehana/dkit
    ]]))
end

local function ask(str)
    io.write(('%s    %s: '):format(color('cyan', '://dkit'), str))

    return io.read()
end

local function relay(str, mode)
    local c = 'cyan'

    if mode == 1 then
        c = 'green'
    elseif mode == 2 then
        c = 'red'
    end

    print(color(c, '://dkit    ') .. str)
end

local function allowreturn()
    write('\npress any key to return ...')

    local _ = io.read()
end





local store = {}

local function storeisempty()
    return not store['token']
end

local function configure()
    local file = openf('store.env', 'r')

    if file and storeisempty() then
        for line in file:lines() do
            local k, v = line:match('^%s*([^=]+)%s*=%s*(.*)%s*$')

            if k and v then
                store[k] = v
            end
        end

        file:close()
    end

    if store['token'] then
        local file = openf('store.env', 'w')

        print(1)
        
        if file then
            local env = ''

            for k, v in pairs(store) do
                env = env .. ('%s=%s\n'):format(k, v)
            end

            print(env)

            file:write(env)
            file:close()
        end
    else
        openf('store.env', 'w'):close()
    end
end




local function split(str, sep)
    local res = {}
    local pat = ('([^%s]+)'):format(sep or ' ')

    for match in str:gmatch(pat) do
        insert(res, match)
    end

    return res
end

local function includes(tbl, i)
    for k, v in ipairs(tbl) do
        if v == i then
            return true
        end
    end
end






trademark()
configure()

if storeisempty() then
    store['token'] = ask('enter your token')

    configure()
    relay('token saved! edit it by modifying [store.env].')
end




-- discord api
local base = 'https://discord.com/api/v9'
local me   = base .. '/users/@me'
local head = {
    {'Authorization', store['token']},
    {'Content-Type', 'application/json'}
}

local function getme()
    local res, body = request('GET', me, head)

    if res.code ~= 200 then
        return nil, res.code
    end

    return decode(body)
end

local function getchannels()
    local res, body = request('GET',  (me .. '/channels'), head)

    if res.code ~= 200 then
        return nil, res.code
    end

    return decode(body)
end

local function getservers()
    local res, body = request('GET', (me .. '/guilds'), head)

    if res.code ~= 200 then
        return nil, res.code
    end

    return decode(body)
end






local ops = {{
    'purge messages',
    call = function()

    end
}, {
    'mass-unfriend',
    call = function()

    end
}, {
    'leave groupchats',
    call = function()
        local chans  = getchannels()
        local groups = {}

        for k, v in ipairs(chans) do
            if v.type == 3 then
                insert(groups, v.id)
            end
        end

        local items  = ask('add any exceptions (example: id, id, id)')
        local except = split(items, ', ')

        for k, v in ipairs(groups) do
            if not includes(except, v) then
                local res, _ = request('DELETE', ('%s/channels/%s'):format(base, v), head)

                if res.code == 200 then
                    relay('left groupchat: ' .. v, 1)
                elseif res.code == 404 and res.reason ~= 'Not Found' then
                    relay('failed to leave groupchat: ' .. v, 2)
                end
            end
        end

        allowreturn()
    end
}, {
    'close dms',
    call = function()
        local chans = getchannels()
        local dms   = {}

        for k, v in ipairs(chans) do
            if v.type == 1 then
                insert(dms, v)
            end
        end

        local items  = ask('add any exceptions (example: id, id, id)')
        local except = split(items, ', ')

        for k, v in ipairs(dms) do
            if not includes(except, v) then
                local res, _ = request('DELETE', ('%s/channels/%s'):format(base, v.id), head)
                local msg    = '%s: ' .. color('dim', ('@%s (%s)'):format(v.recipients[1].username, v.id))

                if res.code == 200 then
                    relay(msg:format('closed dm'), 1)
                elseif res.code == 404 and res.reason ~= 'Not Found' then
                    relay(msg:format('failed to close dm'), 2)
                end
            end
        end

        allowreturn()
    end
}, {
    'leave servers',
    call = function()
        local servers = getservers()
        local items  = ask('add any exceptions (example: id, id, id)')
        local except = split(items, ', ')

        for k, v in ipairs(servers) do
            if not includes(except, v) then
                local res, _ = request(
                    'DELETE', ('%s/guilds/%s'):format(me, v.id),
                    head, encode({['lurking'] = false})
                )

                local msg    = '%s: ' .. color('dim', ('%s (%s)'):format(v.name, v.id))

                if res.code == 200 or res.code == 204 then
                    relay(msg:format('left server'), 1)
                elseif res.code ~= 200 and res.reason ~= 'Not Found' then
                    relay(msg:format('failed to leave server'), 2)
                end

                sleep(1)
            end
        end

        allowreturn()
    end
}, {
    'check current login',
    call = function()
        local their = getme()

        print(color('dim', color('underline', '@' .. their.username) .. ' ' .. their.email))
        allowreturn()
    end
}, {
    'change token',
    call = function()
        store['token'] = ask('enter your token')

        configure()
        relay('token saved! edit it by modifying [store.env].')
        allowreturn()
    end
}, {
    'exit dkit',
    call = function()
        exec('cls')

        os.exit()
    end
}}

local function getop()
    local list = {}

    for k, v in ipairs(ops) do
        insert(list, ('%d  ┃  %s'):format(k, v[1]))
    end

    print(color('dim', concat(list, '\n')) .. '\n')

    local pick = ask('pick something to do')
    local op   = ops[tonumber(pick)]

    if op then
        op.call()
    end
end

while true do
    exec('cls')
    trademark()
    getop()
end

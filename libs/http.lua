-- module
local http = {}


-- libraries
local coro = require('coro-http')
local json = require('json')


-- defaults
local base    = 'https://discord.com/api/v10/'
local headers = {
    { 'Content-Type',  'application/json' },
    { 'Authorization', '' }
}


-- authorization
function http:setauth(token)
    headers[2][2] = token
end

function http:checktoken()
    return (http:get('users/@me')).success
end


-- core
function http:request(method, endp, body)
    local ok, res, data = pcall(coro.request,
        method, endp:find('^https?://') and endp or base .. endp,
        headers, body and json.encode(body)
    )

    if not ok then
        return {success = false, error = res}
    end

    return {
        success = res.code >= 200 and res.code < 300,
        status  = res.code,
        data    = data and json.decode(data),
        raw     = data,
        headers = res.headers,
    }
end


-- shortcuts
function http:get(e)
    return self:request('GET', e, nil)
end

function http:post(e, b)
    return self:request('POST', e, b)
end

function http:put(e, b)
    return self:request('PUT', e, b)
end

function http:patch(e, b)
    return self:request('PATCH', e, b)
end

function http:delete(e)
    return self:request('DELETE', e, nil)
end


-- module
return http
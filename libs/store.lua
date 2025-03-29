local store = {user = {}}

local fs = require('fs')

local readf  = fs.readFileSync
local writef = fs.writeFileSync

function store:isempty()
    return not self.user.token
end

function store:load()
    local ok, data = pcall(readf, 'store.env')
    
    if not ok then
        return error(data)
    end
    
    for line in data:gmatch('[^\n]+') do
        local k, v = line:match('^%s*([^=]+)%s*=%s*(.*)%s*$')

        if k and v then
            self.user[k] = v
        end
    end
end

function store:save()
    local env = {}

    for k, v in pairs(self.user) do
        env[#env + 1] = ('%s=%s'):format(k, v)
    end

    local ok, data = pcall(writef, 'store.env', table.concat(env, '\n'))

    if not ok then
        return error(data)
    end

    return true
end

function store:get(k)
    return self.user[k]
end

function store:set(k, v)
    self.user[k] = v
    self:save()
end

function store:remove(k)
    self.user[k] = nil
    self:save()
end

function store:clear()
    self.user = {}
    self:save()
end

return store
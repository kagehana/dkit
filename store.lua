-- module
local store = {user = {}}


-- shortcuts
local openf  = io.open
local concat = table.concat


-- if empty
function store:isempty()
    return not self.user.token
end


-- load from file
function store:load()
    local file = openf('store.env', 'r')

    if not file then
        return
    end

    for line in file:lines() do
        local k, v = line:match('^%s*([^=]+)%s*=%s*(.*)%s*$')

        if k and v then
            self.user[k] = v
        end
    end

    file:close()
end


-- save locally
function store:save()
    local file = openf('store.env', 'w')

    if not file then
        return false
    end

    local env = {}

    for k, v in pairs(self.user) do
        
        env[#env + 1] = ('%s=%s'):format(k, v)
    end

    file:write(concat(env, '\n'))
    file:close()
    
    return true
end


-- helpers
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


-- module
return store
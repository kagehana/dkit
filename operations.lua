-- module
local ops = {mods = {}}


-- libraries
local fs = require('fs')


-- shortcuts
local insert = table.insert


-- load operations
function ops:load()
    for _, file in ipairs(fs.readdirSync('./operations')) do
        if file:find('.lua') then
            local name   = file:gsub('.lua', '')
            local ok, op = pcall(require, './operations/' .. name)
            
            if ok then
                insert(ops.mods, {
                    name = op.name or name:gsub('_', ' '),
                    call = op.call or function() end
                })
            end
        end
    end
end


-- get operation
function ops:get(id)
    if not id then
        return
    end
    
    if type(id) == 'number' then
        return self.mods[id]
    end
    
    for _, op in ipairs(self.mods) do
        if op.name:lower() == id:lower() then
            return op
        end
    end
end

-- module
return ops
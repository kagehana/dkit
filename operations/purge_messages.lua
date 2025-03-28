-- libraries
local http  = require('../http')
local stdio = require('../stdio')


-- module
return {
    name = 'purge messages',
    call = function()        
        stdio:info('in progress, sorry')
        stdio:pause()
    end
}
-- module
local stdio = {}


-- shortcuts
local write = io.write
local read  = io.read
local exec  = os.execute


-- colors
stdio.colors = {
    -- styles
    reset     = '\27[0m',
    bold      = '\27[1m',
    dim       = '\27[2m',
    italic    = '\27[3m',
    underline = '\27[4m',
    blink     = '\27[5m',
    inverse   = '\27[7m',
    hidden    = '\27[8m',
    strike    = '\27[9m',

    -- classic colors
    black     = '\27[30m',
    red       = '\27[31m',
    green     = '\27[32m',
    yellow    = '\27[33m',
    blue      = '\27[34m',
    magenta   = '\27[35m',
    cyan      = '\27[36m',
    white     = '\27[37m',
    gray      = '\27[90m',
    bred      = '\27[91m',
    bgreen    = '\27[92m',
    byellow   = '\27[93m',
    bblue     = '\27[94m',
    bmagenta  = '\27[95m',
    bcyan     = '\27[96m',
    bwhite    = '\27[97m',

    -- Backgrounds
    bgblack   = '\27[40m',
    bgred     = '\27[41m',
    bggreen   = '\27[42m',
    bgyellow  = '\27[43m',
    bgblue    = '\27[44m',
    bgmagenta = '\27[45m',
    bgcyan    = '\27[46m',
    bgwhite   = '\27[47m',

    -- rgb/true color (modern terminals only)
    rgb       = function(r, g, b)
        return '\27[38;2;' .. r .. ';' .. g .. ';' .. b .. 'm'
    end,

    bgrgb     = function(r, g, b)
        return '\27[48;2;' .. r .. ';' .. g .. ';' .. b .. 'm'
    end,

    -- some modern samples
    orange    = '\27[38;2;255;165;0m',
    pink      = '\27[38;2;255;105;180m',
    purple    = '\27[38;2;147;112;219m',
    lime      = '\27[38;2;50;205;50m',
    teal      = '\27[38;2;0;128;128m',
    gold      = '\27[38;2;255;215;0m',
    silver    = '\27[38;2;192;192;192m'
}


-- colorizer
function stdio:color(...)
    local args = { ... }
    local text = table.remove(args)
    local styles = ''

    for _, style in ipairs(args) do
        if self.colors[style] then
            styles = styles .. self.colors[style]
            -- for rgb
        elseif type(style) == 'table' and #style == 3 then
            styles = styles .. self.colors.rgb(style[1], style[2], style[3])
        end
    end

    return styles .. text .. self.colors.reset
end

-- trademark
function stdio:banner()
    print(self:color('teal', [[
     █████ █████       ███   █████
    ░░███ ░░███       ░░░   ░░███
  ███████  ░███ █████ ████  ███████
 ███░░███  ░███░░███ ░░███ ░░░███░
░███ ░███  ░██████░   ░███   ░███
░███ ░███  ░███░░███  ░███   ░███ ███
░░████████ ████ █████ █████  ░░█████
 ░░░░░░░░ ░░░░ ░░░░░ ░░░░░    ░░░░░ v1.0.0
    ]]))
end

-- user input
function stdio:prompt(str)
    write(('%s    %s: '):format(self:color('teal', '://dkit'), str))

    return read()
end

-- standard
function stdio:info(str)
    print(self:color('teal', '://dkit    ') .. str)
end

function stdio:error(str)
    print(self:color('bred', '://dkit    ') .. str)
end

function stdio:success(str)
    print(self:color('lime', '://dkit    ') .. str)
end

function stdio:title(str)
    exec('title ' .. str)
end

function stdio:clear()
    exec('cls')
end

-- backtracking
function stdio:pause()
    write('\npress any key to return ...')
    read()
end

-- module
return stdio

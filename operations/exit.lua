-- module
return {
    name = 'exit dkit',
    call = function()
        os.execute('cls')
        os.exit()
    end
}
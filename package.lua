return {
    name = "dkit",
    version = "0.0.1",
    description = "",
    tags = { "lua", "lit", "luvit" },
    license = "MIT",
    author = { name = "kagehana", email = "" },
    homepage = "https://github.com/kagehana/dkit",
    dependencies = {
        'luvit/require',
        'luvit/fs',
        'luvit/json',
        'luvit/secure-socket',
        'creationix/coro-http',
    },
    files = {
      "**.lua",
      "!test*"
    }
  }
  
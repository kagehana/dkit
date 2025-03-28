  return {
    name = "dkit",
    version = "1.0.0",
    description = "A Discord toolkit.",
    tags = { "lua", "lit", "luvit" },
    license = "MIT",
    author = { name = "kagehana", email = "" },
    homepage = "",
    dependencies = {
      'luvit/require',
      'luvit/json',
      'luvit/timer',
      'luvit/coro-http',
      'luvit/fs',
      'luvit/secure-socket',
    },
    files = {
      "**.lua",
      "!test*"
    }
  }
  
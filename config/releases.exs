import Config

secret_key_base = System.fetch_env!("SECRET_KEY_BASE")

config :darktan, DarktanWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base,
  server: true

config :darktan, Darktan.Store,
  backend: System.get_env("STORAGE_BACKEND", "false") == "true"

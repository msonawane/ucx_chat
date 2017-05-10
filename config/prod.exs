use Mix.Config

# For production, we configure the host to read the PORT
# from the system environment. Therefore, you will need
# to set PORT=80 before running your server.
#
# You should also configure the url host to something
# meaningful, we use this information when generating URLs.
#
# Finally, we also include the path to a manifest
# containing the digested version of static files. This
# manifest is generated by the mix phoenix.digest task
# which you typically run after static files are built.
config :ucx_chat, UcxChat.Endpoint,
  # http: [port: {:system, "PORT"}],
  http: [port: 4020],
  url: [host: "localhost", port: 4020],
  check_origin: false,
  cache_static_manifest: "priv/static/manifest.json"

# Do not print debug messages in production
config :logger,
  level: :info,
  backends: [Logger.Backends.Syslog, :console],
  syslog: [
    appid: "chat", host: '127.0.0.1', facility: :local4,
    level: :info,
    format: "[$level] $metadata $message\n",
    metadata: [:module, :line, :function]
  ]

config :phoenix_distillery, PhoenixDistillery.Endpoint,
  http: [port: 4020],
  # http: [port: {:system, "PORT"}],
  # url: [host: "localhost", port: {:system, "PORT"}], # This is critical for ensuring web-sockets properly authorize.
  url: [host: "localhost", port: 4020], # This is critical for ensuring web-sockets properly authorize.
  cache_static_manifest: "priv/static/manifest.json",
  server: true,
  root: ".",
  version: Mix.Project.config[:version]

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :ucx_chat, UcxChat.Endpoint,
#       ...
#       url: [host: "example.com", port: 443],
#       https: [port: 443,
#               keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#               certfile: System.get_env("SOME_APP_SSL_CERT_PATH")]
#
# Where those two env variables return an absolute path to
# the key and cert in disk or a relative path inside priv,
# for example "priv/ssl/server.key".
#
# We also recommend setting `force_ssl`, ensuring no data is
# ever sent via http, always redirecting to https:
#
#     config :ucx_chat, UcxChat.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.

# ## Using releases
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start the server for all endpoints:
#
config :phoenix, :serve_endpoints, true
#
# Alternatively, you can configure exactly which server to
# start per endpoint:
#
#     config :ucx_chat, UcxChat.Endpoint, server: true
#

# Finally import the config/prod.secret.exs
# which should be versioned separately.
config :ucx_chat, UcxChat.Endpoint,
  secret_key_base: "PFt4auqEANHdSUu5aMfZEEIZQvqTC9T2R2QjUzuCuOb0erW/wgFrVAw8M4eNIJ5e"

# Configure your database
config :ucx_chat, UcxChat.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: System.get_env("DB_USER") || "${DB_USER}",
  password: System.get_env("DB_PASS") || "${DB_PASS}",
  database: "ucx_chat_prod",
  pool_size: 20

# import_config "prod.secret.exs"

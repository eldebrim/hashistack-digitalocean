# Increase log verbosity
log_level = "DEBUG"

# Setup data dir
data_dir = "/tmp/client"

# Give the agent a unique name. Defaults to hostname
name = "client"

# Enable the client
client {
    enabled = true
}

ports {
    http = 5657
}

consul {
  address             = "127.0.0.1:8500"
  server_service_name = "nomad"
  client_service_name = "nomad-client"
  auto_advertise      = true
  server_auto_join    = true
  client_auto_join    = true
}

vault {
  enabled = true
  address = "http://server_ip:8200"
}

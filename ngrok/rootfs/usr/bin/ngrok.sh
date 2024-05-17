#!/usr/bin/with-contenv bashio
set -e

bashio::log.debug "Building ngrok.yml..."
configPath="/ngrok-config/ngrok.yml"
mkdir -p /ngrok-config

# Start writing ngrok configuration
cat <<EOF > $configPath
version: 2
log: /var/log/ngrok.log
log_level: debug
web_addr: 0.0.0.0:4040
authtoken: $(bashio::config 'auth_token')
tunnels:
EOF

# Iterate through tunnels configuration
for id in $(bashio::config "tunnels|keys"); do
  name=$(bashio::config "tunnels[${id}].name")
  proto=$(bashio::config "tunnels[${id}].proto")
  addr=$(bashio::config "tunnels[${id}].addr")

  cat <<EOF >> $configPath
  $name:
    proto: $proto
    addr: $addr
EOF

  # Optional fields
  inspect=$(bashio::config "tunnels[${id}].inspect")
  if [[ $inspect != "null" ]]; then
    echo "    inspect: $inspect" >> $configPath
  fi
  domain=$(bashio::config "tunnels[${id}].domain")
  if [[ $domain != "null" ]]; then
    echo "    domain: $domain" >> $configPath
  fi
  basic_auth=$(bashio::config "tunnels[${id}].basic_auth")
  if [[ $basic_auth != "null" ]]; then
    echo "    basic_auth: [$basic_auth]" >> $configPath
  fi
  host_header=$(bashio::config "tunnels[${id}].host_header")
  if [[ $host_header != "null" ]]; then
    echo "    host_header: $host_header" >> $configPath
  fi
  bind_tls=$(bashio::config "tunnels[${id}].bind_tls")
  if [[ $bind_tls != "null" ]]; then
    echo "    bind_tls: $bind_tls" >> $configPath
  fi
  subdomain=$(bashio::config "tunnels[${id}].subdomain")
  if [[ $subdomain != "null" ]]; then
    echo "    subdomain: $subdomain" >> $configPath
  fi
  hostname=$(bashio::config "tunnels[${id}].hostname")
  if [[ $hostname != "null" ]]; then
    echo "    hostname: $hostname" >> $configPath
  fi
  crt=$(bashio::config "tunnels[${id}].crt")
  if [[ $crt != "null" ]]; then
    echo "    crt: $crt" >> $configPath
  fi
  key=$(bashio::config "tunnels[${id}].key")
  if [[ $key != "null" ]]; then
    echo "    key: $key" >> $configPath
  fi
  client_cas=$(bashio::config "tunnels[${id}].client_cas")
  if [[ $client_cas != "null" ]]; then
    echo "    client_cas: $client_cas" >> $configPath
  fi
  remote_addr=$(bashio::config "tunnels[${id}].remote_addr")
  if [[ $remote_addr != "null" ]]; then
    echo "    remote_addr: $remote_addr" >> $configPath
  fi
  metadata=$(bashio::config "tunnels[${id}].metadata")
  if [[ $metadata != "null" ]]; then
    echo "    metadata: $metadata" >> $configPath
  fi
done

configfile=$(cat $configPath)
bashio::log.debug "Config file: \n${configfile}"
bashio::log.info "Starting ngrok..."
ngrok start --config $configPath --all

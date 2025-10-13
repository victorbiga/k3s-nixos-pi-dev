{ pkgs, role, ... }:

{
  services.k3s = {
    role = role;

    # Hardcoded server address for agents
    serverAddr = if role == "agent" then "https://10.0.0.32:6443" else "";

    # Only add token for agents, let master node bootstrap itself
    tokenFile = if role == "agent" then "/etc/k3s/token" else null;

    # Include additional flags conditionally based on the role
    extraFlags = if role == "server" then [ "--disable=traefik" ] else [];

    clusterInit = if role == "server" then true else false;
  };
}

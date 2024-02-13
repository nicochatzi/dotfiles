{ ... }:

{
  networking.firewall = {
    enable = true;
    allowPing = true;
    logRefusedConnections = true;

    defaultIncomingPolicy = "drop";
    defaultOutgoingPolicy = "accept";

    allowedTCPPorts = [
      22 # SSH
      # 80 # HTTP
      # 443 # HTTPS
      # 3389 # RDP
      # 5900 # VNC
    ];
    allowedUDPPorts = [ ];

    # Reject packets that appear to come from
    # the outside but claim to be from a local IP
    rejectPacketsWithLocalSource = true;

    # Additional rules can be defined here
    # Example: Allow a specific IP
    # extraCommands = "iptables -A INPUT -s 192.168.1.100 -j ACCEPT";
  };
}


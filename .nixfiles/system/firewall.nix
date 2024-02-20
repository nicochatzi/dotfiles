{...}: {
  networking.firewall = {
    enable = true;
    allowPing = true;
    logRefusedConnections = true;

    allowedTCPPorts = [
      22 # SSH
      # 80 # HTTP
      # 443 # HTTPS
      # 3389 # RDP
      # 5900 # VNC
    ];
    allowedUDPPorts = [];
  };
}

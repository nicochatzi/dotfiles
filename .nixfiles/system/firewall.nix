{ ... }: {
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
    allowedUDPPorts = [ ];
  };

  # System-wide security settings
  boot.kernel.sysctl = {
    # Disable IP forwarding
    "net.ipv4.ip_forward" = 0;
    "net.ipv6.conf.all.forwarding" = 0;

    # Disable source packet routing
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv6.conf.all.accept_source_route" = 0;

    # Enable TCP SYN cookies (mitigate SYN flood attack)
    "net.ipv4.tcp_syncookies" = 1;

    # Enable IP spoofing protection
    "net.ipv4.conf.all.rp_filter" = 1;

    # Disable ICMP redirects (prevent MITM attacks)
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;

    # Ignore ICMP requests (prevent ping discovery)
    "net.ipv4.icmp_echo_ignore_all" = 1;

    # Enable logging of spoofed packets, source routed packets, and redirect packets
    "net.ipv4.conf.all.log_martians" = 1;
  };
}

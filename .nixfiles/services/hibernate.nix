{pkgs, ...}: let
  hibernateEnvironment = {
    HIBERNATE_SECONDS = "3600";
    HIBERNATE_LOCK = "/var/run/autohibernate.lock";
  };
  resumeEnvironment = {
    XAUTHORITY = "/home/nico/.Xauthority";
    DISPLAY = ":0";
    XDG_SEAT_PATH = "/org/freedesktop/DisplayManager/Seat0";
  };
in {
  systemd.services."lock-on-resume" = {
    description = "Lock screen after resuming from sleep/hibernate";
    before = ["sleep.target" "hibernate.target" "hybrid-sleep.target"];
    wantedBy = ["sleep.target" "hibernate.target" "hybrid-sleep.target"];
    environment = resumeEnvironment;
    serviceConfig.Type = "oneshot";
    script = "/run/current-system/sw/bin/dm-tool switch-to-greeter";
  };

  systemd.services."awake-after-suspend-for-a-time" = {
    description = "Sets up the suspend so that it'll wake for hibernation";
    wantedBy = ["suspend.target"];
    before = ["systemd-suspend.service"];
    environment = hibernateEnvironment;
    serviceConfig.Type = "simple";
    script = ''
      curtime=$(date +%s)
      echo "$curtime $1" >> /tmp/autohibernate.log
      echo "$curtime" > $HIBERNATE_LOCK
      ${pkgs.utillinux}/bin/rtcwake -m no -s $HIBERNATE_SECONDS
    '';
  };

  systemd.services."hibernate-after-recovery" = {
    description = "Hibernates after a suspend recovery due to timeout";
    wantedBy = ["suspend.target"];
    after = ["systemd-suspend.service"];
    environment = hibernateEnvironment;
    serviceConfig.Type = "simple";
    script = ''
      curtime=$(date +%s)
      sustime=$(cat $HIBERNATE_LOCK)
      rm $HIBERNATE_LOCK
      if [ $(($curtime - $sustime)) -ge $HIBERNATE_SECONDS ] ; then
        systemctl hibernate
      else
        ${pkgs.utillinux}/bin/rtcwake -m no -s 1
      fi
    '';
  };
}

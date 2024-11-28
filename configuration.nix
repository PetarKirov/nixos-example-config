{...}: {
  system.stateVersion = "24.11";

  users = {
    users.petar = {
      isNormalUser = true;
      initialPassword = "1234";
      group = "petar";
      extraGroups = ["wheel" "users"];
    };

    groups.petar = {};
  };

  services.sshd.enable = true;
}

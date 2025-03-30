let
  joshuabaker = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPhWVW7ixMAKKsO9V/JLyt1FGkNtkAlLa1ttLpk6BmIL root@joshuabaker";
in
{
  "keepass-basic.age".publicKeys = [ joshuabaker ];
  "keepass-digest.age".publicKeys = [ joshuabaker ];
}

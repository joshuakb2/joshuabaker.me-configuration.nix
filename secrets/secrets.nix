let
  joshuabaker = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPhWVW7ixMAKKsO9V/JLyt1FGkNtkAlLa1ttLpk6BmIL root@joshuabaker";
  Joshua-PC = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGYEtwhOUhooRNQ2KX/tQOyjQ+H3xRQcl87B2gGk3yp2";
  keys = [ joshuabaker Joshua-PC ];
in
{
  "keepass-basic.age".publicKeys = keys;
  "keepass-digest.age".publicKeys = keys;
  "joshbooks-env.age".publicKeys = keys;
  "mailserver-joshua.age".publicKeys = keys;
  "mailserver-moe.age".publicKeys = keys;
}

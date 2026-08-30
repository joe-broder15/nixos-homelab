# Shared base domain for the homelab reverse proxy (proxy.nix) and dashboard
# (homer.nix), injected as a module argument so both stay in sync.
{ ... }:
{
  _module.args.baseDomain = "local.clubtropicalexcellent.vip";
}

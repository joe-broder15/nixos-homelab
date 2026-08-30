{
  config,
  lib,
  baseDomain,
  ...
}:

let
  mkProxy = proxyPass: {
    forceSSL = true;
    useACMEHost = baseDomain;
    locations."/" = {
      inherit proxyPass;
      proxyWebsockets = true;
    };
  };

  localProxy = port: mkProxy "http://127.0.0.1:${toString port}";

  # Simple vhosts: just proxy to a local port, no extra nginx config needed.
  simplePorts = {
    plex = 32400;
    sillytavern = 8083;
    resilio = 9999;
    ddns = 8081;
  };
in
{
  services.nginx.enable = true;
  services.nginx.recommendedProxySettings = true;

  security.acme = {
    acceptTerms = true;
    defaults.email = "joe.broder@proton.me";

    # One cert object for the base zone, requesting a wildcard
    certs."${baseDomain}" = {
      domain = "*.${baseDomain}";
      extraDomainNames = [ baseDomain ]; # also cover apex
      dnsProvider = "namecheap"; # lego provider code
      environmentFile = "/etc/nixos/namecheap.env";

      # Make the resulting cert readable by nginx
      group = config.services.nginx.group;
    };
  };

  services.nginx.virtualHosts =
    lib.mapAttrs' (name: port: lib.nameValuePair "${name}.${baseDomain}" (localProxy port)) simplePorts
    // {
      "homer.${baseDomain}" = {
        useACMEHost = baseDomain;
        forceSSL = true;
      };

      "qbittorrent.${baseDomain}" = lib.recursiveUpdate (localProxy 8082) {
        locations."/".extraConfig = ''
          # If you see timeouts on large responses:
          proxy_read_timeout 300s;
          proxy_send_timeout 300s;
        '';
      };

      "openwebui.${baseDomain}" = lib.recursiveUpdate (localProxy 8080) {
        locations."/".extraConfig = ''
          # Streaming responses (SSE) must not be buffered or they arrive garbled/delayed.
          proxy_buffering off;
          proxy_cache off;

          # LLM completions can run long; keep the connection open.
          proxy_read_timeout 1800s;
          proxy_send_timeout 1800s;
          proxy_connect_timeout 1800s;
        '';
      };

      "proxmox.${baseDomain}" = lib.recursiveUpdate (mkProxy "https://192.168.1.100:8006") {
        locations."/".extraConfig = ''
          # Proxmox upstream commonly uses a self-signed TLS certificate.
          proxy_ssl_verify off;
        '';
      };
    };
}

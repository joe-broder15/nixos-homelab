{ config, ... }:

let
  baseDomain = "local.clubtropicalexcellent.vip";
in
{
  services.nginx.enable = true;

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

  services.nginx.virtualHosts."plex.${baseDomain}" = {
    forceSSL = true;
    useACMEHost = baseDomain;
    locations."/" = {
      proxyPass = "http://127.0.0.1:32400";
      proxyWebsockets = true;
    };
  };

  services.nginx.virtualHosts."qbittorrent.${baseDomain}" = {
    forceSSL = true;
    useACMEHost = baseDomain;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8082";
      proxyWebsockets = true;
      extraConfig = ''
        # qBittorrent WebUI is sensitive to headers; these help:
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Real-IP $remote_addr;

        # If you see timeouts on large responses:
        proxy_read_timeout 300s;
        proxy_send_timeout 300s;
      '';
    };
  };

  services.nginx.virtualHosts."homer.${baseDomain}" = {
    useACMEHost = baseDomain;
    forceSSL = true;
  };

  services.nginx.virtualHosts."sillytavern.${baseDomain}" = {
    forceSSL = true;
    useACMEHost = baseDomain;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8083";
      proxyWebsockets = true;
    };
  };

  services.nginx.virtualHosts."resilio.${baseDomain}" = {
    forceSSL = true;
    useACMEHost = baseDomain;
    locations."/" = {
      proxyPass = "http://127.0.0.1:9999";
      proxyWebsockets = true;
    };
  };

  services.nginx.virtualHosts."ddns.${baseDomain}" = {
    forceSSL = true;
    useACMEHost = baseDomain;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8081";
      proxyWebsockets = true;
    };
  };

  services.nginx.virtualHosts."openwebui.${baseDomain}" = {
    forceSSL = true;
    useACMEHost = baseDomain;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8080";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Real-IP $remote_addr;

        # Streaming responses (SSE) must not be buffered or they arrive garbled/delayed.
        proxy_buffering off;
        proxy_cache off;

        # LLM completions can run long; keep the connection open.
        proxy_read_timeout 1800s;
        proxy_send_timeout 1800s;
        proxy_connect_timeout 1800s;
      '';
    };
  };

  services.nginx.virtualHosts."proxmox.${baseDomain}" = {
    forceSSL = true;
    useACMEHost = baseDomain;
    locations."/" = {
      proxyPass = "https://192.168.1.100:8006";
      proxyWebsockets = true;
      extraConfig = ''
        # Proxmox upstream commonly uses a self-signed TLS certificate.
        proxy_ssl_verify off;
      '';
    };
  };
}

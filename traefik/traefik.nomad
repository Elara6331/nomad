job "traefik" {
  region      = "global"
  datacenters = ["dc1"]
  type        = "service"

  group "traefik" {
    count = 1

    network {
      port "http" {
        static = 80
      }
      
      port "https" {
        static = 443
      }

      port "api" {
        static = 8081
      }
    }

    service {
      name = "traefik"
      port = "api"

      check {
        name     = "alive"
        type     = "tcp"
        port     = "http"
        interval = "10s"
        timeout  = "2s"
      }

      tags = [
      	"traefik.enable=true",

      	// Redirect all http requests to HTTPS
      	"traefik.http.middlewares.https-redirect.redirectscheme.permanent=true",
      	"traefik.http.middlewares.https-redirect.redirectscheme.scheme=https",
      	"traefik.http.routers.http-catchall.entrypoints=http",
      	"traefik.http.routers.http-catchall.rule=HostRegexp(`{any:.+}`)",
      	"traefik.http.routers.http-catchall.middlewares=https-redirect",

      	// Forward requests to protected services to Authelia. Remove this if not running Authelia.
      	"traefik.http.middlewares.authelia.forwardauth.address=http://<authelia address>/api/verify?rd=https://auth.elara.ws/",
      	"traefik.http.middlewares.authelia.forwardauth.trustforwardheader=true",
      	"traefik.http.middlewares.authelia.forwardauth.authresponseheaders=Remote-User, Remote-Groups",

      	// Expose Traefik API with authentication. Remove this if not running Authelia.
      	"traefik.http.routers.traefik.rule=Host(`traefik.elara.ws`)",
      	"traefik.http.routers.traefik.tls.certResolver=letsencrypt",
      	"traefik.http.routers.traefik.middlewares=authelia",
      ]
    }

    task "traefik" {
      driver = "docker"

      config {
        image        = "traefik:v2.2"
        network_mode = "host"

        volumes = [
          "/opt/traefik/acme.json:/acme.json",
          "local/traefik.toml:/etc/traefik/traefik.toml",
        ]
      }

      template {
        data = <<EOF
[entryPoints]
    [entryPoints.http]
    address = ":80"
    [entryPoints.https]
    address = ":443"
    [entryPoints.traefik]
    address = ":8081"
        
[certificatesResolvers.letsencrypt.acme]
  email = "you@example.com"
  storage = "acme.json"
  [certificatesResolvers.letsencrypt.acme.httpChallenge]
    entryPoint = "http"

[api]
    dashboard = true
    insecure  = true

# Enable Consul Catalog configuration backend.
[providers.consulCatalog]
    prefix           = "traefik"
    exposedByDefault = false

    [providers.consulCatalog.endpoint]
      address = "127.0.0.1:8500"
      scheme  = "http"
EOF

        destination = "local/traefik.toml"
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}

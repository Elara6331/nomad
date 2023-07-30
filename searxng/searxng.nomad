job "searxng" {
  region      = "global"
  datacenters = ["dc1"]
  type        = "service"

  group "searxng" {
    count = 1

    network {
      port "searx" {}
    }

    task "searxng" {
      driver = "docker"

      env {
        BIND_ADDRESS     = "0.0.0.0:${NOMAD_PORT_searx}"
        SEARXNG_BASE_URL = "https://search.elara.ws"
        SEARXNG_SECRET   = "CHANGE ME"
      }

      config {
        image = "searxng/searxng:latest"

        ports = ["searx"]

        cap_drop = ["all"]
        cap_add = [
          "chown",
          "setgid",
          "setuid",
          "dac_override"
        ]
      }

      service {
        name = "searxng"
        port = "searx"

        tags = [
          "traefik.enable=true",
          "traefik.http.routers.searxng.rule=Host(`search.elara.ws`)",
          "traefik.http.routers.searxng.tls.certResolver=letsencrypt",
          "traefik.http.routers.searxng.middlewares=searxng-headers",
          "traefik.http.middlewares.searxng-headers.headers.customrequestheaders.X-Robots-Tag=noindex, noarchive, nofollow"
        ]
      }
    }
  }
}

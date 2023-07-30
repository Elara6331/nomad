job "authelia" {
  region      = "global"
  datacenters = ["dc1"]
  type        = "service"

  group "authelia" {
    count = 1

    volume "authelia-config" {
      type      = "host"
      source    = "authelia-config"
      read_only = false
    }

    network {
      port "authelia" {
        to = 9091
        static = 9091
      }
    }

    task "authelia" {
      driver = "docker"

      volume_mount {
        volume      = "authelia-config"
        destination = "/config"
        read_only   = false
      }

      env {
        TZ                           = "CHANGE ME"
        AUTHELIA_JWT_SECRET_FILE     = "/config/secrets/jwt"
        AUTHELIA_SESSION_SECRET_FILE = "/config/secrets/session"
      }

      config {
        image = "authelia/authelia:latest"
        ports = ["authelia"]
      }

      service {
        name = "authelia"
        port = "authelia"

        tags = [
          "traefik.enable=true",
          "traefik.http.routers.authelia.rule=Host(`auth.elara.ws`)",
          "traefik.http.routers.authelia.tls.certResolver=letsencrypt",
        ]
      }
    }
  }
}

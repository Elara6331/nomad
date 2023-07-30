job "woodpecker" {
  region = "global"
  datacenters = ["dc1"]
  type = "service"

  group "woodpecker" {
    count = 1

    network {
      port "agent" {
        to = 9000
        static = 9000	
      }
      
      port "http" {
        to = 8000
      }
    }

    volume "woodpecker" {
      type      = "host"
      source    = "woodpecker"
      read_only = false
    }

    restart {
      attempts = 5
      delay    = "30s"
    }

    task "woodpecker" {
      driver = "docker"
      volume_mount {
        volume      = "woodpecker"
        destination = "/var/lib/woodpecker"
        read_only   = false
      }

      config {
        image = "woodpeckerci/woodpecker-server:latest"
        ports = ["agent", "http"]
      }

      env {
        WOODPECKER_OPEN = "true"
        WOODPECKER_HOST = "https://ci.elara.ws"
        WOODPECKER_GITEA = "true"
        WOODPECKER_GITEA_URL = "https://gitea.elara.ws"
        WOODPECKER_GITEA_CLIENT = "CHANGE ME"
        WOODPECKER_GITEA_SECRET = "CHANGE ME"
        WOODPECKER_AGENT_SECRET = "CHANGE ME"
      }

      service {
        name = "woodpecker-ci"
        port = "http"

        tags = [
          "traefik.enable=true",
          "traefik.http.routers.woodpecker-ci.rule=Host(`ci.elara.ws`)",
          "traefik.http.routers.woodpecker-ci.tls.certResolver=letsencrypt"
        ]
      }
    }
  }
}

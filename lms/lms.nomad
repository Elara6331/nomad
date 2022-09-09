job "lms" {
  region      = "global"
  datacenters = ["dc1"]
  type        = "service"

  group "lms" {
    count = 1

    volume "lms-media" {
      type      = "host"
      source    = "lms-media"
      read_only = true
    }

    volume "lms-data" {
      type      = "host"
      source    = "lms-data"
      read_only = false
    }

    network {
      port "lms" {
        to = 5082
      }
    }

    task "lms" {
      driver = "docker"

      volume_mount {
        volume      = "lms-media"
        destination = "/media"
        read_only   = true
      }

      volume_mount {
        volume      = "lms-data"
        destination = "/var/lms"
        read_only   = false
      }

      config {
        image = "epoupon/lms:latest"
        ports = ["lms"]
      }

      service {
        name = "lms"
        port = "lms"

        tags = [
          "traefik.enable=true",
          "traefik.http.routers.lms.rule=Host(`music.arsenm.dev`)",
          "traefik.http.routers.lms.tls.certResolver=letsencrypt",
        ]
      }
    }
  }
}

job "lure-web" {
  region      = "global"
  datacenters = ["dc1"]
  type        = "service"

  group "lure-web" {
    network {
      port "api" {
        to = 8080
      }

      port "http" {
        to = 3000
      }
    }

    task "lure-api-server" {
      driver = "docker"

      env {
        LURE_API_GITHUB_SECRET = "CHANGE ME"
      }

      config {
        image = "arsen6331/lure-api-server:latest"
        ports = ["api"]
      }

      service {
        name = "lure-api-server"
        port = "api"
        tags = [
          "traefik.enable=true",
          "traefik.http.routers.lure-api-server.rule=Host(`api.lure.arsenm.dev`)",
          "traefik.http.routers.lure-api-server.tls.certresolver=letsencrypt"
        ]

        check {
          type     = "tcp"
          port     = "api"
          interval = "30s"
          timeout  = "2s"
        }
      }
    }

    task "lure-web" {
      driver = "docker"
      
      config {
        image = "arsen6331/lure-web:latest"
        ports = ["http"]
      }


      service {
        name = "lure-web"
        port = "http"
        tags = [
          "traefik.enable=true",
          "traefik.http.routers.lure-web.rule=Host(`lure.arsenm.dev`)",
          "traefik.http.routers.lure-web.tls.certresolver=letsencrypt",
        ]
      }
    }
  }
}

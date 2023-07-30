job "nextcloud" {
  region      = "global"
  datacenters = ["dc1"]
  type        = "service"

  group "nextcloud" {

    network {
      port "http" {
        to = 80
      }

      port "onlyoffice-http" {
        to = 8000
      }
    }

    volume "nextcloud-html" {
      type      = "host"
      source    = "nextcloud-html"
      read_only = false
    }

    volume "onlyoffice-data" {
      type      = "host"
      source    = "onlyoffice-data"
      read_only = false
    }

    task "nextcloud" {
      driver = "docker"

      env {
        NEXTCLOUD_ADMIN_USER      = "CHANGE ME"
        NEXTCLOUD_ADMIN_PASSWORD  = "CHANGE ME"
        NEXTCLOUD_TRUSTED_DOMAINS = "nextcloud.elara.ws"
      }

      volume_mount {
        volume      = "nextcloud-html"
        destination = "/var/www/html"
        read_only   = false
      }

      config {
        image = "nextcloud"
        ports = ["http"]
      }

      service {
        name = "nextcloud"
        port = "http"
        tags = [
          "traefik.enable=true",
          "traefik.http.routers.nextcloud.rule=Host(`nextcloud.elara.ws`)",
          "traefik.http.routers.nextcloud.tls.certresolver=letsencrypt"
        ]

        check {
          type     = "tcp"
          port     = "http"
          interval = "30s"
          timeout  = "2s"
        }
      }

      resources {
        cpu    = 500
        memory = 512
      }
    }

    task "nextcloud-cron" {
      lifecycle {
        hook = "poststart"
      }

      volume_mount {
        volume      = "nextcloud-html"
        destination = "/var/www/html"
        read_only   = false
      }

      driver = "docker"
      config {
        image   = "nextcloud:apache"
        command = "/cron.sh"
      }
    }

    task "onlyoffice" {
      driver = "docker"

      env {
      	JWT_ENABLED = false
      }

      volume_mount {
        volume      = "onlyoffice-data"
        destination = "/var/www/onlyoffice/Data"
        read_only   = false
      }

      config {
        image = "onlyoffice/documentserver:latest"
        ports = ["onlyoffice-http"]
      }


      service {
        name = "onlyoffice"
        port = "onlyoffice-http"
        tags = [
          "traefik.enable=true",
          "traefik.http.routers.onlyoffice.rule=Host(`onlyoffice.elara.ws`)",
          "traefik.http.routers.onlyoffice.tls.certresolver=letsencrypt",
          "traefik.http.routers.onlyoffice.middlewares=onlyoffice-headers",
          "traefik.http.middlewares.onlyoffice-headers.headers.customrequestheaders.X-Forwarded-Proto=https"
        ]
      }

      resources {
        cpu    = 500
        memory = 1536
      }
    }
  }
}

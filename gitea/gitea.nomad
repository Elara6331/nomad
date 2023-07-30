job "gitea" {
  region = "global"
  datacenters = [
    "dc1",
  ]
  type = "service"

  group "gitea" {
    count = 1

    network {
      port "http" {
        to = 3000
      }

      port "ssh" {
        static = 2222
        to     = 22
      }
    }

    volume "gitea-data" {
      type      = "host"
      source    = "gitea-data"
      read_only = false
    }

    restart {
      attempts = 5
      delay    = "30s"
    }

    task "app" {
      driver = "docker"
      volume_mount {
        volume      = "gitea-data"
        destination = "/data"
        read_only   = false
      }

      config {
        image = "gitea/gitea:latest"
        ports = ["ssh", "http"]
      }

      env {
        APP_NAME                        = "Gitea: Git with a cup of tea"
        RUN_MODE                        = "prod"
        SSH_DOMAIN                      = "CHANGE ME"
        SSH_PORT                        = "$NOMAD_PORT_ssh"
        ROOT_URL                        = "https://gitea.elara.ws/"
        USER_UID                        = "1002"
        USER_GID                        = "1002"
        GITEA__server__START_SSH_SERVER = "true"
      }

      resources {
        cpu    = 200
        memory = 512
      }

      service {
        name = "gitea"
        port = "http"

        tags = [
          "traefik.enable=true",
          "traefik.http.routers.gitea.rule=Host(`gitea.elara.ws`)",
          "traefik.http.routers.gitea.tls.certResolver=letsencrypt"
        ]
      }
    }
  }
}

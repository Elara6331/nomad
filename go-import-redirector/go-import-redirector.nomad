job "go-import-redirector" {
  region      = "global"
  datacenters = ["dc1"]
  type        = "service"

  group "go-import-redirector" {
    count = 2

    network {
      port "http" {}
    }

    task "go-import-redirector" {
      driver = "exec"

      config {
        command = "local/exec.sh"
        args = [
          "-addr", ":${NOMAD_PORT_http}",
          "go.elara.ws/*",
          "https://gitea.elara.ws/Elara6331/*"
        ]
      }

      artifact {
        source = "https://api.minio.elara.ws/adl/go-import-redirector.tar.gz"
      }

      resources {
        cpu    = 100
        memory = 20
      }

      service {
        name = "go-import-redirector"
        port = "http"

        tags = [
          "traefik.enable=true",
          "traefik.http.routers.go-import-redirector.rule=Host(`go.elara.ws`)",
          "traefik.http.routers.go-import-redirector.tls.certResolver=letsencrypt"
        ]
      }
    }
  }
}

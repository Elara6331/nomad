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
          "go.arsenm.dev/*",
          "https://gitea.arsenm.dev/Arsen6331/*"
        ]
      }

      artifact {
        source = "https://api.minio.arsenm.dev/adl/go-import-redirector.tar.gz"
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
          "traefik.http.routers.go-import-redirector.rule=Host(`go.arsenm.dev`)",
          "traefik.http.routers.go-import-redirector.tls.certResolver=letsencrypt"
        ]
      }
    }
  }
}

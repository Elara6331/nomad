job "minio" {
  datacenters = ["dc1"]

  group "minio" {
    
    network {
      port "minio" {}
      port "minio-api" {}
    }
    
    volume "minio-data" {
      type = "host"
      source = "minio-data"
      read_only = false
    }

    task "minio" {
      driver = "docker"
      
      volume_mount {
        volume = "minio-data"
        destination = "/data"
        read_only = false
      }

      config {
        image = "minio/minio"
        
        ports = ["minio", "minio-api"]

        args = [
          "server",
          "/data",
          "--address", "0.0.0.0:${NOMAD_PORT_minio_api}",
          "--console-address", "0.0.0.0:${NOMAD_PORT_minio}"
        ]
      }

      env {
        MINIO_ROOT_USER = "CHANGE ME"
        MINIO_ROOT_PASSWORD = "CHANGE ME"
      }

      service {
        name = "minio"
        tags = [
          "traefik.enable=true",
          "traefik.http.routers.minio.rule=Host(`minio.arsenm.dev`)",
          "traefik.http.routers.minio.tls.certResolver=letsencrypt"
        ]

        port = "minio"

        check {
          type     = "http"
          path     = "/minio/login"
          port     = "minio"
          interval = "10s"
          timeout  = "2s"
        }
      }

      service {
        name = "minio-api"
        port = "minio-api"

        tags = [
          "traefik.enable=true",
          "traefik.http.routers.minio-api.rule=Host(`api.minio.arsenm.dev`)",
          "traefik.http.routers.minio-api.tls.certResolver=letsencrypt"
        ]
      }
    }
  }
}

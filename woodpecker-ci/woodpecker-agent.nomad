job "woodpecker-agent" {
  region = "global"
  datacenters = ["dc1"]
  type = "system"

  group "woodpecker-agent" {
    restart {
      attempts = 5
      delay    = "30s"
    }

    task "woodpecker-agent" {
      driver = "docker"

      config {
        image = "woodpeckerci/woodpecker-agent:latest"
        volumes = [
        	"/var/run/docker.sock:/var/run/docker.sock",
        ]
      }

      env {
        WOODPECKER_SERVER = "192.168.100.121:9000"
        WOODPECKER_AGENT_SECRET = "CHANGE ME"
      }

      constraint {
      	attribute = "${meta.woodpecker_agent}"
      	value = "true"
      }
    }
  }
}

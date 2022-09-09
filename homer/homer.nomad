job "homer" {
	region = "global"
	datacenters = ["dc1"]
	type = "service"

	group "homer" {
		count = 1

		network {
			port "homer" {}
		}

		task "homer" {
			driver = "docker"

			env {
				PORT = "${NOMAD_PORT_homer}"
			}

			config {
				image = "b4bz/homer:latest"
				ports = ["homer"]

				volumes = [
					"local/config.yml:/www/assets/config.yml"
				]
			}

			template {
				data = "{{ key `homer/config.yml` }}"
				destination = "local/config.yml"
			}

			service {
				name = "homer"
				port = "homer"

				tags = [
					"traefik.enable=true",
					"traefik.http.routers.homer.rule=Host(`dashboard.arsenm.dev`)",
					"traefik.http.routers.homer.tls.certResolver=letsencrypt",
				]
			}
		}
	}
}

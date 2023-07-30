# LURE Web

This nomad file is for one of my other projects, [LURE](https://gitea.elara.ws/Elara6331/lure). Specifically, it runs [LURE's Web interface](https://lure.elara.ws) and its backend API server.

This job requires no volumes. The only thing that needs to be changed is the Github API secret. This is for a Github webhook, so that the API server knows when the LURE repo changes so it can update its database.

The default `arsen6331/lure-web` docker image is hardcoded to use my domain for its API, so you'll need to create youe own image. The LURE Web repo contains a `docker` directory with a `Dockerfile` and `docker.sh` script that you can use to build the docker images.
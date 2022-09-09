# Go Import Redirector

This is the nomad job file I use for rsc's [go-import-redirector](https://github.com/rsc/go-import-redirector), which redirects the Go programming language tool to the proper github repo. For example, if someone tries to install one of my projects, rather than having to type out `go install gitea.arsenm.dev/Arsen6331/itd@latest`, they can just use `go install go.arsenm.dev/itd@latest` and this service will redirect them.

This job file downloads an archive containing `go-import-redirector` executables for `x86_64` and `aarch64`, as well as a script that runs the correct one, from my minio instance.

I am running two instances of this, automatically load-balanced by Traefik. Since the configuration is done entirely in command-line arguments, this workload is completely stateless, and can therefore be moved around freely by Nomad.
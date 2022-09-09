# Minio

This is a nomad file for [Minio](https://min.io/), which is an object storage service with an Amazon S3-compatible API. This nomad file exposes both the console and the API of minio. If you would like to not expose the API, remove the `service` stanza with the name `minio-api`.

In the `env` stanza, there is a username and password set to "CHANGE ME". Set these to the username/password you want to login with.
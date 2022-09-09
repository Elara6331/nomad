# Gitea

This is the nomad file for [Gitea](https://github.com/go-gitea/gitea), a git web interface.

This job requires one volume for Gitea's data. This volume should be called `gitea-data` and should be read/write, not readonly. Set the owner of the directory bound to the volume as `1002`. The command that would be used for this is `sudo chown 1002:1002 <volume directory>`.

In the `env` stanza, there is an SSH domain. Set that to the local IP of your server so that you can use it to upload to git via SSH.
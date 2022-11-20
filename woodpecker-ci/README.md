# Woodpecker CI

These nomad job files run the Woodpecker Continuous Integration engine as well as its agents.

These files contain URLs and server IPs that will need to be changed, as well as various secrets that are set to "CHANGE ME". The `WOODPECKER_AGENT_SECRET` should be a random string, but must be the same in both Woodpecker and its agents. The `WOODPECKER_GITEA_CLIENT` and `WOODPECKER_GITEA_SECRET` are the values you get from Gitea when you add a new OAuth2 app in its web interface.

Woodpecker requires one volume to store its database. This volume should be called `woodpecker` and it should be read/write, not readonly.

Once Woodpecker starts, you should be able to go to it, and log in via your Gitea account.

The woodpecker agent file will start the agent on all nodes with the `woodpecker_agent` custom metadata value set to `true`. You can look at the following documentation for an example of how to set metadata: https://developer.hashicorp.com/nomad/docs/configuration/client#custom-metadata-network-speed-and-node-class
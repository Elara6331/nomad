# Homer

This is the nomad job file I use for the [Homer](https://github.com/bastienwirtz/homer/) dashboard. It takes its config file from the Consul Key/Value store. This means that whenever the config is edited, Nomad automatically installs the new file and restarts the container. It also means that Homer is completely stateless, and therefore can be freely moved around by Nomad.

This directory also contains the config I use for my dashboard at https://dashboard.arsenm.dev. This is placed into the Consul K/V store as `homer/config.yml`.
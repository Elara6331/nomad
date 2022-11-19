# Nomad

This repository contains my [Nomad](https://github.com/hashicorp/nomad) and [Consul](https://github.com/hashicorp/consul) configurations that I am using for my servers.

Nomad is an orchestrator. It orchestrates a cluster of multiple computers to perform a certain task. Consul is a service discovery solution as well as a key/value store. Nomad seamlessly integrates with Consul to provide a cohesive solution that works really well.

I have a cluster of 8 [Raspberry Pi 4s](https://www.raspberrypi.com/products/raspberry-pi-4-model-b/) (4x 1GB, 4x 2GB RAM), 2 2GB [Pine H64s](https://www.pine64.org/pine-h64-ver-b/), 1 2GB [RockPro64](https://www.pine64.org/rockpro64/), a 16GB [Radxa Rock 5 Model B](https://wiki.radxa.com/Rock5/5b), and a 2012 Mac Mini with an i7 that I've upgraded with a 1TB SSD and 16GB of RAM.

I'd originally planned to use Kubernetes on this cluster, but due to the low power and especially low RAM of many of my nodes, Kubernetes would either take up nearly all the resources or freeze the nodes entirely, forcing a hard reboot. Recently, I found Nomad, which is far more lightweight, while providing more features. In my opinion, the only downside is the fact that Kubernetes has a much bigger community.

Using Nomad is great, and much better than my previous strategy of "stick everything somewhere and hope you remember where". All I do is create one of these nomad files, using the very good documentation for Nomad, and then submit it to Nomad. Nomad then automatically decides where to put the service, installs it, configures it, runs it, and publishes it to Consul, from where Traefik picks it up and reconfigures itself automatically to point to the newly-created service. If the service is stateless, like a few of mine are, then Nomad can seamlessly migrate the service to another node, and Traefik will reconfigure itself automatically to point to the new node.

The way I have my cluster set up is: My mac mini acts as the only Nomad and Consul server in the cluster because it has the most resources. Each node in the cluster has a Nomad client running on it, as well as a Consul client. They are simply services installed by the package manager and run by systemd.

A couple of my services are running outside of Nomad because they have a complex config, or because they're Home Assistant, which has a supervisor docker container that launches other docker containers, etc. and I don't know how to express that in a nomad job file. For these, I use a simple systemd service that runs `consul register` with the service's information. This causes Traefik to pick them up and automatically reconfigure itself the same as it does for Nomad servces.

Before using any files in this repo, read through them and make sure to replace anything that is mentioned on the individual READMEs, as well as things like domain names. My domain is `arsenm.dev`, so change anything that has that to your domain instead,
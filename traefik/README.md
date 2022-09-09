# Traefik

This job file is for the [Traefik](https://github.com/traefik/traefik) reverse proxy, which serves as the entry point for all requests to the cluster, and is the only way to access any services on it from outside the local network.

This nomad job file also contains Traefik's own config embedded within it as part of a template stanza.

In Traefik's config file is a variable called `email`. Set this to your email for Let's Encrypt to use when creating new TLS certificates for your domain. In the `tags` variable, there is a URL. In it, replace `<authelia address>` with the address of your Authelia server if you're running one.

If you would like to constrain the reverse proxy to only run on a specific node in order to ensure that its IP stays constant, you can place the following inside of `task "traefik"`:

```hcl
constraint {
    attribute = "${attr.unique.hostname}"
    operator  = "=="
    value     = "<hostname>"
}
```

replacing `<hostname>` with the hostname of the node you want this to run on.

In the `service` stanza, there is a `tags` variable. Inside it, there is a section configuring Authelia. If not using Authelia, remove this section and the one under it. There should be comments above them stating the same thing.
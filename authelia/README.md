# Authelia

This job file runs [Authelia](https://www.authelia.com/), which allows users to protect services that prpvide no authentication mechanism with a password and 2fa. It can also be used to log in to other self-hosted services, similar to how "Log in to Google" buttons work.

IMPORTANT NOTE: Some services in this repo are protected by Authelia. You can find out which by doing Ctrl+F in their nomad files and searching for "authelia". If you are not running Authelia, those services will be available WITHOUT A PASSWORD, so do not expose them to the internet without Authelia protecting them.

This job requires one volume for Authelia's config and secrets. This volume should be named `authelia-config`, and be read/write, not readonly. 

There is one thing you will want to change in this file. In the `env` stanza, the timezone, or `TZ`, is set to "CHANGE ME". Set this to your timezone as it is used when generating TOTP codes for 2fa.

Since configuration for Authelia is complex and heavily dependent on your environment and what you want it to do, I will leave my authelia config out and instead direct you to the documentation: https://www.authelia.com/configuration/prologue/introduction/, and this blog post that I used when configuring authelia: https://spad.uk/configure-authelia-to-work-with-traefik/.
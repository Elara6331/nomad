# SearXNG

This nomad file runs the [SearXNG](https://docs.searxng.org/) metasearch engine. SearXNG is a search engine that takes its results from other search engines and aggregates all of them into one, also known as a metasearch engine.

There is one thing you will want to change in this config. In the `env` stanza, there is a secret set to "CHANGE ME". Set this to a random string. If you're on Linux, most linux distros can generate a suitable string using `openssl rand -base64 25`.

This job is stateless, so it can be moved around freely by Nomad.
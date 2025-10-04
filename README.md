# Pixelfed as podman container

This is a small recipe to pixelfed running as podman container.

## Small differences from default

Pixelfed has Dockerfile and docker-compose.yml to run.

And it also deploys nginx and nginx-acme.

This service just listens to the php-fpm port and you have to
configure your local nginx to work together.

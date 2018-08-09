# This image is broken do not use it.







[![Postgres Logo](https://wiki.postgresql.org/images/a/a4/PostgreSQL_logo.3colors.svg)](https://www.postgresql.org/)

# Postgres SQL

This is an image for Postgres to run in pterodactyl. It's in testing and shouldn't be used.

The startup is very specific and shouldn't be modified or you could lose data. Variables are the preffered way to set a change.

## Current Images
Every branch, except master, is a different image. For a current list of images, check the branch list [here](https://github.com/parkervcp/images/branches/active).

## Contributing
We welcome any contributions you might have. Please follow our formatting for Dockerfiles, which involves minimizing the number of layers, as well as the size of the container. If possible, please stick to Alpine Linux based images, however we do make use of `ubuntu:16.04` in the [`source` branch](https://github.com/Pterodactyl/Containers/tree/source) due to Source Engine limitations, and reducing the conflicts that might arise.
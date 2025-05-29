# Docker for Apache + PHP development

## This setup is intended for local development only. It is not intended for production use.

## Why use this approach?

I work on multiple environments and projects that require different PHP versions and databases. This setup allows me to switch between PHP versions and databases easily.

Often people use a docker environment per project. I prefer to have a single environment that I can switch between projects that requires similar PHP versions and databases without having to rebuild the environment and thus **saving time and resources**.

- It was created to provide a simple way to run Apache and PHP in a Docker container for local development.
- It supports multiple PHP versions
- It supports multiple Databases
- It was customized to switch from PHP and Database versions easily
- It was customized to use Xdebug for debugging PHP code
- It's very easy to add or customize PHP versions and any other services

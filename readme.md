# Docker for Apache + PHP development

__This setup is intended for local development only. It is not intended for production use!__

## Why use this approach?

I work on multiple environments and projects that require different PHP versions and databases. This setup allows me to switch between PHP versions and databases easily.

Often people use a docker environment per project. I prefer to have a single environment that I can switch between projects that requires similar PHP versions and databases without having to rebuild the environment and thus **saving time and resources**.

### Key benefits

- It was created to provide a simple way to run Apache and PHP in a Docker container for local development.
- It supports multiple PHP versions
- It supports multiple Databases
- It was customized to switch from PHP and Database versions easily
- It was customized to use Xdebug for debugging PHP code
- It's very easy to add or customize PHP versions and any other services

### Separated services for easy customization

Usually you have only one docker-compose.yml file for all your project, but here you can have multiple files for each PHP version and database, so you can easily customize the services you want to use and just install the services you need.

All the hard work of referencing networks and the correct PHP version and database is done for you. You just need to run the docker-compose command and you are ready to go.

## Features

- Apache 2.4
- PHP 5.6 up to 8.3 (with Xdebug and MS SQL Server on PHP 7+)
- MySql, MariaDb and MongoDb
  - MySql tweaked for high memory usage (up to 10GB) and disable of "ONLY_FULL_GROUP_BY"
    - You can disable or tweak the amount of memory you want to use in config/mysql/*

## Usage

1. Clone this repository
2. Copy the `.env.example` file to `.env` (tweak it as necessary)
3. Run `docker-compose -f [filename] up -d` on the containers you need to use
4. Use the Helper scripts to quickly start and stop the containers eg: `scripts/start-php.sh 74` to start PHP 7.4 and `scripts/start-database.sh mysql57` to start MySQL 5.7

### Tips and tricks:

- This setup is not meant to be used with multiple PHP versions at once. You should stop the containers before starting another PHP version or change the ports of each PHP version, otherwise you will have port conflicts.
  - You may use 80[PHP_VERSION] for the Apache port, eg: 8056 for PHP 5.6, 8074 for PHP 7.4, etc.
- **Naming convention**: the containers will be created using the COMPOSE_PROJECT_NAME as a prefix. You can change this in the `.env` file. Eg: PHP 8.3 and prefix "vlk" will create a container named "vlk-php83" so you can easily identify the containers while using command line tools.
  

### Helper scripts

- `scripts/build.sh` - Build the all docker images in a single command saving time when you need to bring up the environment
- `scripts/stop-all.sh` - Stop all containers
- `scripts/start-php.sh [version]` - Start a specific PHP version (eg: `scripts/start-php.sh 74`)
  - If you changed the COMPOSE_PROJECT_NAME, you must modify the scripts to use the correct prefix
- `scripts/stop-php.sh` - Stop any PHP container
- `scripts/start-database.sh [service-name]` - Start a specific database (eg: `scripts/start-database.sh mysql57`) + PHPMyAdmin
  - If you changed the COMPOSE_PROJECT_NAME, you must modify the scripts to use the correct prefix
- `scripts/stop-database.sh` - Stop any database container

## Lessons Learned

- We don't use volumes for databases because it may lead to performance issues.
  - CAUTION: If you remove (docker-compose down) the container, you will lose all the data in the database. You won't have any problems if you just stop the container and start it again.

### On windows

- Install it on WSL2 for better performance
- Avoid using volumes outside of the WSL2 filesystem

## Known issues

Since we're using .env to setup the environment and PHPMyAdmin (PMA) needs a reference of the database, you need to restart PMA after changing the service name on the .env DATABASE_SERVICE=[service-name]. 

I Strongly advise you to **use the helper scripts to start and stop the database** containers as this will replace the current variable value with the name of the service you provided.

If you use more than one database service, you will need to change the PMA configuration to add the new service and probably create new containers for each database service.

## Contributing

- If you have any suggestions or improvements, please let me know.


### Roadmap

- Add more services
- Improove start container scripts to gather the prefix from .env file
- Update the current services to the latest supported version as needed, according to [End of Life](https://endoflife.date/).


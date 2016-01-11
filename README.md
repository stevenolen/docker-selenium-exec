# docker-selenium-exec

This is a [docker](https://www.docker.io) container that can run an arbitrary ruby selenium script against a selenium container.

## Usage

A small container to help exec a selenium script. I don't really know why I did this in this way... containerz ftw, I guess? Thanks to the SeleniumHQ contribs who made the infinitely awesome [selenium containers](https://github.com/SeleniumHQ/docker-selenium).

  * First run a selenium standalone container (or whatever your needs are): `docker run -d --name selenium selenium/standalone-chrome`
  * Now run this container and pass any ruby script with selenium-webdriver stuffz: `docker run -v /path/to/script.rb:/script.rb --link=selenium:selenium stevenolen/selenium-exec`
  * profit $$ `:)`

## Notes

An script is already included in the container if you would like an example, or if for some reason you really want to automate rebooting an Archer C7 v1 router (ha!). The example script also implements a health check to ensure the selenium instance is available before it continues (really nice and convenient if you happen to want to tie these containers together with `docker-compose`). Otherwise have fun!

## License

Licensed under the Apache Version 2.0 license. See `LICENSE` file for full text.

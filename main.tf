terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  host = "tcp://localhost:2376"
}

resource "docker_network" "webnetwork" {
  name   = "webnetwork1"
  driver = "bridge"
}

resource "docker_volume" "mysqlvol1" {
  name = "mysqlvol1"
}

resource "docker_volume" "wordpressvol1" {
  name = "wordpressvol1"
}

resource "docker_container" "db" {
  image        = "mysql:8.0"
  name         = "db"
  restart      = "always"
  env = [
    "MYSQL_ROOT_PASSWORD=123456",
    "MYSQL_DATABASE=wordpress",
    "MYSQL_USER=wordpress",
    "MYSQL_PASSWORD=123456"
  ]
  mounts {
    target = "/var/lib/mysql"
    source = docker_volume.mysqlvol1.name
    type   = "volume"
  }
  networks_advanced {
    name = docker_network.webnetwork.name
  }
}

resource "docker_container" "wordpress" {
  image        = "wordpress:latest"
  name         = "wordpress"
  ports {
    internal = 80
    external = 8000
  }
  restart = "always"
  depends_on = [docker_container.db]
  env = [
    "WORDPRESS_DB_HOST=db:3306",
    "WORDPRESS_DB_USER=wordpress",
    "WORDPRESS_DB_PASSWORD=123456",
    "WORDPRESS_DB_NAME=wordpress"
  ]
  mounts {
    target = "/var/www/html"
    source = docker_volume.wordpressvol1.name
    type   = "volume"
  }
  networks_advanced {
    name = docker_network.webnetwork.name
  }
}

resource "docker_container" "phpmyadmin" {
  image        = "phpmyadmin:latest"
  name         = "phpmyadmin"
  ports {
    internal = 80
    external = 8080
  }
  restart = "always"
  depends_on = [docker_container.db]
  links = ["db:db"]
  networks_advanced {
    name = docker_network.webnetwork.name
  }
}

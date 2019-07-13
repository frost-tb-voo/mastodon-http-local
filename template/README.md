# Auto generated mastodon instance

https://github.com/frost-tb-voo/mastodon-http-local.git

## Content
### docker-compose (mastodon)
consist of:

- docker-comopse.yml
  - .env.development
  - .env
    - are, configuration files for docker-compose.
    - includes subnet and IPv4_address for each container in docker network, etc.
- public
  - includes static files posted by mastodon users
- postgres
  - includes postgres data files
- redis
  - includes redis data files
- accounts-*
  - log of initial admin user account

### nginx
consist of:

- nginx.conf

## How to uninstall
Execute [uninstall.sh](uninstall.sh).


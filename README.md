# mastodon-http-local
[![](https://img.shields.io/travis/frost-tb-voo/mastodon-http-local/master.svg?style=flat-square)](https://travis-ci.org/frost-tb-voo/mastodon-http-local/)
[![GitHub stars](https://img.shields.io/github/stars/frost-tb-voo/mastodon-http-local.svg?style=flat-square)](https://github.com/frost-tb-voo/mastodon-http-local/stargazers)
[![GitHub license](https://img.shields.io/github/license/frost-tb-voo/mastodon-http-local.svg?style=flat-square)](https://github.com/frost-tb-voo/mastodon-http-local/blob/master/LICENSE)
[![Docker pulls](https://img.shields.io/docker/pulls/novsyama/mastodon-http-local.svg?style=flat-square)](https://hub.docker.com/r/novsyama/mastodon-http-local)
[![Docker image-size](https://img.shields.io/microbadger/image-size/novsyama/mastodon-http-local.svg?style=flat-square)](https://microbadger.com/images/novsyama/mastodon-http-local)
![Docker layers](https://img.shields.io/microbadger/layers/novsyama/mastodon-http-local.svg?style=flat-square)

Unofficial [mastodon](https://github.com/tootsuite/mastodon) docker image for `http://` (NOT `https://`) scheme federation.
This image enables remote follow through `http://` scheme.

This is not production ready.
**Use only for testing or development.**
For example, use in the following situations:

- Create a mastodon instance in your home local intra network.
- Create federatable mastodon instances in docker local networks.

## Requirement

- Linux OS
  - recommended : ubuntu 18.04.2 LTS
- Docker CE
  - https://docs.docker.com/
  - recommended : version 18.09.6
- docker-compose
  - recommended : version 1.24.0
  - https://docs.docker.com/compose/install/
- An account of SMTP server

## How to install
First, 

```
git clone https://github.com/frost-tb-voo/mastodon-http-local.git
```

And then,

- 1. Do SMTP setup
- 2. Create instances. Choose 2-a or 2-b.
  - 2-a. A single instance
  - 2-b. Federatable instances

### 1. SMTP setup
Create `./template/.env.development` from [.env.development.example](./template/.env.development.example) .

#### [mailtrap.io](https://mailtrap.io)
Safe Email Testing for Staging & Development

Free plan offer you 500 emails per month. 

After registration, open "Demo inbox" and copy generated username to `SMTP_LOGIN` and password to `SMTP_PASSWORD`. `SMTP_SERVER` is `smtp.mailtrap.io`.

#### gmail
If you are a gmail user and use `gmail.com` as SMTP server, the values of the following keys are required.

- SMTP_FROM_ADDRESS
  - for example `Mastodon <username@gmail.com>`
- SMTP_LOGIN
  - for example `username@gmail.com`
- SMTP_PASSWORD
  - for example `1234567890123456`

Look at the following page to generate an app password (SMTP_PASSWORD),

https://support.google.com/mail/answer/185833?hl=ja

### 2-a. A single instance
Create a single mastodon instance in your home local intra network.
Edit [create.sh](./single/create.sh) and execute it.

The values of the following variables are required.

- USER_NAME, is a user name of initial admin account
- USER_EMAIL, is a valid e-mail address of initial admin account
  - SMTP server will send a confirming e-mail to this address, this event would be triggered by sidekiq container.

The values of the following variables are customizable.

- INSTANCE, is a directory name for the creating mastodon instance
  - installation path. The persistent data would be written here.
  - the prefix of container and network names become this value.
- MSTDN_SUBNET, is a subnet of docker network where the creating instance belongs to
  - the specified value must not be in use by other docker containers
  - for example `172.32.0.0/24`
- NGINX_IP, is an IPv4 address in docker network
  - must belongs to MSTDN_SUBNET.
  - for example `172.32.0.32`
- MSTDN_IPV4_WEB, is an IPv4 address of web container (defined in docker-compose.yml)
  - must belongs to MSTDN_SUBNET.
  - for example `172.32.0.4`
- MSTDN_IPV4_STREAMING, is an IPv4 address of streaming container (defined in docker-compose.yml)
  - must belongs to MSTDN_SUBNET.
  - for example `172.32.0.6`
- MSTDN_IPV4_SIDEKIQ, is an IPv4 address of sidekiq container (defined in docker-compose.yml)
  - must belongs to MSTDN_SUBNET.
  - for example `172.32.0.8`

Execute `create.sh`, then the script creates an INSTANCE directory, configures the instance, and creates containers. After all, the script will show the mastodon URL, an initial user account and password. Open it with your favorites browser.

#### (Optional) Access from other machines
Set the value into PRIVATE_DOMAIN_OR_IP in `create.sh`.

- PRIVATE_DOMAIN_OR_IP
  - must be resolvable from other machines.
  - for example, `192.168.177.131`
  - for example, `mydomain.example.local`

### 2-b. Federatable instances
Create federatable mastodon instances in docker local networks.
Edit [create.sh](./federated/create.sh) and execute it.

The required values are almost the same with 2-a.

- USER_NAME
- USER_EMAIL

Now, the current implementation of `create.sh` script creates just 3 instances, and following variables appear 3 times in the script (yet under construction).

- INSTANCE
- MSTDN_SUBNET
- NGINX_IP
- MSTDN_IPV4_WEB
- MSTDN_IPV4_STREAMING
- MSTDN_IPV4_SIDEKIQ

And, there are additional variables:

- INSTANCE1,2,3
  - order insensitive. listup all the INSTANCE values to construct network for nginx
- NGINX_IP1,2,3
  - order insensitive. listup all the NGINX_IP values to construct network for nginx

## Operations

### Uninstall
Execute `uninstall.sh` in the instance directory for each instance.

### Backup and rollback
See the mastodon official document.

https://docs.joinmastodon.org/administration/post-installation/

### Update to latest version
TBD.

## For developers
To understand the operations for mastodon in the script file [create-mstdn.sh](./single/create-mstdn.sh), see the mastodon official document.

https://docs.joinmastodon.org/administration/installation/


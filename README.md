# PrivateBin Docker
Dockerfile to setup [PrivateBin](https://github.com/PrivateBin/PrivateBin) and [Certbot](https://certbot.eff.org/)
inside a [Docker](https://www.docker.com) container.

___

# Usage
Replace `example.com` with the domain you wish to use. (Dockerfile and `cert.sh` before building)

### Build with the below command
`docker build PrivateBin-docker -t privatebin`

### Docker Run Command
`sudo docker run -p 80:80 -p 443:443 -d --name privatebin -h domain.com privatebin`

### Read and Run `cert.sh`
`docker exec -i privatebin bash -c "cd / && bash cert.sh"`

### Add to Cron

`$ sudo crontab -e`

`0 0 1 * * docker exec -i privatebin bash -c "certbot renew"`

This will renew the certificate every month (30 days)

___

## [Certbot Documentation](https://certbot.eff.org/docs/using.html)
## [PrivateBin Documentation](https://github.com/PrivateBin/PrivateBin/wiki)
## [Docker Documentation](https://docs.docker.com/)

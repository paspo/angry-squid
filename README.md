# angry-squid

Deploy the squid and let it rule!

## features

* under the hood, there's the usual, mighty squid
* proxy mode (port 3128) and transparent mode (port 3129)
* special patterns to keep files in cache for more time
* alpine package + debian package + docker container (both debian and alpine)

## build

debian container:

    docker build -t angry-squid:latest -f Dockerfile-debian .

alpine container:

    docker build -t angry-squid:latest -f Dockerfile-alpine .

## basic usage

    docker run -d --name angry-squid \
      -p 3128:3128 \
      -v "$PWD/cache:/var/spool/squid" \
      angry-squid:latest

Now you can change your proxy settings to [the IP of the machine above] with port 3128.
For better results, this is the configuration for APT:


```shell
cat <<'EOF' | sudo tee /etc/apt/apt.conf.d/80proxy
Acquire::http::Proxy "http://IP.ADDRESS:3128/";
Acquire::https::Proxy "http://IP.ADDRESS:3128/";
EOF
```

Just replace *IP.ADDRESS* with the correct ip address

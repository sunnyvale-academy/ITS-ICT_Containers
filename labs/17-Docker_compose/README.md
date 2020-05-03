# Docker Compose

Compose is a tool for defining and running multi-container Docker applications. With Compose, you use a YAML file to configure your application’s services. Then, with a single command, you create and start all the services from your configuration.

## Prerequisites

Having installed:

- [Docker](https://docs.docker.com/docker-for-windows/install/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Activity

Please hava look of the files listed below:

- app/app.py
- docker-compose.yaml
- Dockerfile

Run the docker-compose utility

```console
$ docker-compose up -d
...
Creating 17-docker_compose_redis_1 ... done
Creating 17-docker_compose_web_1   ... done
```

Inspect the container's logs

```console
$ docker-compose logs
Attaching to 17-docker_compose_web_1, 17-docker_compose_redis_1
redis_1  | 1:C 03 May 2020 23:09:05.942 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
redis_1  | 1:C 03 May 2020 23:09:05.942 # Redis version=6.0.1, bits=64, commit=00000000, modified=0, pid=1, just started
redis_1  | 1:C 03 May 2020 23:09:05.942 # Warning: no config file specified, using the default config. In order to specify a config file use redis-server /path/to/redis.conf
redis_1  | 1:M 03 May 2020 23:09:05.945 * Running mode=standalone, port=6379.
redis_1  | 1:M 03 May 2020 23:09:05.946 # WARNING: The TCP backlog setting of 511 cannot be enforced because /proc/sys/net/core/somaxconn is set to the lower value of 128.
redis_1  | 1:M 03 May 2020 23:09:05.946 # Server initialized
redis_1  | 1:M 03 May 2020 23:09:05.946 # WARNING you have Transparent Huge Pages (THP) support enabled in your kernel. This will create latency and memory usage issues with Redis. To fix this issue run the command 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' as root, and add it to your /etc/rc.local in order to retain the setting after a reboot. Redis must be restarted after THP is disabled.
redis_1  | 1:M 03 May 2020 23:09:05.946 * Ready to accept connections
web_1    |  * Serving Flask app "app.py"
web_1    |  * Environment: production
web_1    |    WARNING: This is a development server. Do not use it in a production deployment.
web_1    |    Use a production WSGI server instead.
web_1    |  * Debug mode: off
web_1    |  * Running on http://0.0.0.0:5000/ (Press CTRL+C to quit)
```

Test the application by pointing your browser at http://\<DOCKER HOST\>:5000, you should see the message **Hello World! I have been seen 1 times.**

or using cURL:

```console
$ curl -vvv http://<DOCKER HOST>:5000

* Rebuilt URL to: http://localhost:5000/
*   Trying 127.0.0.1...
* Connected to localhost (127.0.0.1) port 5000 (#0)
> GET / HTTP/1.1
> Host: localhost:5000
> User-Agent: curl/7.45.0
> Accept: */*
>
* HTTP 1.0, assume close after body
< HTTP/1.0 200 OK
< Content-Type: text/html; charset=utf-8
< Content-Length: 39
< Server: Werkzeug/1.0.1 Python/3.7.7
< Date: Sun, 03 May 2020 23:13:17 GMT
<
Hello World! I have been seen 1 times.
* Closing connection 0
```

In both cases, remeber to substitute the placeholder \<DOCKER HOST\> accordingly.

When you are done, remove everything using the command:

```console
$ docker-compose down

Stopping 17-docker_compose_web_1   ... done
Stopping 17-docker_compose_redis_1 ... done
Removing 17-docker_compose_web_1   ... done
Removing 17-docker_compose_redis_1 ... done
Removing network 17-docker_compose_default
```
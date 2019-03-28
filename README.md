Docker container to run PyCharm Community Edition (https://www.jetbrains.com/pycharm/)

### Usage

```
docker run --rm \
  -e DISPLAY=${DISPLAY} \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v ~/.PyCharm:/home/developer/.PyCharm \
  -v ~/.PyCharm.java:/home/developer/.java \
  -v ~/.PyCharm.py2:/usr/local/lib/python2.7 \
  -v ~/.PyCharm.py3:/usr/local/lib/python3.5 \
  -v ~/Project:/home/developer/Project \
  --name pycharm-$(head -c 4 /dev/urandom | xxd -p)-$(date +'%Y%m%d-%H%M%S') \
rycus86/pycharm:latest
```

Docker Hub Page: https://hub.docker.com/r/rycus86/pycharm/

### Notes

The IDE will have access to Python 2 and 3 both and to Git as well.
Project folders need to be mounted like `-v ~/Project:/home/developer/Project`.
The actual name can be anything - I used something random to be able to start multiple instances if needed.

To use `pip` (or `pip3`) either use the terminal in PyCharm or install from the terminal from inside the container like `docker exec -it pycharm-running bash` then install using **pip**.

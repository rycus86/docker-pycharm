Docker container to run PyCharm Community Edition (https://www.jetbrains.com/pycharm/)

### Usage

```
docker run --rm \
  -e DISPLAY=${DISPLAY} \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v ~/.PyCharm:/home/developer/.PyCharm \
  -v ~/.PyCharm.java:/home/developer/.java \
  -v ~/.PyCharm.py3:/home/developer/.py3.libs \
  -v ~/.PyCharm.share:/home/developer/.local/share/JetBrains \
  -v ~/Project:/home/developer/Project \
  --name pycharm-$(head -c 4 /dev/urandom | xxd -p)-$(date +'%Y%m%d-%H%M%S') \
rycus86/pycharm:latest
```

Docker Hub Page: https://hub.docker.com/r/rycus86/pycharm/

### OS X instructions

1. Install XQuartz from https://www.xquartz.org/releases/
2. Configure `Allow connections from network clients` in the settings 
   - Restart the system (needed only once when this is enabled)
3. Run `xhost +localhost` in a terminal to allow connecting to X11 over the TCP socket
4. Use `-e DISPLAY=host.docker.internal:0` for passing the `${DISPLAY}` environment

### Notes

The IDE will have access to Python 3 and to Git.
Project folders need to be mounted like `-v ~/Project:/home/developer/Project`.
The actual name can be anything - I used something random to be able to start multiple instances if needed.

To use `pip`, either use the terminal in PyCharm or install from the terminal from inside the container like `docker exec -it pycharm-running bash` then install using **pip**.

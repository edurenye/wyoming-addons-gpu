# Wyoming Add-ons

Docker-only builds for Home Assistant add-ons that use the [Wyoming protocol](https://github.com/rhasspy/rhasspy3/blob/master/docs/wyoming.md), specifically:

* [Whisper](https://hub.docker.com/r/rhasspy/wyoming-whisper) ([Add-on](https://github.com/home-assistant/addons/blob/master/whisper/README.md))
* [Piper](https://hub.docker.com/r/rhasspy/wyoming-piper) ([Add-on](https://github.com/home-assistant/addons/blob/master/piper/README.md))


## Run Whisper

``` sh
docker run -it -p 10300:10300 -v /path/to/local/data:/data rhasspy/wyoming-whisper --model tiny-int8 --language en
```


## Run Piper

``` sh
docker run -it -p 10200:10200 -v /path/to/local/data:/data rhasspy/wyoming-piper --voice en_US-lessac-medium
```

## To run in standalone server

### Run without GPU

Build openwakeword, piper and whisper without GPU with:

``` sh
docker compose -f docker-compose.base.yml build --no-cache
```

Run it with:

``` sh
docker composer -f docker-compose.base.yml up -d
```

Take it down with:

``` sh
docker composer down
```

### Run with GPU

Build openwakeword, piper and whisper with GPU with:

``` sh
docker compose -f docker-compose.gpu.yml build --no-cache
```

Run it with:

``` sh
docker composer -f docker-compose.gpu.yml up -d
```

Take it down with:

``` sh
docker composer down
```

### Extend it

You can extend those files adding your own languages.
More on docker compose extend in the [official documentation](https://docs.docker.com/compose/multiple-compose-files/extends/).


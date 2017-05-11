.PHONY: build push

build:
	docker build -t jiramot/ffmpeg .

push:
	docker push jiramot/ffmpeg

default: build

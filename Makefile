traefik_ver=v2.10.7
alpine_ver=latest

.PHONY: build

build:
	docker build --pull --no-cache --build-arg TRAEFIK_VERSION=${traefik_ver} --build-arg ALPINE_VERSION=${alpine_ver} --platform=linux/amd64,linux/arm64 -t nerethos/traefik:$(traefik_ver) -t nerethos/traefik:latest -f ./Dockerfile .

.PHONY: push

push:
	docker push nerethos/traefik:$(traefik_ver)
	docker push nerethos/traefik:latest
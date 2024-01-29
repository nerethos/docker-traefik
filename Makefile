.PHONY: docker-build
docker-build:
	docker build --platform=linux/amd64,linux/arm64 -t nerethos/traefik:v2.10.7 -f ./latest.dockerfile .
	docker build --platform=linux/amd64,linux/arm64 -t nerethos/traefik:latest -f ./latest.dockerfile .

.PHONY: docker-push
docker-push:
	docker push nerethos/traefik:v2.10.7
	docker push nerethos/traefik:latest
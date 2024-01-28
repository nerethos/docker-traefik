.PHONY: docker-build
docker-build:
	docker build -t nerethos/traefik:latest -f ./amd64.dockerfile .
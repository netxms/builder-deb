.PHONY: all clean build-trixie build-bookworm build-bullseye build-noble build-jammy build-focal

REGISTRY = ghcr.io/netxms/builder-deb

all: build-trixie build-bookworm build-bullseye build-noble build-jammy build-focal

build-trixie:
	docker build --build-arg BASE_IMAGE=debian:trixie --build-arg DISTRO_TYPE=debian --build-arg DISTRO_VERSION=trixie -t $(REGISTRY):trixie .

build-bookworm:
	docker build --build-arg BASE_IMAGE=debian:bookworm --build-arg DISTRO_TYPE=debian --build-arg DISTRO_VERSION=bookworm -t $(REGISTRY):bookworm .

build-bullseye:
	docker build --build-arg BASE_IMAGE=debian:bullseye --build-arg DISTRO_TYPE=debian --build-arg DISTRO_VERSION=bullseye -t $(REGISTRY):bullseye .

build-noble:
	docker build --build-arg BASE_IMAGE=ubuntu:noble --build-arg DISTRO_TYPE=ubuntu --build-arg DISTRO_VERSION=noble -t $(REGISTRY):noble .

build-jammy:
	docker build --build-arg BASE_IMAGE=ubuntu:jammy --build-arg DISTRO_TYPE=ubuntu --build-arg DISTRO_VERSION=jammy -t $(REGISTRY):jammy .

build-focal:
	docker build --build-arg BASE_IMAGE=ubuntu:focal --build-arg DISTRO_TYPE=ubuntu --build-arg DISTRO_VERSION=focal -t $(REGISTRY):focal .

clean:
	docker rmi -f $(REGISTRY):trixie $(REGISTRY):bookworm $(REGISTRY):bullseye $(REGISTRY):noble $(REGISTRY):jammy $(REGISTRY):focal

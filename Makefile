.PHONY: build release down clean

IMAGE_NAME ?= vanities/grin
IMAGE_VERSION ?= latest

image: 
	docker build -t $(IMAGE_NAME):$(IMAGE_VERSION) .

build:
	docker-compose \
		--file docker-compose.yml \
		build

release: image copy_into_cli
	docker push $(IMAGE_NAME):$(IMAGE_VERSION)

# janitor's closet
down:
	docker-compose \
		--file docker-compose.yml \
		down

clean: down
	docker rmi $(IMAGE_NAME)
	docker system prune -a -f

default: image

PROJECT=nabp-assessment
IMAGE_NAME=${PROJECT}:latest

.PHONY: up

up:
	docker build -t ${IMAGE_NAME} .
	docker run --rm -it \
		-v ${PWD}:/dbt-project \
		${IMAGE_NAME} bash


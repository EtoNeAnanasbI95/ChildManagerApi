export PORT=42076

build:
	docker-compose build child-api

run:
	docker-compose up -d child-api

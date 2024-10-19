export PORT=42076

run:
	docker-compose rm -f
	docker-compose up --build -d

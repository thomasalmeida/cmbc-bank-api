.PHONY: up
up:
	@echo "Building Rails API..."
	@cd docker && docker-compose build
	@echo "Bundling gems..."
	@cd docker && docker-compose run --rm cmbc-bank-api bundle install
	@echo "Preparing Rails API..."
	@make prepare-db
	@make check-migrations
	@echo "Starting Rails API..."
	@cd docker && docker-compose up -d

.PHONY: prepare-db
prepare-db:
	@cd docker && docker-compose run --rm cmbc-bank-api bundle exec rails db:create > /dev/null 2>&1

.PHONY: check-migrations
check-migrations:
	@if cd docker && docker-compose run --rm cmbc-bank-api bundle exec rails db:migrate:status | grep 'down'; then \
			cd docker && docker-compose run --rm cmbc-bank-api bundle exec rails db:migrate > /dev/null 2>&1 && echo "Migrations completed."; \
	else \
			echo "Database is up to date."; \
	fi

.PHONY: test
test: up
	@echo "Running tests with RSpec..."
	@cd docker && docker-compose exec cmbc-bank-api bundle exec rspec
	@make down

.PHONY: down
down:
	@echo "Shutting down the application..."
	@cd docker && docker-compose down

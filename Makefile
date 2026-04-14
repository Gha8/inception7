NAME             = inception

DOCKER_COMPOSE_PATH   = ./srcs/docker-compose.yml

GREEN            = \033[0;32m
RED              = \033[0;31m
RESET            = \033[0m


all: setup
	@echo "$(GREEN)Lanching the project ..$(RESET)"
	@docker compose -f $(DOCKER_COMPOSE_PATH) up -d  --build 

setup:
	@echo "$(GREEN)Creating folders for the data ..$(RESET)"
	@sudo mkdir -p /home/$(USER)/data/mariadb
	@sudo mkdir -p /home/$(USER)/data/wordpress
	@sudo chown -R 101:101 /home/$(USER)/data/mariadb
	@sudo chown -R 33:33 /home/$(USER)/data/wordpress
down:
	@echo "$(RED)Shutting down containers..$(RESET)"
	@docker compose -f $(DOCKER_COMPOSE_PATH) down

clean:
	@echo "$(RED)Deleting images and network..${RESET}"
	@docker compose -f $(DOCKER_COMPOSE_PATH) down
	@docker system prune -a -f

fclean: clean
	@echo "$(RED)Deleting of volumes..$(RESET)"
	@sudo rm -rf /home/${USER}/data
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true

re: fclean all

.PHONY: all setup down clean fclean re

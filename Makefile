SHELL = /bin/bash
default:

clean:
	rm -f requirements*.txt
	find . -path "*__pycache__" | xargs rm -rf
	find . -path "*egg-info"    | xargs rm -rf

start-dev: .dev
	@cd .dev && docker compose up -d
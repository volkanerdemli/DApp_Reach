REACH = reach

.PHONY: clean
clean:
	rm -rf build/*.main.mjs

build/%.main.mjs: %.rsh
	$(REACH) compile $^ main

.PHONY: build
build: build/index.main.mjs
	docker build -f Dockerfile --tag=reachsh/reach-app-tut-2:latest .

.PHONY: run
run:
	$(REACH) run index

.PHONY: run-target
run-target: build
	docker-compose -f "docker-compose.yml" run --rm reach-app-tut-2-$${REACH_CONNECTOR_MODE} $(ARGS)

.PHONY: down
down:
	docker-compose -f "docker-compose.yml" down --remove-orphans
.PHONY: check
check: docker-compose.algo.yml
#	./check.sh docker-compose.yml
	./check.sh docker-compose.algo.yml

docker-compose.algo.yml: docker-compose.yml
	sed -e '32s/ &default-app//' -e '52s/:/: \&default-app/' $^ > $@

.PHONY: run-live
run-live:
	docker-compose run --rm reach-app-tut-8-ETH-live

.PHONY: run-alice
run-alice:
	docker-compose run --rm alice

.PHONY: run-bob
run-bob:
	docker-compose run --rm bob
.PHONY: run prep cluster demo

cluster:
	scripts/cluster.sh

clean:
	scripts/down.sh

deploy:
	scripts/traefik.sh
	scripts/deploy.sh

lb:
	scripts/traefik.sh

prep:
	scripts/prep.sh

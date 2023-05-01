clean:
	@-rm -rf archive bin
	@-rm -f deploy/main
	@-rm -f deploy/conjur-dev.pem
	@-rm -f deploy/main.zip
	@-rm -r ./config/env/env.sh
policy:
	sh add_policy.sh
build:
	sh build.sh
lambda:
	sh deploy.sh
apply:
	cd deploy && terraform apply
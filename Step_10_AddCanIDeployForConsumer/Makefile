.EXPORT_ALL_VARIABLES:
PACT_BROKER_BASE_URL?=http://localhost:8000
PACT_BROKER_USERNAME=pact_workshop
PACT_BROKER_PASSWORD=pact_workshop
PACT_CLI_DOCKER="docker run --rm -v ${PWD}:${PWD} -e PACT_BROKER_BASE_URL -e PACT_BROKER_USERNAME -e PACT_BROKER_PASSWORD -e PACT_BROKER_TOKEN pactfoundation/pact-cli"
VERSION_COMMIT?=$(shell git rev-parse HEAD)
VERSION_BRANCH?=$(shell git rev-parse --abbrev-ref HEAD)
CONSUMER_NAME=GettingStartedOrderWeb

can_i_deploy:
	pact-broker can-i-deploy --pacticipant ${CONSUMER_NAME} --version ${VERSION_COMMIT} --to-environment test

can_i_deploy_docker:
	${PACT_CLI_DOCKER} can-i-deploy --pacticipant ${CONSUMER_NAME} --version ${VERSION_COMMIT} --to-environment test

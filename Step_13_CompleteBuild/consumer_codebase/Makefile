ifeq '$(findstring ;,$(PATH))' ';'
	detected_OS := Windows
else
	detected_OS := $(shell uname 2>/dev/null || echo Unknown)
	detected_OS := $(patsubst CYGWIN%,Cygwin,$(detected_OS))
	detected_OS := $(patsubst MSYS%,MSYS,$(detected_OS))
	detected_OS := $(patsubst MINGW%,MSYS,$(detected_OS))
endif

.EXPORT_ALL_VARIABLES:
PACT_BROKER_BASE_URL?=http://localhost:8000
PACT_BROKER_USERNAME=pact_workshop
PACT_BROKER_PASSWORD=pact_workshop
PACT_CLI_DOCKER="docker run --rm -v ${PWD}:${PWD} --network=host -e PACT_BROKER_BASE_URL -e PACT_BROKER_USERNAME -e PACT_BROKER_PASSWORD -e PACT_BROKER_TOKEN pactfoundation/pact-cli"
VERSION_COMMIT?=$(shell git rev-parse HEAD)
VERSION_BRANCH?=$(shell git rev-parse --abbrev-ref HEAD)
CONSUMER_NAME=GettingStartedOrderWeb

doctor:
	./pact_helper.sh doctor

install_pact_cli_ruby:
	./pact_helper.sh install-pact-cli ruby

install_pact_cli_standalone:
	./pact_helper.sh install-pact-cli standalone

install_pact_cli_docker:
	./pact_helper.sh install-pact-cli docker

publish:
	pact-broker publish pacts --consumer-app-version ${VERSION_COMMIT} --branch ${VERSION_BRANCH}

publish_docker:
# assumes your pact broker is running with docker compose from step 3 
# containers run non linux machines cannot access localhost
	case "${detected_OS}" in \
		Windows|MSYS|Darwin) PACT_BROKER_BASE_URL=http://host.docker.internal:8000 "${PACT_CLI_DOCKER}" pact-broker publish ${PWD}/pacts --consumer-app-version ${VERSION_COMMIT} --branch ${VERSION_BRANCH} ;; \
		*) 	"${PACT_CLI_DOCKER}" pact-broker publish ${PWD}/pacts --consumer-app-version ${VERSION_COMMIT} --branch ${VERSION_BRANCH} ;; \
	esac

test_consumer:
	npm run test:consumer

ci: test_consumer publish_docker

can_i_deploy:
	pact-broker can-i-deploy --pacticipant ${CONSUMER_NAME} --version ${VERSION_COMMIT} --to-environment test

record_deployment:
	pact-broker record-deployment --pacticipant ${CONSUMER_NAME} --version ${VERSION_COMMIT} --environment test

can_i_deploy_docker:
	"${PACT_CLI_DOCKER}" pact-broker can-i-deploy --pacticipant ${CONSUMER_NAME} --version ${VERSION_COMMIT} --to-environment test

record_deployment_docker:
	"${PACT_CLI_DOCKER}" pact-broker record-deployment --pacticipant ${CONSUMER_NAME} --version ${VERSION_COMMIT} --environment test

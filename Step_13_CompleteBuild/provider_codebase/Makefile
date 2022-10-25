ifeq '$(findstring ;,$(PATH))' ';'
	detected_OS := Windows
else
	detected_OS := $(shell uname 2>/dev/null || echo Unknown)
	detected_OS := $(patsubst CYGWIN%,Cygwin,$(detected_OS))
	detected_OS := $(patsubst MSYS%,MSYS,$(detected_OS))
	detected_OS := $(patsubst MINGW%,MSYS,$(detected_OS))
endif

GITHUB_REPO := "you54f/example-provider"
CONTRACT_REQUIRING_VERIFICATION_PUBLISHED_WEBHOOK_UUID := "8ce63439-6b70-4e9b-8891-703d5ea2953c"

.EXPORT_ALL_VARIABLES:
PACT_BROKER_BASE_URL?=http://localhost:8000
PACT_BROKER_USERNAME=pact_workshop
PACT_BROKER_PASSWORD=pact_workshop
VERSION_COMMIT?=$(shell git rev-parse HEAD)
VERSION_BRANCH?=$(shell git rev-parse --abbrev-ref HEAD)
PROVIDER_NAME=GettingStartedOrderApi
CONSUMER_NAME=GettingStartedOrderWeb

test_provider_change:
	npm run test:provider

test_contract_requiring_verification:
	npm run test:contract_requiring_verification

# These steps will run, every time your provider runs in CI, to ensure that verifications
# are executed against the current code base
ci: test_provider_change

# These steps will execute, whenever a contract requiring verification is published and
# not part of your regular providers CI build. We will set this up in a later step
ci_webhook: test_contract_requiring_verification

test_ci_webhook: 
	PACT_URL=${PACT_BROKER_BASE_URL}/pacts/provider/${PROVIDER_NAME}/consumer/${CONSUMER_NAME}/version/${VERSION_COMMIT} make ci_webhook

## =====================
## Pact Broker OSS Webhook set up tasks
## =====================

# export the GITHUB_TOKEN environment variable before running this
create_or_update_contract_requiring_verification_published_webhook:
	case "${detected_OS}" in \
		Windows|MSYS|Darwin) PACT_BROKER_BASE_URL=http://host.docker.internal:8000 "${PACT_CLI_DOCKER}" \
	  broker create-or-update-webhook \
	  "https://api.github.com/repos/${GITHUB_REPO}/dispatches" \
	  --header 'Content-Type: application/json' 'Accept: application/vnd.github.everest-preview+json' 'Authorization: Bearer ${GITHUB_TOKEN}' \
	  --request POST \
	  --data '{ "event_type": "contract_requiring_verification_published","client_payload": { "pact_url": "$${pactbroker.pactUrl}", "sha": "$${pactbroker.providerVersionNumber}", "branch":"$${pactbroker.providerVersionBranch}" , "message": "Verify changed pact for $${pactbroker.consumerName} version $${pactbroker.consumerVersionNumber} branch $${pactbroker.consumerVersionBranch} by $${pactbroker.providerVersionNumber} ($${pactbroker.providerVersionDescriptions})" } }' \
	  --uuid ${CONTRACT_REQUIRING_VERIFICATION_PUBLISHED_WEBHOOK_UUID} \
	  --provider ${PROVIDER_NAME} \
	  --contract-requiring-verification-published \
	  --description "contract_requiring_verification_published for ${PROVIDER_NAME}";; \
		*) "${PACT_CLI_DOCKER}" \
	  broker create-or-update-webhook \
	  "https://api.github.com/repos/${GITHUB_REPO}/dispatches" \
	  --header 'Content-Type: application/json' 'Accept: application/vnd.github.everest-preview+json' 'Authorization: Bearer ${GITHUB_TOKEN}' \
	  --request POST \
	  --data '{ "event_type": "contract_requiring_verification_published","client_payload": { "pact_url": "$${pactbroker.pactUrl}", "sha": "$${pactbroker.providerVersionNumber}", "branch":"$${pactbroker.providerVersionBranch}" , "message": "Verify changed pact for $${pactbroker.consumerName} version $${pactbroker.consumerVersionNumber} branch $${pactbroker.consumerVersionBranch} by $${pactbroker.providerVersionNumber} ($${pactbroker.providerVersionDescriptions})" } }' \
	  --uuid ${CONTRACT_REQUIRING_VERIFICATION_PUBLISHED_WEBHOOK_UUID} \
	  --provider ${PROVIDER_NAME} \
	  --contract-requiring-verification-published \
	  --description "contract_requiring_verification_published for ${PROVIDER_NAME}";; \
	esac
	

test_contract_requiring_verification_published_webhook:
	@curl -v -X POST -u "${PACT_BROKER_USERNAME}:${PACT_BROKER_PASSWORD}" ${PACT_BROKER_BASE_URL}/webhooks/${CONTRACT_REQUIRING_VERIFICATION_PUBLISHED_WEBHOOK_UUID}/execute

## =====================
## Pactflow Webhook set up tasks
## =====================

# export the GITHUB_TOKEN environment variable before running this
create_github_token_secret:
	curl -v -X POST ${PACT_BROKER_BASE_URL}/secrets \
	-H "Authorization: Bearer ${PACT_BROKER_USERNAME}:${PACT_BROKER_PASSWORD}" \
	-H "Content-Type: application/json" \
	-H "Accept: application/hal+json" \
	-d  "{\"name\":\"githubToken\",\"description\":\"Github token\",\"value\":\"${GITHUB_TOKEN}\"}"
	
create_or_update_contract_requiring_verification_published_webhook_pactflow:
	case "${detected_OS}" in \
		Windows|MSYS|Darwin) PACT_BROKER_BASE_URL=http://host.docker.internal:8000 "${PACT_CLI_DOCKER}" \
	  broker create-or-update-webhook \
	  "https://api.github.com/repos/${GITHUB_REPO}/dispatches" \
	  --header 'Content-Type: application/json' 'Accept: application/vnd.github.everest-preview+json' 'Authorization: Bearer $${user.githubToken}' \
	  --request POST \
	  --data '{ "event_type": "contract_requiring_verification_published","client_payload": { "pact_url": "$${pactbroker.pactUrl}", "sha": "$${pactbroker.providerVersionNumber}", "branch":"$${pactbroker.providerVersionBranch}" , "message": "Verify changed pact for $${pactbroker.consumerName} version $${pactbroker.consumerVersionNumber} branch $${pactbroker.consumerVersionBranch} by $${pactbroker.providerVersionNumber} ($${pactbroker.providerVersionDescriptions})" } }' \
	  --uuid ${CONTRACT_REQUIRING_VERIFICATION_PUBLISHED_WEBHOOK_UUID} \
	  --provider ${PROVIDER_NAME} \
	  --contract-requiring-verification-published \
	  --description "contract_requiring_verification_published for ${PROVIDER_NAME}" \
		*) "${PACT_CLI_DOCKER}" \
	  broker create-or-update-webhook \
	  "https://api.github.com/repos/${GITHUB_REPO}/dispatches" \
	  --header 'Content-Type: application/json' 'Accept: application/vnd.github.everest-preview+json' 'Authorization: Bearer $${user.githubToken}' \
	  --request POST \
	  --data '{ "event_type": "contract_requiring_verification_published","client_payload": { "pact_url": "$${pactbroker.pactUrl}", "sha": "$${pactbroker.providerVersionNumber}", "branch":"$${pactbroker.providerVersionBranch}" , "message": "Verify changed pact for $${pactbroker.consumerName} version $${pactbroker.consumerVersionNumber} branch $${pactbroker.consumerVersionBranch} by $${pactbroker.providerVersionNumber} ($${pactbroker.providerVersionDescriptions})" } }' \
	  --uuid ${CONTRACT_REQUIRING_VERIFICATION_PUBLISHED_WEBHOOK_UUID} \
	  --provider ${PROVIDER_NAME} \
	  --contract-requiring-verification-published \
	  --description "contract_requiring_verification_published for ${PROVIDER_NAME}";; \
	esac
	
	

test_contract_requiring_verification_published_webhook_pactflow:
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
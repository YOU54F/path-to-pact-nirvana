const Verifier = require('@pact-foundation/pact').Verifier;
const getPort = require('get-port');
const { server } = require('./provider.js');
const { providerName, consumerName } = require('../pact.js');
let port;
let opts;
let app;

const currentGitHash = require('child_process')
  .execSync('git rev-parse HEAD')
  .toString()
  .trim();

const currentGitBranch = require('child_process')
  .execSync('git branch --show-current')
  .toString()
  .trim();

const pactFile =
  process.env.PACT_URL ??
  (process.env.PACT_BROKER_BASE_URL ?? 'http://localhost:8000') +
    '/pacts/provider/' +
    providerName +
    '/consumer/' +
    consumerName +
    '/version/' +
    currentGitHash;

if (!pactFile) {
  throw new Error('no pact file found');
}
if (!currentGitBranch) {
  throw new Error('no git branch found');
}
if (!currentGitHash) {
  throw new Error('no git hash found');
}

// Verify that the provider meets all consumer expectations
describe('Pact Verification', () => {
  beforeAll(async () => {
    port = await getPort();
    opts = {
      provider: providerName,
      providerBaseUrl: `http://localhost:${port}`,
      pactUrls: [pactFile],
      pactBrokerUrl:
        process.env.PACT_BROKER_BASE_URL ?? 'http://localhost:8000',
      pactBrokerUsername: process.env.PACT_BROKER_USERNAME ?? 'pact_workshop',
      pactBrokerPassword: process.env.PACT_BROKER_PASSWORD ?? 'pact_workshop',
      // pactBrokerToken: process.env.PACT_BROKER_TOKEN,
      publishVerificationResult: true,
      providerVersionBranch: currentGitBranch,
      providerVersion: currentGitHash
    };

    app = server.listen(port, () => {
      console.log(`Provider service listening on http://localhost:${port}`);
    });
  });
  it('should validate the expectations of Order Web', () => {
    return new Verifier(opts)
      .verifyProvider()
      .then((output) => {
        console.log('Pact Verification Complete!');
        console.log(output);
      })
      .catch((e) => {
        console.error('Pact verification failed :(', e);
        throw new Error(e);
      })
      .finally(() => {
        app.close();
      });
  });
});

const pact = require('@pact-foundation/pact');
const Pact = pact.PactV3;
const path = require('path');
const process = require('process');
const consumerName = 'GettingStartedOrderWeb';
const providerName = 'GettingStartedOrderApi';
const pactFile = path.resolve(`./pacts/${consumerName}-${providerName}.json`);

const provider = new Pact({
  log: path.resolve(process.cwd(), 'logs', 'pact.log'),
  dir: path.resolve(process.cwd(), 'pacts'),
  logLevel: 'FATAL',
  consumer: consumerName,
  provider: providerName
});
module.exports = {
  provider,
  pactFile,
  consumerName,
  providerName,
  consumerVersion: '1.0.0'
};

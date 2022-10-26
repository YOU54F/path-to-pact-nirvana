const path = require('path');
const consumerName = 'GettingStartedOrderWeb';
const providerName = 'GettingStartedOrderApi';
const pactFile = path.resolve(`./pacts/${consumerName}-${providerName}.json`);

module.exports = {
  pactFile,
  providerName
};

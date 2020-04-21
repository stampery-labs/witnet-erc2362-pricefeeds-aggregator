const addresses = require("./addresses.json")
const WitnetPriceFeeds = artifacts.require("WitnetPriceFeedsAggregator");

module.exports = function(deployer, network) {
  network = network.split("-")[0]
  deployer.deploy(WitnetPriceFeeds)
    .then(() => WitnetPriceFeeds.deployed())
    .then((instance) => {
      if (network in addresses) {
        for (var contract in addresses[network]) {
         instance.registerFeed(addresses[network][contract].id, addresses[network][contract].address)
        }
      }
   })
};

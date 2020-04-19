const WitnetPriceFeeds = artifacts.require("WitnetPriceFeeds");

module.exports = function(deployer) {
  deployer.deploy(WitnetPriceFeeds);
};
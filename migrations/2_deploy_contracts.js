var JewelCoin = artifacts.require("JewelCoin");


module.exports = function(deployer) {
   deployer.deploy(JewelCoin,'JewelCoin','JC','100000000000000000000000');
}

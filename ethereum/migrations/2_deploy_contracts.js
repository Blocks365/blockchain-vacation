const ConvertLib = artifacts.require("ConvertLib");
const MetaCoin = artifacts.require("MetaCoin");
const VacationRequest = artifacts.require("VacationRequest");

module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.link(ConvertLib, MetaCoin);
  deployer.deploy(MetaCoin);

  deployer.deploy(VacationRequest);
  deployer.deploy(VacationManagers);
};

const ConvertLib = artifacts.require("ConvertLib");
const MetaCoin = artifacts.require("MetaCoin");
const VacationRequest = artifacts.require("VacationRequest");
const VacationManager = artifacts.require("VacationManager");

module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.link(ConvertLib, MetaCoin);
  deployer.deploy(MetaCoin);

  deployer.deploy(VacationManager);
  deployer.link(VacationManager, VacationRequest);
  deployer.deploy(VacationRequest, 0xe9ae1C5A17c632e22d8BBAd39d7F754FdDA4e8B9);  
};

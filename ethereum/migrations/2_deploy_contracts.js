//const ConvertLib = artifacts.require("ConvertLib");
//const MetaCoin = artifacts.require("MetaCoin");
const VacationRequest = artifacts.require("VacationRequest");
const VacationManager = artifacts.require("VacationManager");

module.exports = (deployer) => {
 // deployer.deploy(ConvertLib);
 // deployer.link(ConvertLib, MetaCoin);
 // deployer.deploy(MetaCoin);

  deployer.deploy(VacationManager);
  deployer.link(VacationManager, VacationRequest);
  deployer.deploy(VacationRequest, "0x9936E96Fd704880D419Ba826Fc6963eC455BA0dE");  
};




var TokenTimelock = artifacts.require("TokenTimelock");
var ERC20 = artifacts.require("ERC20");
var SafeMath = artifacts.require("SafeMath");
var ERC20Burnable = artifacts.require("ERC20Burnable");
var ERC20Capped = artifacts.require("ERC20Capped");
var ERC20Mintable = artifacts.require("ERC20Mintable");
var Roles = artifacts.require("Roles");
var ERC20Pausable = artifacts.require("ERC20Pausable");
var SafeERC20 = artifacts.require("SafeERC20");
var Address = artifacts.require("Address");

module.exports = deployer => {
    /*
    deployer.deploy(SafeMath);
    deployer.deploy(Roles);
    deployer.deploy(SafeERC20);
    deployer.deploy(Address);
    deployer.link(SafeERC20, TokenTimelock);
    deployer.link(SafeMath, ERC20);
    deployer.link(SafeMath, ERC20Burnable);
    deployer.link(SafeMath, ERC20Capped);
    deployer.link(Roles, ERC20Capped);
    deployer.link(SafeMath, ERC20Mintable);
    deployer.link(Roles, ERC20Mintable);
    deployer.link(SafeMath, ERC20Pausable);
    deployer.link(Roles, ERC20Pausable);
    deployer.deploy(TokenTimelock, 0, 0xe9ae1C5A17c632e22d8BBAd39d7F754FdDA4e8B9, 0);
    deployer.deploy(ERC20);
    deployer.deploy(ERC20Burnable);
    deployer.deploy(ERC20Capped, 10000);
    deployer.deploy(ERC20Mintable);
    deployer.deploy(ERC20Pausable);
    */
};
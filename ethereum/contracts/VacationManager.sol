pragma solidity >=0.5.0 <0.7.0;

import "./openZeppelin/token/ERC20/ERC20.sol";
import "./openZeppelin/token/ERC20/ERC20Detailed.sol";

contract VacationManager is ERC20, ERC20Detailed  {
    //Set of States
    enum StateType { Provisioned, Terminated }

    //List of properties
    StateType public State = StateType.Provisioned;
    address mantainer;

    //constructor
    constructor(uint256 initialSupply)
        ERC20Detailed("Vacation", "VTK", 0)
        public
    {
        mantainer = msg.sender;
    }

    function addVacationTokens(address employee, unit265 _amount)
        public
    {
        require(state == StateType.Provisioned, "Wrong state");
        require(msg.sender == mantainer, "Only owner can call this function");
        require(_amount > 0, "Only positive amount");

        _mint(employee, _amount);
    }

    function Terminate()
        public
    {
        require(state == StateType.Provisioned, "Wrong state");
        require(msg.sender == mantainer, "Only owner can call this function");

        state = StateType.Terminated;
    }
}
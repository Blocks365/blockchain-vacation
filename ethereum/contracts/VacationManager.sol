pragma solidity >=0.5.0 <0.7.0;

import "./openZeppelin/token/ERC20/ERC20.sol";
import "./openZeppelin/token/ERC20/ERC20Detailed.sol";

contract VacationManager is ERC20, ERC20Detailed  {
    //Set of States
    enum StateType { Provisioned, Terminated }

    //List of properties
    StateType public State = StateType.Provisioned;
    address mantainer;

    mapping (address => bool) public managerAddresses;

    //constructor
    constructor()
        ERC20Detailed("Vacation", "VTK", 0)
        public
    {
        mantainer = msg.sender;
    }

    function AddVacationTokens(address _employee, uint256 _amount)
        public
    {
        require(State == StateType.Provisioned, "State is not 'Provisioned'");
        require(msg.sender == mantainer, "Only owner can call this function");
        require(_amount > 0, "Only positive amount");

        _mint(_employee, _amount);
    }

    function BurnVacationTokens(address _employee, uint256 _amount)
        public
    {
        require(State == StateType.Provisioned, "State is not 'Provisioned'");
        //ToDo: Make sure only the child VacationRequest contract can call this...

        require(_amount < 0, "Only positive amount");

        _burn(_employee, _amount);
    }

    function HasEnoughBalance(address _employee, uint256 _amount)
        public
        view
        returns (bool)
    {
        return balanceOf(_employee) >= _amount;
    }

    function AssignManager(address _manager)
        public
    {
        managerAddresses[_manager] = true;
    }

    function IsManager(address _manager)
        public
        view
        returns (bool)
    {
        return managerAddresses[_manager];
    }



    function Terminate()
        public
    {
        require(State == StateType.Provisioned, "State is not 'Provisioned'");
        require(msg.sender == mantainer, "Only owner can call this function");

        State = StateType.Terminated;
    }
}
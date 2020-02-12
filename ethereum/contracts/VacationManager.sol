pragma solidity >=0.5.0 <0.7.0;

import "./openZeppelin/token/ERC20/ERC20.sol";
import "./openZeppelin/token/ERC20/ERC20Detailed.sol";

contract VacationManager is ERC20, ERC20Detailed {
    //Set of States
    enum StateType {Provisioned, Terminated}

    //List of properties
    StateType public State = StateType.Provisioned;
    address mantainer;

    mapping(address => bool) public managerAddresses;
    mapping(address => address) public vacationRequestManagerAddresses;

    //constructor
    constructor() public ERC20Detailed("Vacation Token", "VTK", 0) {
        mantainer = msg.sender;
    }

    function addVacationTokens(address _employee, uint256 _amount) public {
        require(State == StateType.Provisioned, "State is not 'Provisioned'");
        require(msg.sender == mantainer, "Only owner can call this function");
        require(_amount > 0, "Only positive amount");

        _mint(_employee, _amount);
    }

    function burnVacationTokens(
        address _vacationRequest,
        address _caller,
        address _employee,
        uint256 _amount
    ) public {
        require(State == StateType.Provisioned, "State is not 'Provisioned'");
        require(_amount < 0, "Only positive amount");
        if (vacationRequestManagerAddresses[_vacationRequest] != _caller) {
            revert(
                "Only the vacation request manager can burn tokens after approval"
            );
        }

        _burn(_employee, _amount);
    }

    function hasEnoughBalance(address _employee, uint256 _amount)
        public
        view
        returns (bool)
    {
        return balanceOf(_employee) >= _amount;
    }

    function assignManager(address _manager) public {
        managerAddresses[_manager] = true;
    }

    function unassignManager(address _manager) public {
        managerAddresses[_manager] = false;
    }

    function isManager(address _manager) public view returns (bool) {
        return managerAddresses[_manager];
    }

    function assignVacationRequestManager(
        address _vacationRequest,
        address _manager
    ) public {
        vacationRequestManagerAddresses[_vacationRequest] = _manager;
    }

    function terminate() public {
        require(State == StateType.Provisioned, "State is not 'Provisioned'");
        require(msg.sender == mantainer, "Only owner can call this function");

        State = StateType.Terminated;

        // Transfer Eth to owner and terminate contract
        // selfdestruct(mantainer);
    }
}

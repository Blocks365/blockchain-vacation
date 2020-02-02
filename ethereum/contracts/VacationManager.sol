pragma solidity >=0.5.0 <0.7.0;

contract VacationManager {
    //Set of States
    enum StateType { Provisioned, Terminated }

    // List of addresses that can perform actions on this contract
    struct vacationRequestors {
        uint balance;
    }

    //List of properties
    StateType public State;
    address mantainer;
    mapping (address => uint) requestorsBalance;
    mapping(address => bool) public vacationMantainers; // Dates of vacation days appplying for

    //constructor
    constructor() public {
        mantainer = msg.sender;
    }
}
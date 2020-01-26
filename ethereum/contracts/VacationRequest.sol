pragma solidity >=0.4.25 <0.7.0;

contract VacationRequest
{
    //Set of States
    enum StateType { Request, Accepted, Rejected}

    //List of properties
    StateType public  State;
    address public  Requestor;
    address public  Responder;

    // Constructor
    constructor () public
    {
        Requestor = msg.sender;
        State = StateType.Request;
    }
}
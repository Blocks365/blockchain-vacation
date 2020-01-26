pragma solidity >=0.4.25 <0.7.0;

contract VacationRequest
{
    //Set of States
    enum StateType { Draft, PendingApproval, Accepted, Rejected, Cancelled}

    //List of properties
    StateType public  State;
    address public  Requestor; // IO
    address public  Responder; // IM

    // Constructor
    constructor () public
    {
        Requestor = msg.sender;
        State = StateType.Draft;
    }
}
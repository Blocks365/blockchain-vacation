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

    function cancel() public {
        if ( State == StateType.Accepted )
        {
            revert("Cannot cancel an accepted request");
        }

        State = StateType.Cancelled;
    }

    function reject() public
    {
        if ( State != StateType.PendingApproval )
        {
            revert("Only Status Pending Approval can be rejected");
        }

        if (Responder != msg.sender)
        {
            revert("Wrong sender");
        }

        State = StateType.Rejected;
    }
}
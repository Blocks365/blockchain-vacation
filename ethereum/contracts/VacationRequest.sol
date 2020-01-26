pragma solidity >=0.4.25 <0.7.0;
pragma experimental ABIEncoderV2;

contract VacationRequest {
    //Set of States
    enum StateType {Draft, PendingApproval, Accepted, Rejected, Cancelled}

    //date struct for easy coding
    struct VacationDay {
        uint8 day;
        uint8 month;
        uint16 year;
        uint8 amount;
    }

    //List of properties
    StateType public State;
    address public Requestor; // IO
    address public Responder; // IM
    mapping(uint16 => VacationDay) public VacationDays;
    uint16 public VacationDaysCount;
    //VacationDay[] public VacationDays;

    // Constructor
    constructor() public {
        Requestor = msg.sender;
        State = StateType.Draft;
        VacationDaysCount = 0;
    }

    function upsertDay(VacationDay memory day) public {

        //todo: amount should  be mod 4

        if(msg.sender != Requestor){
            revert("Only the owner can modify this request");
        }

        if (State == StateType.Draft || State == StateType.PendingApproval) {
            uint16 dayKey = (day.year * 12 * 31) + (day.month * 31) + day.day;
            
            if(VacationDays[dayKey].year == 0 ){
                VacationDaysCount++;
            }

            VacationDays[dayKey] = day;
            
        }
        else{
            revert("Cannot modify request");
        }
    }

    function removeDay(VacationDay memory day) public {
        if(msg.sender != Requestor){
            revert("Only the owner can modify this request");
        }

        if (State == StateType.Draft || State == StateType.PendingApproval) {
            uint16 dayKey = (day.year * 12 * 31) + (day.month * 31) + day.day;
            if(VacationDays[dayKey].year > 0 ){
                VacationDaysCount --;
            }
            delete VacationDays[dayKey];
        }
        else{
            revert("Cannot modify request");
        }
    }


    function cancel() public {
        if (State == StateType.Accepted) {
            revert("Cannot cancel an accepted request");
        }

        State = StateType.Cancelled;
    }

    function reject() public {
        if (State != StateType.PendingApproval) {
            revert("Only Status Pending Approval can be rejected");
        }

        if (Responder != msg.sender) {
            revert("Wrong sender");
        }

        State = StateType.Rejected;
    }
}

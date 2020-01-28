pragma solidity >=0.5.0 <0.7.0;
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
    StateType public state = StateType.Draft; // Initial State
    address public owner; // IO
    address public manager; // IM
    mapping(uint16 => VacationDay) public vacationDays; // Dates of vacation days appplying for
    uint16 public vacationDaysCount = 0; // Totoal number of vacation days for this request

    // Constructor
    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier onlyManager {
        require(msg.sender == manager, "Only manager can use this function.");
        _;
    }

    modifier onlyPendingApproval {
        require(
            state == StateType.PendingApproval,
            "Only Status Pending Approval can be rejected"
        );
        _;
    }

    modifier onlyDraftPending {
        require(
            state == StateType.Draft || state == StateType.PendingApproval,
            "Cannot modify request"
        );
        _;
    }

    function upsertDay(VacationDay memory _day)
        public
        onlyOwner
        onlyDraftPending
    {
        //todo: amount should  be mod 4
        uint16 dayKey = calcKey(_day);

        if (vacationDays[dayKey].year == 0) {
            vacationDaysCount++;
        }

        vacationDays[dayKey] = _day;
    }

    function removeDay(VacationDay memory _day)
        public
        onlyOwner
        onlyDraftPending
    {
        uint16 dayKey = calcKey(_day);

        if (vacationDays[dayKey].year > 0) {
            vacationDaysCount--;
        }

        delete vacationDays[dayKey];
    }

    function cancel() public onlyOwner {
        if (state == StateType.Accepted) {
            revert("Cannot cancel an accepted request");
        }

        state = StateType.Cancelled;
    }

    function reject() public onlyPendingApproval onlyManager {
        state = StateType.Rejected;
    }

    function calcKey(VacationDay memory _day) internal pure returns (uint16) {
        uint16 dayKey = (_day.year * 12 * 31) + (_day.month * 31) + _day.day;
        return dayKey;
    }
}

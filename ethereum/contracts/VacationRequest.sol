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

    //Events
    event RequestCreated(address indexed _owner);
    event RequestCancelled(address indexed _owner);

    event RequestApproved(address indexed _owner, address indexed _manager);
    event RequestRejected(address indexed _owner, address indexed _manager);

    // Constructor
    constructor() public {
        owner = msg.sender;
        emit RequestCreated(msg.sender);
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier onlyManager {
        require(msg.sender == manager, "Only manager can call this function.");
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

    modifier onlyDraft {
        require(state == StateType.Draft, "Cannot modify request");
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
        emit RequestCancelled(owner);
    }

    function reject() public onlyPendingApproval onlyManager {
        state = StateType.Rejected;
        emit RequestRejected(owner, manager);
    }

    function submit(address _manager) public onlyOwner onlyDraft {
        if (_manager == owner) {
            revert("Cannot submit request to yourself");
        }

        if (vacationDaysCount == 0) {
            revert("No vacation days added. Cannot submit empty request");
        }

        state = StateType.PendingApproval;
        manager = _manager;
    }

    function approve() public onlyPendingApproval onlyManager {
        state = StateType.Accepted;
        emit RequestApproved(owner, manager);
    }

    function calcKey(VacationDay memory _day) internal pure returns (uint16) {
        uint16 dayKey = (_day.year * 12 * 31) + (_day.month * 31) + _day.day;
        return dayKey;
    }
}

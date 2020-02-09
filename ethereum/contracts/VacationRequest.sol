pragma solidity >=0.5.0 <0.7.0;

import "./VacationManager.sol";

contract VacationRequest {
    //Set of States
    enum StateType {Draft, PendingApproval, Approved, Cancelled}

    //date struct for easy coding
    struct VacationDay {
        uint8 day; // Day of vacation 0 - 6
        uint8 month; // Month of year
        uint16 year; // Year
        uint256 amount; // amount in Hours (mod 4) and max is 8 (1 day)
    }

    //List of properties
    StateType public state = StateType.Draft; // Initial State
    address public owner; // IO
    address public manager; // IM
    address public parentContract; // PC
    mapping(uint16 => VacationDay) public vacationDays; // Dates of vacation days appplying for
    uint256 public vacationHoursCount = 0; // Totoal number of vacation hours for this request

    //Events
    event RequestCreated(address indexed _owner, uint256 _amount);
    event RequestSubmitted(address indexed _owner, address indexed _manager, uint256 _amount);
    event RequestCancelled(address indexed _owner, uint256 _amount, string _reason);
    event RequestApproved(address indexed _owner, address indexed _manager, uint256 _amount);
    event RequestRejected(address indexed _owner, address indexed _manager, uint256 _amount, string _reason);

    // Constructor
    constructor(address _parentContractAddress) public {
        parentContract = _parentContractAddress;
        owner = msg.sender;

        emit RequestCreated(owner, vacationHoursCount);
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier onlyManager {
        require(msg.sender == manager, "Only manager can call this function.");
        _;
    }

    modifier inState(StateType _state) {
        require(state == _state, "Invalid state.");
        _;
    }

    function upsertDay(uint8 _day, uint8 _month, uint16 _year, uint256 _amount)
        public
        onlyOwner
        inState(StateType.Draft)
    {
        //todo: amount should  be mod 4
        uint16 dayKey = calcKey(_day, _month, _year);

        vacationHoursCount -= vacationDays[dayKey].amount; //Substract current hour, if exists
        vacationHoursCount += _amount; //Add hours

        vacationDays[dayKey] = VacationDay({
            day: _day,
            month: _month,
            year: _year,
            amount: _amount
        });
    }

    function removeDay(uint8 _day, uint8 _month, uint16 _year)
        public
        onlyOwner
        inState(StateType.Draft)
    {
        uint16 dayKey = calcKey(_day, _month, _year);

        if (vacationDays[dayKey].year > 0) {
            vacationHoursCount -= vacationDays[dayKey].amount;
        }

        delete vacationDays[dayKey];
    }

    //Transformation Functions - The only 4 functions that can change state
    function submit(address _manager)
        public
        onlyOwner
        inState(StateType.Draft)
    {
        if (_manager == owner) {
            revert("Cannot submit request to yourself");
        }

        if (vacationHoursCount == 0) {
            revert("No vacation days added. Cannot submit empty request");
        }

        //Check the parent contract: VacationManager for balance and manager validation
        VacationManager vacationManager = VacationManager(parentContract);
        
        //Check owners balance
        if (!vacationManager.hasEnoughBalance(owner, vacationHoursCount)) {
            revert("Insufficient VTK token balace to submit the request");
        }

        //Check if _manager address exists in VacatinManager's manager list
        if (!vacationManager.isManager(_manager)) {
            revert("Managers address is not in the list of manager addresses");
        }

        state = StateType.PendingApproval;
        manager = _manager;
        emit RequestSubmitted(owner, manager, vacationHoursCount);
    }

    function cancel(string memory _reason)
        public
        onlyOwner
    {
        if (state == StateType.Approved) {
            revert("Cannot cancel an accepted request");
        }

        state = StateType.Cancelled;
        emit RequestCancelled(owner, vacationHoursCount, _reason);
    }

    function approve()
        public
        onlyManager
        inState(StateType.PendingApproval)
    {
        //Deduct the VTK token(s) from owners (Employees) balance
        VacationManager vacationManager = VacationManager(parentContract);

        //Check owners (Employees) balance before approval before approval
        if (!vacationManager.hasEnoughBalance(owner, vacationHoursCount)) {
            revert("The employee has insufficient VTK token funds");
        }

        vacationManager.burnVacationTokens(owner, vacationHoursCount);

        state = StateType.Approved;
        emit RequestApproved(owner, manager, vacationHoursCount);
    }

    function reject(string memory _reason)
        public
        onlyManager
        inState(StateType.PendingApproval)
    {
        state = StateType.Draft;
        emit RequestRejected(owner, manager, vacationHoursCount, _reason);
    }

    function calcKey(uint8 _day, uint8 _month, uint16 _year)
        internal
        pure
        returns (uint16)
    {
        uint16 dayKey = (_year * 12 * 31) + (_month * 31) + _day;
        return dayKey;
    }
}
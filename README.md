Vacation Request using Blockchain
==================================

Overview
---------

The Vacation contract application expresses a workflow between an employee requesting vacation,
a manager approving the request and an employer keeping track of vacation time.  
The state transition diagram below shows the interactions between the states in this workflow. 

Application Roles 
------------------

| Name  |  Description |
|------------|-------------------------------------------------------------------------------------------|
| Employee  |  The employee initializes the request by applying for a vacation period                              
| Manager |  The manager approves (or rejects) a request for vacation and a request to cancel a vacation request |


States 
-------

| Name  |  Description |
|----------|-------------------------------------------------------------------------------------------|
| Draft  | The state that occurs when a vacation request is being created by the employee or has been rejected by the manager.  |
| Pending Approval  | The state that occurs after a request has been submitted for approval by the employee.  |
| Approved  | The state that occurs after a request has been approved by the manager.  |
| Cancelled  | The state that occurs after a vacation request has been cancelled by the employee  |

Workflow Details
----------------

![state diagram of workflow](ethereum/media/Vacation%20SmartContract%20Transition%20Diagram.png)
 
- An instance of the Vacation Request application's workflow starts in the Draft state when an Employee creates a new request.  
- The instance transitions to the Pending Approval state when an Employee submits the request.
- If the manager approves the request, the instance goes to the Approved state
- If the manager rejects the request, the instance goes back to the Draft state
- While a contract is in Draft or Pending Approval state the employee can cancel the request

How to Run
----------

Create a local instance of Ganache by running the following command in the console:  
`npx ganache-cli`

Locate the \ethereum folder and run the tests using Truffle by executing the following command in the console:  
`npx truffle test`


Application Files
-----------------

|Description | Link|
|------------|-----|
|Solidity contract for a vacation request | [VacationRequest.sol](ethereum/contracts/VacationRequest.sol)|
|Tests for vacation request contract | [vacationRequest.js](ethereum/test/vacationRequest.js)|
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
| Employee  |  The employee initializes the request by applying for a vacation period                                 |
| Employer |  The employer allocates vacation hour tokens to the employee and keeps track of their usage | |
| Manager |  The manager approves (or rejects) a request for vacation and a request to cancel a vacation request |


States 
-------

| Name  |  Description |
|----------|-------------------------------------------------------------------------------------------|
| Requested  | The state that occurs when a vacation request has been made.  |
| Approved  | The state that occurs after a request has been approved by the manager.  |
| Rejected  | The state that occurs after a request has been denied by the manager.  |
| Consumed  | The state that occurs after a vacation hour has been used by the employee  |
| Refunded  | The state that occurs after an approved vacation hour has been returned to the employee  |
 

Workflow Details
----------------

![state diagram of workflow](media/5aba06dd9b98e017f7031946d0187fb7.png)
 
An instance of the Hello Blockchain application's workflow starts in the Request
state when a Requestor makes a request.  The instance transitions to the Respond
state when a Responder sends a response.  The instance transitions back again to
the Request state when the Requestor makes another request.  These transitions
continue for as long as a Requestor sends a request and a Responder sends a
response. 

Application Files
-----------------

[Resourcing.sol](ethereum\contracts\VacationRequest.sol)
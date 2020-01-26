const VacationRequest = artifacts.require("VacationRequest");

const PREFIX = "Returned error: VM Exception while processing transaction: ";

contract('VacationRequest', function(accounts) {
  var electionInstance;

  it("Rejects a request Invalid", async function() {
    const instance = await VacationRequest.deployed();
    try {
      await instance.reject();
      throw null;
    } catch(error) {  
      assert(error, "Expected an error but did not get one");
      
      var message = "revert Only Status Pending Approval can be rejected";
      assert(error.message.startsWith(PREFIX + message), "Expected " + message + ". But got " + error.message);
    }
  });
});
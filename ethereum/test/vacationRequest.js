const VacationRequest = artifacts.require("VacationRequest");

const PREFIX = "Returned error: VM Exception while processing transaction: ";

contract('VacationRequest', function(accounts) {

  it("Add day should increase count", async function() {
    const instance = await VacationRequest.new();
    await instance.upsertDay({year: 2020, month: 2, day: 20, amount: 8});
    const count = await instance.VacationDaysCount();
    assert.equal(count, 1)
  });
  
  it("Cannot Rejects a draft vacation request", async function() {
    const instance = await VacationRequest.new();
    try {
      await instance.reject();
      throw null;
    } catch(error) {  
      assert(error, "Expected an error but did not get one");
      
      var message = "revert Only Status Pending Approval can be rejected";
      assert(error.message.startsWith(PREFIX + message), "Expected " + message + ". But got " + error.message);
    }
  });

  it("Cannot reject a cancelled vacation request", async function() {
    const instance = await VacationRequest.new();
    try {
      await instance.cancel();
      await instance.reject();
      throw null;
    } catch(error) {  
      assert(error, "Expected an error but did not get one");
      
      var message = "revert Only Status Pending Approval can be rejected";
      assert(error.message.startsWith(PREFIX + message), "Expected " + message + ". But got " + error.message);
    }
  });


});
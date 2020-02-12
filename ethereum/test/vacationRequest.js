const VacationRequest = artifacts.require("VacationRequest");
const VacationManager = artifacts.require("VacationManager");
const PREFIX = "Returned error: VM Exception while processing transaction: ";

contract('VacationRequest', function (accounts) {

  it("Add day should increase count", async function () {
    const vmInstance = await VacationManager.new();
    const instance = await VacationRequest.new(vmInstance.address);

    await instance.upsertDay(20, 2, 2020, 8);
    assert.equal(await instance.vacationHoursCount(), 8)

    // await instance.upsertDay(21, 2, 2020, 8);
    // assert.equal(await instance.vacationHoursCount(), 2)

    // await instance.upsertDay(21, 2, 2020, 4);
    // assert.equal(await instance.vacationHoursCount(), 2)

    // await instance.upsertDay(22, 2, 2020, 8);
    // assert.equal(await instance.vacationHoursCount(), 3)

    // await instance.upsertDay(22, 2, 2020, 0);
    // assert.equal(await instance.vacationHoursCount(), 2)

    // await instance.removeDay(22, 2, 2020);
    // assert.equal(await instance.vacationHoursCount(), 2)

    // await instance.removeDay(21, 2, 2020);    
    // assert.equal(await instance.vacationHoursCount(), 1)
  });
/*
  it("Cannot Reject a draft vacation request", async function () {
    const vmInstance = await VacationManager.new();
    const instance = await VacationRequest.new(vmInstance);

    try {
      await instance.reject();
      throw null;
    } catch (error) {
      assert(error, "Expected an error but did not get one");
      var message = "revert Only Status Pending Approval can be rejected";
      assert(error.message.startsWith(PREFIX + message), "Expected " + message + ". But got " + error.message);
    }
  });

  it("Cannot reject a cancelled vacation request", async function () {
    const vmInstance = await VacationManager.new();
    const instance = await VacationRequest.new(vmInstance);

    try {
      await instance.cancel();
      await instance.reject();
      throw null;
    } catch (error) {
      assert(error, "Expected an error but did not get one");
      var message = "revert Only Status Pending Approval can be rejected";
      assert(error.message.startsWith(PREFIX + message), "Expected " + message + ". But got " + error.message);
    }
  });

  it("Cannot Approve, only manager can approve", async function () {
    const vmInstance = await VacationManager.new();
    const instance = await VacationRequest.new(vmInstance);

    try {
      await instance.upsertDay({ year: 2020, month: 2, day: 20, amount: 8 });
      await instance.submit('0x7E9F14fB93C172ce09D15186f1E4BC5aB2a522b0');
      await instance.approve();
    } catch (error) {
      assert(error, "Expected an error but did not get one");
      var message = "revert Only manager can call this function";
      assert(error.message.startsWith(PREFIX + message), "Expected " + message + ". But got " + error.message);
    }
  });

  it("Cannot Submit request to yourself", async function () {
    const vmInstance = await VacationManager.new();
    const instance = await VacationRequest.new(vmInstance);

    try {
      await instance.upsertDay({ year: 2020, month: 2, day: 20, amount: 8 });
      const owner = await instance.owner();
      await instance.submit(owner);
    } catch (error) {
      assert(error, "Expected an error but did not get one");
      var message = "revert Cannot submit request to yourself";
      assert(error.message.startsWith(PREFIX + message), "Expected " + message + ". But got " + error.message);
    }
  });
*/
});
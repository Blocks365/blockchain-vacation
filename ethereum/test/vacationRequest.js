const VacationRequest = artifacts.require("VacationRequest");

const PREFIX = "Returned error: VM Exception while processing transaction: ";

contract('VacationRequest', function (accounts) {

  it("Add day should increase count", async function () {
    const instance = await VacationRequest.new();

    await instance.upsertDay({ year: 2020, month: 2, day: 20, amount: 8 });
    assert.equal(await instance.vacationDaysCount(), 1)

    await instance.upsertDay({ year: 2020, month: 2, day: 21, amount: 8 });
    assert.equal(await instance.vacationDaysCount(), 2)

    await instance.upsertDay({ year: 2020, month: 2, day: 21, amount: 4 });
    assert.equal(await instance.vacationDaysCount(), 2)

    await instance.upsertDay({ year: 2020, month: 2, day: 22, amount: 8 });
    assert.equal(await instance.vacationDaysCount(), 3)

    await instance.removeDay({ year: 2020, month: 2, day: 22, amount: 0 });
    assert.equal(await instance.vacationDaysCount(), 2)

    await instance.removeDay({ year: 2020, month: 2, day: 22, amount: 0 });
    assert.equal(await instance.vacationDaysCount(), 2)

    await instance.removeDay({ year: 2020, month: 2, day: 21, amount: 0 });
    assert.equal(await instance.vacationDaysCount(), 1)

  });

  it("Cannot Reject a draft vacation request", async function () {
    const instance = await VacationRequest.new();
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
    const instance = await VacationRequest.new();
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
    const instance = await VacationRequest.new();
    try {
      await instance.upsertDay({ year: 2020, month: 2, day: 20, amount: 8 });
      await instance.submit('0x7E9F14fB93C172ce09D15186f1E4BC5aB2a522b0');
      await instance.approve();
    } catch (error) {
      assert(error, "Expected an error but did not get one");
      var message = "revert Only manager can use this function";
      assert(error.message.startsWith(PREFIX + message), "Expected " + message + ". But got " + error.message);
    }
  });

  it("Cannot Submit request to yourself", async function () {
    const instance = await VacationRequest.new();
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

});
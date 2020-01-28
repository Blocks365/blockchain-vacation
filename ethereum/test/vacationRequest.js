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

});
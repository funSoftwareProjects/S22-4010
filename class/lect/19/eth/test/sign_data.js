const SignData = artifacts.require("SignData");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("SignData", function (/* accounts */) {
  it("should assert true", async function () {
    await SignData.deployed();
    return assert.isTrue(true);
  });
});

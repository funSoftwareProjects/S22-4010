const Doc0 = artifacts.require("Doc0");

contract('Doc0', (accounts) => {
  it('should be deployed', async () => {
    const instance = await Doc0.deployed();
  });
});

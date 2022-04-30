  1: const VyperStorage = artifacts.require("VyperStorage");
  2: 
  3: contract("VyperStorage", () => {
  4:   it("...should store the value 89.", async () => {
  5:     const storage = await VyperStorage.deployed();
  6: 
  7:     // Set value of 89
  8:     await storage.set(89);
  9: 
 10:     // Get stored value
 11:     const storedData = await storage.get();
 12: 
 13:     assert.equal(storedData, 89, "The value 89 was not stored.");
 14:   });
 15: });

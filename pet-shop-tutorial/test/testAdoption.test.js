const Adoption = artifacts.require("Adoption");

contract("Adoption", (accounts) => {
  let adoption; //contract
  let expectedPetId;

  before(async () => {
    adoption = await Adoption.deployed();
  });

  describe("adopting a pet and retrieving account addresses", async () => {
    before("adopt a pet using account[0]", async () => {
      await adoption.adopt(1, { from: accounts[0] });
      expectedAdopter = accounts[0];
    });

    it("can fetch the address of an owner by pet id", async () => {
      const adopter = await adoption.adopters(1);
      assert.equal(
        adopter,
        expectedAdopter,
        "The owner of the adopted pet should be the first account"
      );
    });

    it("can fetch the collection of all pet owners' addresses", async () => {
      const adopters = await adoption.getAdopters();
      assert.equal(
        adopters[1],
        expectedAdopter,
        "The owner of the adopted pet should be in the collection"
      );
    });
  });
});

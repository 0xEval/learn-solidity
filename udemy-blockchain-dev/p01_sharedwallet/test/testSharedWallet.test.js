var chai = require("chai");
const BN = web3.utils.BN;
const chaiBN = require("chai-bn")(BN);
chai.use(chaiBN);

var chaiAsPromised = require("chai-as-promised");
chai.use(chaiAsPromised);

const expect = chai.expect;

const SharedWallet = artifacts.require("SharedWallet");

contract("SharedWallet", (accounts) => {
    let sharedwallet;

    before(async () => {
        // Wait for the instance of the SharedWallet contract to be deployed.
        sharedwallet = await SharedWallet.deployed();
    });

    describe("[*] Deposit & Withdrawal properties", async () => {
        it("should be able to receive a deposit", async () => {
            await web3.eth.sendTransaction({
                to: sharedwallet.address,
                from: accounts[0],
                value: web3.utils.toWei("3", "ether"),
            });
            const expectedBalance = web3.utils.toWei("3", "ether");
            const actualBalance = await web3.eth.getBalance(sharedwallet.address);
            expect(actualBalance).to.be.equals(expectedBalance);
        });

        it("owner or beneficiary can withdraw money from the wallet", async () => {
            const amount = web3.utils.toWei("1", "ether");
            await sharedwallet.withdraw(amount);
            const expectedBalance = web3.utils.toWei("2", "ether");
            const actualBalance = await web3.eth.getBalance(sharedwallet.address);
            expect(actualBalance).to.be.equals(expectedBalance);
        });
    });

    describe("[*] Beneficiaries properties", async () => {
        it("adding a beneficiary to the list", async () => {
            const accountId = accounts[2];
            const allowance = 1;
            await sharedwallet.addBeneficiary(accountId, allowance);

            const beneficiaryId = (await sharedwallet.beneficiaries(accountId)).id;
            const beneficiaryAllowance = (await sharedwallet.beneficiaries(accountId)).allowance;

            expect(beneficiaryId).to.be.equals(accountId);
            expect(beneficiaryAllowance).to.be.a.bignumber.equals(new BN(allowance));
        });

        it("changing a beneficiary's allowance", async () => {
            const accountId = accounts[2];
            const allowance = 2;
            await sharedwallet.changeAllowance(accountId, allowance);
            const beneficiaryAllowance = (await sharedwallet.beneficiaries(accountId)).allowance;

            expect(beneficiaryAllowance).to.be.a.bignumber.equals(new BN(allowance));
        });

        it("removing a beneficiary to the list", async () => {
            const accountId = accounts[2];
            await sharedwallet.removeBeneficiary(accountId);

            const beneficiaryId = (await sharedwallet.beneficiaries(accountId)).id;
            const beneficiaryAllowance = (await sharedwallet.beneficiaries(accountId)).allowance;

            expect(beneficiaryId).to.be.equals("0x0000000000000000000000000000000000000000");
            expect(beneficiaryAllowance).to.be.a.bignumber.equals(new BN(0));
        });
    });

    describe("[*] Ownership properties", async () => {
        it("ownership should be transferred to new address", async () => {
            await sharedwallet.transferOwnership(accounts[1], {
                from: accounts[0],
            });
            const newOwner = await sharedwallet.owner();
            expect(newOwner).to.equals(accounts[1]);
        });

        it("new owner should be in the beneficiary list", async () => {
            const owner = await sharedwallet.owner();
            const beneficiaryId = (await sharedwallet.beneficiaries(owner)).id;
            expect(beneficiaryId).to.equals(owner);
        });
    });
});

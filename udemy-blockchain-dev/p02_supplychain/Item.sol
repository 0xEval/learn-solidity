// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "./ItemManager.sol";

/**
* @author Eval (0xeval)
* @notice The contract defines an Item of the supply-chain. Only the contract ("item") address will
* be shared with clients to interact with. Upon receiving payment from the client, the contract
* will call its parent `ItemManager` to update its state in the supply-chain.
*/
contract Item {
    uint public priceInWei;
    uint public paidPrice;
    uint public index;

    ItemManager parentContract;

    constructor(ItemManager _parent, uint _priceInWei, uint _index) {
        parentContract = _parent;
        priceInWei = _priceInWei;
        index = _index;
    }

    receive() external payable {
        require(msg.value == priceInWei, "Item: no partial payment");
        require(paidPrice == 0, "Item: already paid");
        paidPrice += msg.value;
        (bool success,) = address(parentContract).call{value: msg.value}(abi.encodeWithSignature("triggerPayment(uint256)", msg.value));
        require(success = true, "Item: error when calling triggerPayment()");
    }
}
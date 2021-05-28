// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "./Item.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
* @author Eval (@0xeval)
* @notice Project #2 from the Ethereum blockchain developer course.
* Element of a Supply-chain system to handle automated dispatch and
* payment without middlemen.
*/

/**
* @notice Management contract that will control the states of the items in the supply-chain.
*/
contract ItemManager is Ownable {
    enum SupplyChainSteps {
        Created,
        Paid,
        Delivered
    }

    struct S_Item {
        Item item;
        ItemManager.SupplyChainSteps state;
        string identifier;
    }

    event SupplyChainStep(uint _index, uint _step);

    mapping (uint => S_Item) items;
    uint index;

    /**
    * @notice Creates a new item in the supply-chain.
    * @param _priceInWei price `uint` of the created item denominated in Wei.
    * @param _identifier identifier `string` representing the creation item.
    */
    function createItem(uint _priceInWei, string memory _identifier) public onlyOwner {
        items[index].item = new Item(this, _priceInWei, index);
        items[index].identifier = _identifier;
        items[index].state = ItemManager.SupplyChainSteps.Created;
        emit SupplyChainStep(index, uint(items[index].state));
        index++;
    }

    /**
    * @notice Trigger a payment for an item at a given index. The item is moved up further in the supply-chain.
    * @dev Only an Item contract can update its state in the supply-chain.
    * @param _index index `uint` of the item.
    */
    function triggerPayment(uint _index) public payable {
        Item item = items[_index].item;
        require(address(item) == msg.sender, "Only Items can update themselves");
        require(item.priceInWei() == msg.value, "ItemManager: !Full Payment");
        require(items[_index].state == ItemManager.SupplyChainSteps.Created, "ItemManager: wrong state");
        items[_index].state = ItemManager.SupplyChainSteps.Paid;
        emit SupplyChainStep(_index, uint(items[_index].state));
    }

    /**
    * @notice Trigger item delivery after payment has been received.
    * @param _index index `uint` of the item.
    */
    function triggerDelivery(uint _index) public onlyOwner {
        require(items[_index].state == ItemManager.SupplyChainSteps.Paid, "ItemManager: !payment received");
        items[_index].state = ItemManager.SupplyChainSteps.Delivered;
        emit SupplyChainStep(_index, uint(items[_index].state));
    }

    function transferOwnership(address _newOwner) public view override onlyOwner {
        revert("Ownership cannot be transfered");
    }
    function renounceOwnership() public view override onlyOwner {
        revert("Ownership cannot be renounced");
    }

}
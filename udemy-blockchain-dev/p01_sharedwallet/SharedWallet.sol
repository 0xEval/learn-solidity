//SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "./Beneficiary.sol";

/**
 * @author Eval (0xeval)
 * @title A simple shared wallet contract
 */

contract SharedWallet is Beneficiary {
    
        event DepositReceived(address _from, uint _amount);
        event Withdrawal(address _to, uint _amount);
        
        constructor() payable {
            addBeneficiary(msg.sender, type(uint256).max); 
        }

        receive() external payable {
            emit DepositReceived(msg.sender, msg.value);
        }

        /**
         * @dev Overrides OpenZeppelin's Ownable default function to prevent
         * owner-less contract.  
         */
        function renounceOwnership() public view override onlyOwner {
            revert("Cannot renounce ownership");
        }
        
        /**
         * @dev Overrides OpenZeppelin's ownership transfer function to update
         * Wallet's beneficiaries. Transfering ownership removes entirely the previous owner of the beneficiaries.
         */
        function transferOwnership(address _newOwner) public override onlyOwner {
            addBeneficiary(_newOwner, type(uint256).max);
            removeBeneficiary(owner());
            super.transferOwnership(_newOwner);
        }
        
        /**
         * Withdraw a given amount of money from the Wallet.
         * The max withdrawal amount is determined by the pre-defined allowance variable
         * associated to the address.
         * 
         * @param _amount the withdrawal amount
        */
        function withdraw(uint _amount) public onlyOwnerOrBeneficiary {
            require(beneficiaries[msg.sender].allowance >= _amount, "Withdrawal amount above allowance.");
            emit Withdrawal(msg.sender, _amount);
            beneficiaries[msg.sender].allowance -= _amount;
            payable(msg.sender).transfer(_amount);
        }
        
        /**
         * Withdraw the total balance stored in the wallet.
         * Must be called by _owner_.
         */
        function withdrawAll() public onlyOwner {
            emit Withdrawal(msg.sender, address(this).balance);
            withdraw(address(this).balance);
        }
        

}
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

abstract contract IKopiCoinERC20 {
    function name() public view virtual returns (string memory);

    function symbol() public view virtual returns (string memory);

    function decimals() public view virtual returns (uint8);

    function totalSupply() public view virtual returns (uint256);

    function balanceOf(address _owner) public view virtual returns (uint256 _balance);

    function transfer(address _recipient, uint256 _value) public virtual returns (bool _success);

    function transferFrom(
        address _spender,
        address _recipient,
        uint256 _value
    ) public virtual returns (bool success);

    function approve(address _spender, uint256 _value) public virtual returns (bool _success);

    function allowance(address _owner, address _spender)
        public
        view
        virtual
        returns (uint256 _remaining);

    event Transfer(address indexed _spender, address indexed _recipient, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

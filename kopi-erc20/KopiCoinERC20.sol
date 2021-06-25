// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IKopiCoinERC20.sol";

contract KopiCoinERC20 is IKopiCoinERC20 {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    string private _name;
    string private _symbol;

    uint256 private _totalSupply;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _owner) public view virtual override returns (uint256 _balance) {
        return _balances[_owner];
    }

    function transfer(address _recipient, uint256 _amount)
        public
        virtual
        override
        returns (bool _success)
    {
        _transfer(msg.sender, _recipient, _amount);
        return true;
    }

    /**
     * @dev Transfers `_amount` of tokens from `_spender` to `_recipient` within allowances.
     * `_amount is then deduced from the caller's allowance.
     *
     * Requirements:
     * - `_spender` and `_recipient` cannot be the zero address.
     * - `_spender` must have a balance of at least `_amount`.
     * - the caller must have allowance for ``_spender``'s tokens of at least `_amount`.
     *
     * @param _spender the address from which the transfer starts.
     * @param _recipient the address receiving the transfer.
     * @param _amount the amount to be transfered.
     * @return _success boolean value indicating whether the operation succeeded.
     */
    function transferFrom(
        address _spender,
        address _recipient,
        uint256 _amount
    ) public virtual override returns (bool _success) {
        _transfer(_spender, _recipient, _amount);

        uint256 currentAllowance = _allowances[_spender][msg.sender];
        require(currentAllowance >= _amount, "ERC20: transfer amount exceeds allowance");

        approve(_spender, currentAllowance - _amount);

        return true;
    }

    /**
     * @dev Sets `_value` as the maximum allowance of `_spender` over the caller's token.
     *
     * @param _spender the address which is given allowance.
     * @param _value the allowance amount.
     * @return _success boolean value indicating whether the operation succeeded.
     */
    function approve(address _spender, uint256 _value)
        public
        virtual
        override
        returns (bool _success)
    {
        require(msg.sender != address(0), "ERC20: approve from the zero address");
        require(_spender != address(0), "ERC20: approve to the zero address");

        _allowances[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    /**
     * @dev Returns the remaining allowance of `_spender` over `_owner` token.
     *
     * @param _owner the address of the token owner.
     * @param _spender the address of the allowed spender.
     * @return _remaining number of tokens that the spender will be allowed to spend on behalf of owner.
     */
    function allowance(address _owner, address _spender)
        public
        view
        virtual
        override
        returns (uint256 _remaining)
    {
        return _allowances[_owner][_spender];
    }

    /**
     * @dev Transfers `amount` of tokens from `sender` to `recipient`.
     *
     * Requirements:
     *  - `_spender` cannot be the zero address.
     *  - `_recipient` cannot be the zero address.
     *  - `_spender` must have sufficient balance for the transaction.
     *
     * @param _spender address of the transaction sender.
     * @param _recipient address of the transaction recipient.
     * @param _amount transfer amount.
     */
    function _transfer(
        address _spender,
        address _recipient,
        uint256 _amount
    ) internal {
        require(_spender != address(0), "ERC20: transfer from the zero address");
        require(_recipient != address(0), "ERC20: transfer to the zero address");

        uint256 spenderBalance = _balances[_spender];
        require(spenderBalance >= _amount, "ERC20: transfer amount exceed balance");

        // Underflow/overflow protection is native to solc >= 0.8.0
        _balances[_spender] = spenderBalance - _amount;
        _balances[_recipient] += _amount;

        emit Transfer(_spender, _recipient, _amount);
    }
}

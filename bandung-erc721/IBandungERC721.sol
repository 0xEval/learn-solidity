// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @title Bandung NFT Implementation (ERC721 Token Standard)
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 * Note: Every ERC-721 compliant contract must implement the ERC721 and ERC165 interfaces.
 */

interface ERC165 {
    /**
     * @notice Query if a contract implements an interface
     * @dev Interface identification is specified in ERC-165. This function uses less than 30,000 gas.
     * @param interfaceID The interface identifier, as specified in ERC-165
     * @return `true` if the contract implements `interfaceID` and `interfaceID` is not 0xffffffff, `false` otherwise
     */
    function supportsInterface(bytes4 interfaceID) external view returns (bool);
}

interface IBandungERC721 is ERC165 {
    /**
     * @dev Emitted when `_tokenId` is transferred from `_from` to `_to`.
     * This event emits when NFTs are created (`_from` == 0) and destroyed (`_to` == 0).
     *  Exception: during contract creation, any number of NFTs may be created and assigned
     *  without emitting {Transfer}. At the time of any transfer, the approved address for that NFT (if any) is reset to none.
     */
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);

    /**
     * @dev Emitted when `_owner` has approved `_approved` to manage the `_tokenId` token.
     * The zero address indicates there is no approved address.
     * When a {Transfer} event emits, this also indicates that the approved address for that NFT (if any) is reset to none.
     */
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

    /**
     * @dev Emitted when `_owner` has approved/disapproved `_operator` to manage the all of its assets.
     */
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    /**
     * @dev Returns the number of tokens in `_owner`'s account.
     */
    function balanceOf(address _owner) external view returns (uint256);

    /**
     * @dev Returns the owner of `_tokendId` token.
     */
    function ownerOf(uint256 _tokenId) external view returns (address);

    /**
     * @dev Safely transfers the `_tokenId` token from `_from` to `_to`, ensuring that
     *
     * Requirements:
     *
     *  - `msg.senger` must be the current owner, an authorized operator, or the approved address of this NFT.
     *  - `_from` cannot be the zero address.
     *  - `_to` cannot be the zero address.
     *  - `_tokenId` must be a valid NFT, and be owned by `_from`.
     *  - If the caller is not `_from`, it must have been allowed to move this token by either {approve} or {setApproveForAll}.
     *  -
     *
     *  Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes calldata data
    ) external payable;

    /**
     * @dev Works exactly the same as {safeTransferFrom} with an extra param. Except this function just sets data to "".
     */
    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable;

    /**
     * @dev Transfers `_tokenId` token from `_from` to `_to`.
     *
     * WARNING: The caller is responsible to confirm that `_to` is capable of received NFTs of else they may be permanently lost. Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     *
     * Requirements:
     *
     *  - `msg.senger` must be the current owner, an authorized operator, or the approved address of this NFT.
     * - `_from` cannot be the zero address.
     * - `_to` cannot be the zero address.
     * - `_tokenId` is a valid NFT.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable;

    /**
     * @dev Gives permission to `_approved` to transfer `_tokenId` token to another account.
     * The approval is cleared whenever the token is transferred.
     * The zero address indicates there is no approved address.
     *
     * Requirements:
     *
     *  - `msg.senger` must be the current owner or an authorized operator of this NFT.
     *  - `_tokenId` must be a valid NTF.
     *
     * Emits an {Approval} event.
     */
    function approve(address _approved, uint256 _tokenId) external payable;

    /**
     * @dev Gives/revokes permission to the third party `_operator` to manage all of `msg.sender`'s assets.
     *
     * Requirements:
     *
     *  - `_operator` cannot be `msg.sender`.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address _operator, bool _approved) external;

    /**
     * @dev Returns if the account approved for `_tokenId` token.
     */
    function getApproved(uint256 _tokenId) external view returns (address);

    /**
     * @dev Returns if the `_operator` is allowed to manage all of `_owner`'s assets.
     */
    function isApprovedForAll(address _owner, address _operator) external view returns (bool);
}

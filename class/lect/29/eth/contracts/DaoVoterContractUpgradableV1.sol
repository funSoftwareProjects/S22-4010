// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <=0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract DaoVoterContractUpgradableV1 is ERC721 {

    mapping (uint256 => uint256) public tokenIdToPrice;
    string private baseURI;
	int public nMinted;		// # of tokens minted.
	address payable owner;

    event NFTPurchased(uint256 indexed NFT, address seller, address buyer, uint256 price);
    event NFTAvailable(uint256 indexed NFT, uint256 price);
    event NFTRemoved(uint256 indexed NFT);

    event VoterRegistered(uint256 indexed NFT);
    event ProposalRegistered(uint256 indexed NFT);

    constructor() ERC721("Wyoming NFT", "WYNFT") {
		owner = payable(msg.sender);
    }

	modifier onlyOwner() {
		require( msg.sender == owner, "Sender not authorized.");
		// Do not forget the "_;"! It will be replaced by the actual function
		// body when the modifier is used.
		_;
	}

	function initialize(string memory tokenURI) public onlyOwner() {
		baseURI = tokenURI;
		nMinted = 0;
	}

	// Make `_newOwner` the new owner of this contract.
	function changeOwner(address payable _newOwner) public onlyOwner() {
		owner = _newOwner;
	}

	function mintNFT(uint256 _tokenNFT) public returns (uint256) {
		uint256 newItemId = _tokenNFT;
		_safeMint(msg.sender, newItemId);
		nMinted += 1;
		return newItemId;
   }

	function registerVoter(uint256 _tokenNFT) public returns (uint256) {
		uint256 newItemId = _tokenNFT;
		_safeMint(msg.sender, newItemId);
		nMinted += 1;
		emit VoterRegistered(newItemId);
		return newItemId;
   }

	function createProposal(uint256 _tokenNFT) public returns (uint256) {
		uint256 newItemId = _tokenNFT;
		_safeMint(msg.sender, newItemId);
		nMinted += 1;
		ProposalRegistered(newItemId);
		return newItemId;
   }

    // function balanceOf(address owner) public view virtual override returns (uint256) {

    function _baseURI() internal view override returns (string memory) {
		return baseURI;
	}

	function allowBuy(uint256 _tokenId, uint256 _price) external {
		require(msg.sender == ownerOf(_tokenId), 'Not owner of this token');
		require(_price > 0, 'Price must be larger than zero');
		tokenIdToPrice[_tokenId] = _price;

    	emit NFTAvailable(_tokenId, _price);
	}

	function disallowBuy(uint256 _tokenId) external {
		require(msg.sender == ownerOf(_tokenId), 'Not owner of this token');
		tokenIdToPrice[_tokenId] = 0;

    	emit NFTRemoved(_tokenId);
	}
	
	function buy(uint256 _tokenId) external payable {
		uint256 price = tokenIdToPrice[_tokenId];
		require(price > 0, 'This token is not for sale');
		require(msg.value == price, 'Incorrect value');
		
		address seller = ownerOf(_tokenId);
		_transfer(seller, msg.sender, _tokenId);
		tokenIdToPrice[_tokenId] = 0; // not for sale anymore
		payable(seller).transfer(msg.value); // send the ETH to the seller

		emit NFTPurchased(_tokenId, seller, msg.sender, msg.value);
	}

	// This function is called for all messages sent to
	// this contract, except plain Ether transfers
	// (there is no other function except the receive function).
	// Any call with non-empty calldata to this contract will execute
	// the fallback function (even if Ether is sent along with the call).
	fallback() external payable {}

	// This function is called for plain Ether transfers, i.e.
	// for every call with empty calldata.
	receive() external payable {}

	function withdraw( uint256 _amount ) public onlyOwner() {
		owner.transfer(_amount);
	}

	// destroy the contract and reclaim the leftover funds.
    function kill() public onlyOwner() {
		//	Calling selfdestruct(address) sends all of the contract's current balance to address.
        selfdestruct(payable(msg.sender));
    }
}

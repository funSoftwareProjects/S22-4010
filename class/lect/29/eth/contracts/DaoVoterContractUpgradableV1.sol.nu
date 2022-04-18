  1: // SPDX-License-Identifier: MIT
  2: pragma solidity >=0.6.0 <=0.9.0;
  3: 
  4: import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
  5: 
  6: contract DaoVoterContractUpgradableV1 is ERC721 {
  7: 
  8:     mapping (uint256 => uint256) public tokenIdToPrice;
  9:     string private baseURI;
 10:     int public nMinted;        // # of tokens minted.
 11:     address payable owner;
 12: 
 13:     event NFTPurchased(uint256 indexed NFT, address seller, address buyer, uint256 price);
 14:     event NFTAvailable(uint256 indexed NFT, uint256 price);
 15:     event NFTRemoved(uint256 indexed NFT);
 16: 
 17:     event VoterRegistered(uint256 indexed NFT);
 18:     event ProposalRegistered(uint256 indexed NFT);
 19: 
 20:     constructor() ERC721("Wyoming NFT", "WYNFT") {
 21:         owner = payable(msg.sender);
 22:     }
 23: 
 24:     modifier onlyOwner() {
 25:         require( msg.sender == owner, "Sender not authorized.");
 26:         // Do not forget the "_;"! It will be replaced by the actual function
 27:         // body when the modifier is used.
 28:         _;
 29:     }
 30: 
 31:     function initialize(string memory tokenURI) public onlyOwner() {
 32:         baseURI = tokenURI;
 33:         nMinted = 0;
 34:     }
 35: 
 36:     // Make `_newOwner` the new owner of this contract.
 37:     function changeOwner(address payable _newOwner) public onlyOwner() {
 38:         owner = _newOwner;
 39:     }
 40: 
 41:     function mintNFT(uint256 _tokenNFT) public returns (uint256) {
 42:         uint256 newItemId = _tokenNFT;
 43:         _safeMint(msg.sender, newItemId);
 44:         nMinted += 1;
 45:         return newItemId;
 46:    }
 47: 
 48:     function registerVoter(uint256 _tokenNFT) public returns (uint256) {
 49:         uint256 newItemId = _tokenNFT;
 50:         _safeMint(msg.sender, newItemId);
 51:         nMinted += 1;
 52:         emit VoterRegistered(newItemId);
 53:         return newItemId;
 54:    }
 55: 
 56:     function createProposal(uint256 _tokenNFT) public returns (uint256) {
 57:         uint256 newItemId = _tokenNFT;
 58:         _safeMint(msg.sender, newItemId);
 59:         nMinted += 1;
 60:         ProposalRegistered(newItemId);
 61:         return newItemId;
 62:    }
 63: 
 64:     // function balanceOf(address owner) public view virtual override returns (uint256) {
 65: 
 66:     function _baseURI() internal view override returns (string memory) {
 67:         return baseURI;
 68:     }
 69: 
 70:     function allowBuy(uint256 _tokenId, uint256 _price) external {
 71:         require(msg.sender == ownerOf(_tokenId), 'Not owner of this token');
 72:         require(_price > 0, 'Price must be larger than zero');
 73:         tokenIdToPrice[_tokenId] = _price;
 74: 
 75:         emit NFTAvailable(_tokenId, _price);
 76:     }
 77: 
 78:     function disallowBuy(uint256 _tokenId) external {
 79:         require(msg.sender == ownerOf(_tokenId), 'Not owner of this token');
 80:         tokenIdToPrice[_tokenId] = 0;
 81: 
 82:         emit NFTRemoved(_tokenId);
 83:     }
 84:     
 85:     function buy(uint256 _tokenId) external payable {
 86:         uint256 price = tokenIdToPrice[_tokenId];
 87:         require(price > 0, 'This token is not for sale');
 88:         require(msg.value == price, 'Incorrect value');
 89:         
 90:         address seller = ownerOf(_tokenId);
 91:         _transfer(seller, msg.sender, _tokenId);
 92:         tokenIdToPrice[_tokenId] = 0; // not for sale anymore
 93:         payable(seller).transfer(msg.value); // send the ETH to the seller
 94: 
 95:         emit NFTPurchased(_tokenId, seller, msg.sender, msg.value);
 96:     }
 97: 
 98:     // This function is called for all messages sent to
 99:     // this contract, except plain Ether transfers
100:     // (there is no other function except the receive function).
101:     // Any call with non-empty calldata to this contract will execute
102:     // the fallback function (even if Ether is sent along with the call).
103:     fallback() external payable {}
104: 
105:     // This function is called for plain Ether transfers, i.e.
106:     // for every call with empty calldata.
107:     receive() external payable {}
108: 
109:     function withdraw( uint256 _amount ) public onlyOwner() {
110:         owner.transfer(_amount);
111:     }
112: 
113:     // destroy the contract and reclaim the leftover funds.
114:     function kill() public onlyOwner() {
115:         //    Calling selfdestruct(address) sends all of the contract's current balance to address.
116:         selfdestruct(payable(msg.sender));
117:     }
118: }

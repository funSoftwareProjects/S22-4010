  1: // SPDX-License-Identifier: MIT
  2: pragma solidity >=0.4.22 <0.9.0;
  3: 
  4: import "zeppelin-solidity/contracts/ownership/Ownable.sol";
  5: 
  6: contract SignData is Ownable {
  7: 
  8:     address payable owner_address;
  9:     uint256 private minPayment;
 10: 
 11:     mapping(uint256 => mapping(uint256 => bytes32)) dData;
 12:     mapping(uint256 => mapping(uint256 => address)) dOowner;
 13:     mapping(uint256 => mapping(uint256 => bool)) dMayChange;
 14:     event DataChange(uint256 App, uint256 Name, bytes32 Value, address By);
 15: 
 16:     event ReceivedFunds(address sender, uint256 value, uint256 application, uint256 payFor);
 17:     event Withdrawn(address to, uint256 amount);
 18: 
 19:     constructor() public {
 20:         owner_address = msg.sender;
 21:         minPayment = 1000;
 22:     }
 23: 
 24:     modifier needMinPayment {
 25:         require(msg.value >= minPayment, "Insufficient payment.  Must send more than minPayment.");
 26:         _;
 27:     }
 28: 
 29:     function init() public {
 30:         minPayment = 1000;
 31:     }
 32: 
 33:     function setMinPayment( uint256 _minPayment ) public onlyOwner {
 34:         minPayment = _minPayment;
 35:     }
 36: 
 37:     function getMinPayment() public onlyOwner view returns ( uint256 ) {
 38:         return ( minPayment );
 39:     }
 40: 
 41:     // ----------------------------------------------------------------------------------------------------------------------
 42: 
 43:     /**
 44:      * @dev TODO if the data is empty, or if the msg.sender is the original createor of the data:
 45:      *      then : save the msg.sender into dOwner, save the data into dData
 46:      *             create a DataChange event.
 47:      *      else : revert an error.
 48:      */
 49:     function setData ( uint256 _app, uint256 _name, bytes32 _data ) public needMinPayment payable {
 50:         address tmp = dOowner[_app][_name];
 51:         bool mayChange = dMayChange[_app][_name];
 52:         if ( tmp == msg.sender && !mayChange ) {
 53:             revert("Data is not changable");
 54:         }
 55:         if ( tmp != msg.sender ) {
 56:             revert("Not owner of data.");
 57:         }
 58:         dData[_app][_name] = _data;
 59:         emit DataChange(_app, _name, _data, msg.sender);
 60:         emit ReceivedFunds(msg.sender, msg.value, _app, _name);
 61:     }
 62: 
 63:     /**
 64:      * @dev TODO if the data is empty, or if the msg.sender is the original createor of the data:
 65:      *      then : save the msg.sender into dOwner, save the data into dData
 66:      *             create a DataChange event.
 67:      *      else : revert an error.
 68:      */
 69:     function createSignature ( uint256 _app, uint256 _name, bytes32 _data, bool _mayChange ) public needMinPayment payable {
 70:         if ( _name == 0 ) {
 71:             revert("Invalid _name with value of 0");
 72:         }
 73:         if ( _app == 0 ) {
 74:             revert("Invalid _app with value of 0");
 75:         }
 76:         if ( msg.sender == address(0) ) {
 77:             revert("Invalid msg sender");
 78:         }
 79:         address tmp = dOowner[_app][_name];
 80:         if ( tmp != address(0) ) {    // Check that it has not already been created, 0 retuned if not exists
 81:             dOowner[_app][_name] = msg.sender;
 82:             dData[_app][_name] = _data;
 83:             dMayChange[_app][_name] = _mayChange;
 84:             emit DataChange(_app, _name, _data, msg.sender);
 85:             emit ReceivedFunds(msg.sender, msg.value, _app, _name);
 86:         } else {
 87:             revert("Not owner of data.");
 88:         }
 89:     }
 90: 
 91:     /**
 92:      * @dev TODO return the data by looking up _app and _name in dData.
 93:      */
 94:     function getSignature ( uint256 _app, uint256 _name ) public view returns ( bytes32 ) {
 95:         return ( dData[_app][_name] );
 96:     }
 97: 
 98:     // ----------------------------------------------------------------------------------------------------------------------
 99: 
100:     /**
101:      * @dev payable fallback
102:      */
103:     function () external payable {
104:         emit ReceivedFunds(msg.sender, msg.value, 0, 1);
105:     }
106: 
107:     /**
108:      * @dev genReceiveFunds - generate a receive funds event.
109:      */
110:     function genReceivedFunds ( uint256 application, uint256 payFor ) public payable {
111:         emit ReceivedFunds(msg.sender, msg.value, application, payFor);
112:     }
113: 
114:     /**
115:      * @dev Withdraw contract value amount.
116:      */
117:     function withdraw( uint256 amount ) public onlyOwner returns(bool) {
118:         address(owner_address).transfer(amount);
119:         // owner_address.send(amount);
120:         emit Withdrawn(owner_address, amount);
121:         return true;
122:     }
123: 
124:     /**
125:      * @dev How much do I got?
126:      */
127:     function getBalanceContract() public view onlyOwner returns(uint256){
128:         return address(this).balance;
129:     }
130: 
131:     /**
132:      * @dev For futute to end the contract, take the value.
133:      */
134:     function kill() public onlyOwner {
135:         emit Withdrawn(owner_address, address(this).balance);
136:         selfdestruct(owner_address);
137:     }
138: }



<style>
.pagebreak { page-break-before: always; }
.half { height: 200px; }
</style>
<style>
.pagebreak { page-break-before: always; }
.half { height: 200px; }
.markdown-body {
	font-size: 12px;
}
.markdown-body td {
	font-size: 12px;
}
</style>


Lecture 17 - Hash / Attestation Example
==

## Document Attestation Contract

```
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
 14:     mapping(uint256 => mapping(uint256 => bool)) dExists;
 15:     mapping(uint256 => mapping(uint256 => uint256)) dWhen;
 16:     event DataChange(uint256 App, uint256 Name, bytes32 Value, address By);
 17: 
 18:     event ReceivedFunds(address sender, uint256 value, uint256 application, uint256 payFor);
 19:     event Withdrawn(address to, uint256 amount);
 20: 
 21:     constructor() public {
 22:         owner_address = msg.sender;
 23:         minPayment = 1000;
 24:     }
 25: 
 26:     modifier needMinPayment {
 27:         require(msg.value >= minPayment, "Insufficient payment.  Must send more than minPayment.");
 28:         _;
 29:     }
 30: 
 31:     function init() public {
 32:         minPayment = 1000;
 33:     }
 34: 
 35:     function setMinPayment( uint256 _minPayment ) public onlyOwner {
 36:         minPayment = _minPayment;
 37:     }
 38: 
 39:     function getMinPayment() public onlyOwner view returns ( uint256 ) {
 40:         return ( minPayment );
 41:     }
 42: 
 43:     // ----------------------------------------------------------------------------------------------------------------------
 44: 
 45:     /**
 46:      * @dev Update an existing set of data if the data was created with permissions to be updated.
 47:      */
 48:     function setHash ( uint256 _app, uint256 _name, bytes32 _data ) public needMinPayment payable {
 49:         address tmp = dOowner[_app][_name];
 50:         bool mayChange = dMayChange[_app][_name];
 51:         if ( tmp == msg.sender && !mayChange ) {
 52:             revert("Data is not changable");
 53:         }
 54:         if ( tmp != msg.sender ) {
 55:             revert("Not owner of data.");
 56:         }
 57:         bool ex = dExists[_app][_name];
 58:         if ( !ex ) {
 59:             revert("No data found." );
 60:         }
 61:         dData[_app][_name] = _data;
 62:         dWhen[_app][_name] = now;
 63:         emit DataChange(_app, _name, _data, msg.sender);
 64:         emit ReceivedFunds(msg.sender, msg.value, _app, _name);
 65:     }
 66: 
 67:     /**
 68:      * @dev Create a new hash and save it's relevant data.  Check that this is a new set of data.
 69:      */
 70:     function createHash ( uint256 _app, uint256 _name, bytes32 _data, bool _mayChange ) public needMinPayment payable {
 71:         if ( _name == 0 ) {
 72:             revert("Invalid _name with value of 0");
 73:         }
 74:         if ( _app == 0 ) {
 75:             revert("Invalid _app with value of 0");
 76:         }
 77:         if ( msg.sender == address(0) ) {
 78:             revert("Invalid msg sender");
 79:         }
 80:         bool ex = dExists[_app][_name];
 81:         if ( ex ) {
 82:             revert("Data already exists for this app and name.");
 83:         }
 84:         dOowner[_app][_name] = msg.sender;
 85:         dData[_app][_name] = _data;
 86:         dMayChange[_app][_name] = _mayChange;
 87:         dWhen[_app][_name] = now;
 88:         dExists[_app][_name] = true;
 89:         emit DataChange(_app, _name, _data, msg.sender);
 90:         emit ReceivedFunds(msg.sender, msg.value, _app, _name);
 91:     }
 92: 
 93:     /**
 94:      * @dev return the data by looking up _app and _name in dData.  Return both the hash and the date when it was stored..
 95:      *      Return 0's if no data exits.
 96:      */
 97:     function getHash ( uint256 _app, uint256 _name ) public view returns ( bytes32, uint256 ) {
 98:         bool ex = dExists[_app][_name];
 99:         if ( !ex ) {
100:             return ( 0, 0 );
101:         }
102:         return ( dData[_app][_name], dWhen[_app][_name] );
103:     }
104: 
105:     // ----------------------------------------------------------------------------------------------------------------------
106: 
107:     /**
108:      * @dev payable fallback
109:      */
110:     function () external payable {
111:         emit ReceivedFunds(msg.sender, msg.value, 0, 1);
112:     }
113: 
114:     /**
115:      * @dev genReceiveFunds - generate a receive funds event.
116:      */
117:     function genReceivedFunds ( uint256 application, uint256 payFor ) public payable {
118:         emit ReceivedFunds(msg.sender, msg.value, application, payFor);
119:     }
120: 
121:     /**
122:      * @dev Withdraw contract value amount.
123:      */
124:     function withdraw( uint256 amount ) public onlyOwner returns(bool) {
125:         address(owner_address).transfer(amount);
126:         // owner_address.send(amount);
127:         emit Withdrawn(owner_address, amount);
128:         return true;
129:     }
130: 
131:     /**
132:      * @dev How much do I got?
133:      */
134:     function getBalanceContract() public view onlyOwner returns(uint256){
135:         return address(this).balance;
136:     }
137: 
138:     /**
139:      * @dev For futute to end the contract, take the value.
140:      */
141:     function kill() public onlyOwner {
142:         emit Withdrawn(owner_address, address(this).balance);
143:         selfdestruct(owner_address);
144:     }
145: }

```

and the test

```
  1: const SignData = artifacts.require("SignData");
  2: 
  3: /*
  4:  * Ethereum client
  5:  */
  6: contract("SignData", function (accounts) {
  7:     it("should Create contract and sign data", async function () {
  8:         let sd = await SignData.deployed();
  9: 
 10:         let account0 = accounts[0];
 11:         let account1 = accounts[1];
 12:         let amount = 1000;
 13:         var ok = true;
 14: 
 15:         //function createSignature ( uint256 _app, uint256 _name, bytes32 _data, bool _mayChange ) public needMinPayment payable {
 16:         var tx = await sd.createHash( 10, 4, "0x0213e3852b8afeb08929a0f448f2f693b0fc3ebe", true, {"value":amount} );
 17:         // console.log ( tx );
 18: 
 19:         // function setData ( uint256 _app, uint256 _name, bytes32 _data ) public needMinPayment payable {
 20:         tx = await sd.setHash( 10, 4, "0x11111111111afeb08929a0f448f2f693b0fc3ebe", {"value":amount} );
 21:         // console.log ( "tx after setHash", tx );
 22: 
 23:         var x, hh, ww;
 24:         x = await sd.getHash ( 10, 4 );
 25:         hh = x[0];
 26:         ww = x[1].toNumber();
 27: 
 28: 
 29:         // console.log ( x, "hh=", hh, "ww=", ww );
 30:         let expect = "0x11111111111afeb08929a0f448f2f693b0fc3ebe000000000000000000000000";
 31:         assert.equal(hh, expect, "Invalid stored hash");
 32:         if ( hh != expect ) {
 33:             ok = false;
 34:         }
 35: 
 36:         var today = new Date();
 37:         var sDate = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate();
 38: 
 39:         var timestamp = ww * 1000;    // Convert from number of seconds (Eth) since 1970 to mili-seconds
 40:         var date = new Date(timestamp);
 41:         // console.log(date.getDate())
 42:         // console.log(date, sDate) // 2022-03-04T14:40:57.000Z
 43:         var gDate = date.getFullYear()+'-'+(date.getMonth()+1)+'-'+date.getDate();
 44:         assert.equal(sDate,gDate, "Invalid date for this hash.");
 45:         if ( sDate != gDate ) {
 46:             ok = false;
 47:         }
 48: 
 49:         return assert.isTrue(ok);
 50:     });
 51: });

```


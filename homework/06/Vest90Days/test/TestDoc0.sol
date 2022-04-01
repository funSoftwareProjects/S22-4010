pragma solidity >=0.4.25 <0.9.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Doc0.sol";

contract TestDoc0 {

	Doc0 doc = new Doc0();

	function testIsValidNoterizer() public {
		address address1 = address(0);
		address address2 = address(1);

		doc.setNoterizer(address1);

		Assert.equal(doc.isValidNoterizer(address1), true, "Should be noterizer");
		Assert.equal(doc.isValidNoterizer(address2), false, "Should not be noterizer");
	}

    function testNewDocument() public {
        string memory name = "docName";
        bytes32 infoHash = "infohash";
        string memory info = "document info";

        doc.newDocument(name, infoHash, info);

        Assert.equal(doc.nDocuments(), 1, "Should be a single document");
        Assert.equal(doc.ownerOfDocument(infoHash), address(this), "Owner should be msg.sender");
        Assert.equal(doc.getDocName(0), name, "First and only document should have name that was set");
        Assert.equal(doc.getDocInfoHash(0), infoHash, "Should have infoHash that was set");
        Assert.equal(doc.getDocInfo(0), info, "Should have info that was set");
    }

	function testGetPayment() public {
		// Doc0 doc0 = Doc0(address(this));
		Doc0 doc0 = Doc0(DeployedAddresses.Doc0());

		uint expected = 123;
		doc0.setPayment(expected);

		Assert.equal(doc0.getPayment(), expected, "Payment should be 123");
		doc0.setPayment(0);
	}

}

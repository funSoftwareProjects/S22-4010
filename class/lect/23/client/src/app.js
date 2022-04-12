// getWeb3 connects to MetaMask with the local server and starts the web3 library.
// Function from MetaMask Documenation.
const getWeb3 = () => {
	return new Promise((resolve, reject) => {
		window.addEventListener("load", async () => {
			if (window.ethereum) {
				const web3 = new Web3(window.ethereum);
				try {
					// Get the users accounts - request permission to use them in MetaMask
					await window.ethereum.request({ method: "eth_requestAccounts" });
					resolve(web3);
				} catch (error) {
					reject(error);
				}
			} else {
				reject("Please Install MetaMask - Required for this web-application to work.");
			}
		});
	});
};

// Get access to a contract - pulls in the ABI.
// Function from MetaMask Documenation.
const getContract = async (web3) => {
	const ABI = await $.getJSON("./contracts/SavedMessage.json");

	const netId = await web3.eth.net.getId();
	const deployedNetwork = ABI.networks[netId];
	const contrctBindABI = new web3.eth.Contract( ABI.abi, deployedNetwork && deployedNetwork.address );
	return contrctBindABI;
};

// displayData will show modified data on the user interface.
const displayData = async (contractHandle, contract) => {
	contractHandle = await contract.methods.getCurrentMessageTxt().call();
	$("#output_area").show();
	$("#data_output").html(contractHandle);
};

// bindToForm assicates functions with a form on the web page.
const bindToFormX = (contractHandle, contract, accounts) => {
	let input;

	// Collect new input.
	$("#input").on("change", (evnt) => {
		input = evnt.target.value;
	});

	// Handle form submission.  Call the contract to change the message.
	$("#form").on("submit", async (evnt) => {
		evnt.preventDefault(); // Stop form from taking "action" and submitting to server.
		await contract.methods.setCurrentMessageTxt(input).send({ from: accounts[0], gas: 40000 });
		// updateGreeting is the method in the contract
		displayData(contractHandle, contract); // Display modified data.
	});
};

// runApp will:
//	1. get connection to accounts (getWeb3)
//  2. get set of accounts.
//  3. display current data.
//  4. Setup to handle form.
async function runApp() {
	let contractHandle;

	const web3 = await getWeb3();
	const accounts = await web3.eth.getAccounts();
	const contract = await getContract(web3);

	displayData(contractHandle, contract);
	bindToFormX(contractHandle, contract, accounts);

	setInterval(function(){
		displayData(contractHandle, contract);
	}, 1000);
}

runApp();

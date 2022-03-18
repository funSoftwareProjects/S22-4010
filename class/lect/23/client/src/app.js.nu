  1: // getWeb3 connects to MetaMask with the local server and starts the web3 library.
  2: // Function from MetaMask Documenation.
  3: const getWeb3 = () => {
  4:     return new Promise((resolve, reject) => {
  5:         window.addEventListener("load", async () => {
  6:             if (window.ethereum) {
  7:                 const web3 = new Web3(window.ethereum);
  8:                 try {
  9:                     // Get the users accounts - request permission to use them in MetaMask
 10:                     await window.ethereum.request({ method: "eth_requestAccounts" });
 11:                     resolve(web3);
 12:                 } catch (error) {
 13:                     reject(error);
 14:                 }
 15:             } else {
 16:                 reject("Please Install MetaMask - Required for this web-application to work.");
 17:             }
 18:         });
 19:     });
 20: };
 21: 
 22: // Get access to a contract - pulls in the ABI.
 23: // Function from MetaMask Documenation.
 24: const getContract = async (web3) => {
 25:     const ABI = await $.getJSON("./contracts/SavedMessage.json");
 26: 
 27:     const netId = await web3.eth.net.getId();
 28:     const deployedNetwork = ABI.networks[netId];
 29:     const contrctBindABI = new web3.eth.Contract( ABI.abi, deployedNetwork && deployedNetwork.address );
 30:     return contrctBindABI;
 31: };
 32: 
 33: // displayData will show modified data on the user interface.
 34: const displayData = async (contractHandle, contract) => {
 35:     contractHandle = await contract.methods.getCurrentMessageTxt().call();
 36:     $("#output_area").show();
 37:     $("#data_output").html(contractHandle);
 38: };
 39: 
 40: // bindToForm assicates functions with a form on the web page.
 41: const bindToFormX = (contractHandle, contract, accounts) => {
 42:     let input;
 43: 
 44:     // Collect new input.
 45:     $("#input").on("change", (evnt) => {
 46:         input = evnt.target.value;
 47:     });
 48: 
 49:     // Handle form submission.  Call the contract to change the message.
 50:     $("#form").on("submit", async (evnt) => {
 51:         evnt.preventDefault(); // Stop form from taking "action" and submitting to server.
 52:         await contract.methods.setCurrentMessageTxt(input).send({ from: accounts[0], gas: 40000 });
 53:         // updateGreeting is the method in the contract
 54:         displayData(contractHandle, contract); // Display modified data.
 55:     });
 56: };
 57: 
 58: // runApp will:
 59: //    1. get connection to accounts (getWeb3)
 60: //  2. get set of accounts.
 61: //  3. display current data.
 62: //  4. Setup to handle form.
 63: async function runApp() {
 64:     let contractHandle;
 65: 
 66:     const web3 = await getWeb3();
 67:     const accounts = await web3.eth.getAccounts();
 68:     const contract = await getContract(web3);
 69: 
 70:     displayData(contractHandle, contract);
 71:     bindToFormX(contractHandle, contract, accounts);
 72: 
 73:     setInterval(function(){
 74:         displayData(contractHandle, contract);
 75:     }, 1000);
 76: }
 77: 
 78: runApp();

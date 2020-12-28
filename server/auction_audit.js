const Web3 = require('web3');
let abi = [
	{
		"inputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "cdps",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_daiCount",
				"type": "uint256"
			}
		],
		"name": "createCDP",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "daiAddress",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "implementation",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	}
];

let addressOfContract = '0x4c8C800d822019381BC0Ef7A1586aCb4Da7aB62c';
let endPoint = 'HTTP://127.0.0.1:7545';
const provider = new Web3.providers.HttpProvider(
    endPoint
);
let web3 = new Web3(provider);

testContract = new web3.eth.Contract(abi, addressOfContract);
const interval = 5 * 60 * 1000; // 5 minutes
module.exports = {
    auditStart : function(){
    	let output;
		testContract.methods.createCDP(50).call().then(console.log);
        //setInterval(() => {testContract.methods.num().call().then(console.log)}, 5000);
    }
}
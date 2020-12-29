const Web3 = require('web3');
let abi = [
	{
		"constant": true,
		"inputs": [],
		"name": "ETH_USD",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
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
				"name": "_new",
				"type": "uint256"
			}
		],
		"name": "upd_ETH_USD",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	}
];

let addressOfContract = 'address';
let endPoint = 'HTTP://127.0.0.1:7545';
const provider = new Web3.providers.HttpProvider(
    endPoint
);
let web3 = new Web3(provider);

oracleContract = new web3.eth.Contract(abi, addressOfContract);
const interval = 1 * 60 * 1000; // 1 minute
module.exports = {
    oracleStart : function(){
		setInterval(() => {auctionContract.methods.upd_ETH_USD(5000).call(5000)}, interval);
    }
}
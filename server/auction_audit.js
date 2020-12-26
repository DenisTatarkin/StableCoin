const Web3 = require('web3');
let abi = [
	{
		"constant": false,
		"inputs": [],
		"name": "inc",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "num",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	}
];

let addressOfContract = '0xbf770057c27677B466113C2c37B4e15e225F8a3E';
let endPoint = 'https://rinkeby.infura.io/v3/de670ffdea5d4ba196e23aef6468007c';
const provider = new Web3.providers.HttpProvider(
    endPoint
);
let web3 = new Web3(provider);

testContract = new web3.eth.Contract(abi, addressOfContract);
const interval = 5 * 60 * 1000; // 5 minutes
module.exports = {
    auditStart : function(){
        setInterval(() => {testContract.methods.num().call().then(console.log)}, 5000);
    }
}
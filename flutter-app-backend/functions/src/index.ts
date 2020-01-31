import * as functions from 'firebase-functions';

import Web3 from 'web3';
import { Contract } from 'web3-eth-contract'

const web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));
const address = "0x81dEc4F4D9a3A7E282a8e7D9Bf0a7C5EE7BAA8D5";
const contractData = require('../../../ethereum/build/contracts/VacationRequest.json')

const contract = new web3.eth.Contract(contractData.abi);
let currentDeployment: Contract;

export const sendRequest = functions.https.onRequest(async (request, response) => {
    if (!currentDeployment) {
        const deployment = await contract.deploy({
            data: contractData.bytecode
        })
        const estimated = await deployment.estimateGas()
        currentDeployment = await deployment.send({
            from: address,
            gasPrice: '0',
            gas: estimated
        });
    }
    const events = await currentDeployment.getPastEvents("allEvents", {
        toBlock: 'latest'
    });
    response.send(`Request Sent to ${currentDeployment.options.address}. Events: ${events.map(x => x.event).join(',')} `);
});

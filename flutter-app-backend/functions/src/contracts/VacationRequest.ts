import Web3 from 'web3';
//import { Contract } from 'web3-eth-contract'
import { AbiItem } from 'web3-utils'

const web3 = new Web3(new Web3.providers.HttpProvider(
        //'http://localhost:8545'
        'https://blocks365test.blockchain.azure.com:3200/0bK2J1bYlecsRDSxPQxfpJDT'
    ));
export const VacationRequestContractData = require('../../../../ethereum/build/contracts/VacationRequest.json')
if(!VacationRequestContractData){
    console.error('Could not load contract JSON')
}
else{
    
    console.log('Contract JSON loaded')
}
export const VacationRequestAbiItems: AbiItem[] = VacationRequestContractData.abi as AbiItem[];
export const VacationRequestContract = new web3.eth.Contract(VacationRequestAbiItems);

export const fromAddress = (address: string) =>new web3.eth.Contract(VacationRequestAbiItems, address) 
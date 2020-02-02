import Web3 from 'web3';
//import { Contract } from 'web3-eth-contract'
import { AbiItem } from 'web3-utils'

const web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));
export const VacationRequestContractData = require('../../../../ethereum/build/contracts/VacationRequest.json')
export const VacationRequestAbiItems: AbiItem[] = VacationRequestContractData.abi as AbiItem[];
export const VacationRequestContract = new web3.eth.Contract(VacationRequestAbiItems);

export const fromAddress = (address: string) =>new web3.eth.Contract(VacationRequestAbiItems, address) 
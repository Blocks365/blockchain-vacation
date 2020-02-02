import * as functions from 'firebase-functions';
import admin from 'firebase-admin';
import {DocumentReference} from '@google-cloud/firestore'

import Web3 from 'web3';
//import { Contract } from 'web3-eth-contract'
import { AbiItem } from 'web3-utils'

const contractData = require('../../../ethereum/build/contracts/VacationRequest.json')



admin.initializeApp(functions.config().firebase);



const db = admin.firestore();

const web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));
const address = "0x38a6DA8DD79d50c517aeBBB0aF96233428e01E51";
const abiItems: AbiItem[] = contractData.abi as AbiItem[];

const VacationRequest = new web3.eth.Contract(abiItems);

export const test = functions.https.onRequest(async (req, res) => {

    const deployment = await VacationRequest.deploy({
        data: contractData.bytecode
    })
    const estimated = await deployment.estimateGas()
    const currentDeployment = await deployment.send({
        from: address,
        gasPrice: '0',
        gas: estimated
    });

    const docRef = db.collection('requests').doc(currentDeployment.options.address);
    const owner = await currentDeployment.methods.owner().call();
    const document = docRef.set({
        owner: owner,
        address: currentDeployment.options.address
    });

    res.send(`Data: ${document}`);
})

export const update = functions.https.onRequest(async (req, res) => {

    const updateDoc = async (request: DocumentReference) => {
        const requestData = (await request.get()).data()
        if (!requestData){
            res.send('not found')
            return
        }
        const contractRef = new web3.eth.Contract(abiItems, requestData.address);
        console.log('Updating', contractRef.options.address, requestData.address)
        const events = await contractRef.getPastEvents("allEvents", {
            fromBlock: 0,
            toBlock: 'latest'
        });
        console.log('Events', events.length)
        const updatedObject = {
            ...requestData,
            events: events.map(x => ({
                event: x.event
            }))
        };
        await request.set(updatedObject)
    }
    if (req.query.address) {
        const request = await db.collection('requests').doc(req.query.address);
        await updateDoc(request)
    }
    else {
        const documents = await db.collection('requests').get()
        for (const request of documents.docs) {
            await updateDoc(request.ref)
        }
    }

    return res.send('ok')
})

export const get = functions.https.onRequest(async (req, res) => {
    const documents = await db.collection('requests').get()
    const data = documents.docs.map(x => x.data());
    res.send(data)
})
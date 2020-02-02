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
const address = "0xD214cEE4caf198a72C55b169f7AbB88Cb58dCfac";
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

    const owner = await currentDeployment.methods.owner().call();

    const docRef = db.collection('requests').doc(address);
    const current = (await docRef.get()).data() || {};
    const requests = current.requests || [];
    const document = docRef.set({
        ...current,
        owner: owner,
        username: 'Hardcoded Name',
        requests: [
            ...requests,
            {
                address: currentDeployment.options.address
            }
        ]

    }, {
        merge: true
    });

    res.send(`Data: ${document}`);
})

export const update = functions.https.onRequest(async (req, res) => {

    const updateRequest = async(request: any) =>{
        const contractRef = new web3.eth.Contract(abiItems, request.address);
        console.log('Updating', contractRef.options.address, request.address)
        const events = await contractRef.getPastEvents("allEvents", {
            fromBlock: 0,
            toBlock: 'latest'
        });
        console.log('Events', events.length)
        return {
            ...request,
            yes: true,
            events: events.map(x=>({
                ...x,
                returnValues: {
                    ...x.returnValues
                }
            }))
        }
    }

    const updateDoc = async (request: DocumentReference) => {
        console.log('updateDoc', request.id)
        const requestData = (await request.get()).data()
        if (!requestData){
            res.send('not found')
            return
        }
        const requestTask = (requestData.requests as Array<any>).map(updateRequest)
        const requestEvents = await Promise.all(requestTask)
        const updatedObject = {
            requests: requestEvents
        };
        await request.set(updatedObject, {
             merge: true
        })
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
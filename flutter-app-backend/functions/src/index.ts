import * as functions from 'firebase-functions';
import { DocumentReference } from '@google-cloud/firestore'
import { fromAddress } from './contracts/VacationRequest';
import { VacationRequestCommand } from './commands/VacationRequest'
import { db } from './store/firestore'

// const address = "0xD214cEE4caf198a72C55b169f7AbB88Cb58dCfac";
VacationRequestCommand('0xD214cEE4caf198a72C55b169f7AbB88Cb58dCfac').then(x => {
    console.log("OMG POTATO")
})
.catch(x=>{
    console.log(x)
});

export const update = functions.https.onRequest(async (req, res) => {

    const updateRequest = async (request: any) => {
        const contractRef = fromAddress(request.address)
        console.log('Updating', contractRef.options.address, request.address)
        const events = await contractRef.getPastEvents("allEvents", {
            fromBlock: 0,
            toBlock: 'latest'
        });
        console.log('Events', events.length)
        return {
            ...request,
            yes: true,
            events: events.map(x => ({
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
        if (!requestData) {
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
    console.log('starting command request')
    const documents = await db.collection('requests').get()
    const data = documents.docs.map(x => x.data());

    res.send(data)
})

export const onCommand = functions.firestore.document('requests/{owneraddress}/commands/{id}').onCreate(async (snapshot, context) => {
    const owneraddress = context.params.owneraddress;
    console.log('Owner', context.params.owneraddress, 'doc id', context.params.id);
    if (snapshot.exists) {
        const commandData = snapshot.data();
        if (!commandData) {
            return;
        }
        console.log('COMMAND', commandData.command);
        if (commandData.command === 'VacationRequest') {
            VacationRequestCommand(owneraddress);
        }
    }
})


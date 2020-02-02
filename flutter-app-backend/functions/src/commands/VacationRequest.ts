import { VacationRequestContract, VacationRequestContractData } from '../contracts/VacationRequest'
import admin = require('firebase-admin');

const db = admin.firestore();

export async function  VacationRequestCommand(address: string): Promise<void> {
    const deployment = await VacationRequestContract.deploy({
        data: VacationRequestContractData.bytecode
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
    const document = await docRef.set({
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

    console.log(document)
}
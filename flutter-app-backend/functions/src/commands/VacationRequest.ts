import { VacationRequestContract, VacationRequestContractData } from '../contracts/VacationRequest'
import { db } from '../store/firestore'

export async function VacationRequestCommand(address: string): Promise<void> {
    console.log('Deploying contract', VacationRequestContractData.bytecode.length)
    const deployment = await VacationRequestContract.deploy({
        data: VacationRequestContractData.bytecode,
        arguments:[
            '0xD214cEE4caf198a72C55b169f7AbB88Cb58dCfac'
        ]
    })
    if(!deployment){
        console.log('Could not deploy contract')
        return;
    }
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
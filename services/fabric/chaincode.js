
const {  Gateway, Wallets } = require('fabric-network');
const path = require('path');

const fs = require("fs");

const WALLET_PATH = path.join(__dirname, 'wallet');;
const CHANNEL_NAME = "druglink";
const CHAINCODE_NAME = "insureChain";
const CCP_PATH = path.resolve(__dirname, 'connection-org.json');
const orgUserId = "javascriptAppUser1";

async function connectToNetwork() {
    let ccp = JSON.parse(fs.readFileSync(CCP_PATH, 'utf8'));
    let wallet = await Wallets.newFileSystemWallet(WALLET_PATH);

    const identity = await wallet.get(orgUserId);

    if (!identity){
        console.log(`An identity for the user with ${orgUserId} does not exist in the wallet`);
        throw new Error(`An identity for the user with ${orgUserId} does not exist in the wallet`);
    }

    const gateway = new Gateway();
    await gateway.connect(ccp, {wallet, identity: orgUserId, discovery: { enabled: true, asLocalhost: true } });

    const network = await gateway.getNetwork(CHANNEL_NAME);
    const contract = network.getContract(CHAINCODE_NAME);

    return {
        gateway, network, contract
    }
}


async function invokeChaincode(func, args, isQuery, privateData){
    try {

        //chainging object passed as an object to array 

        let networkObj = await connectToNetwork(orgUserId);
        console.log("inside the invoke chaincode");
        console.log(`isQuery: ${isQuery}, func: ${func}, args: ${args}`);

        if(isQuery === true){
            console.log("inside isQuery");

            if (args){
                console.log("args ", args);
                let response = await networkObj.contract.evaluateTransaction(func, ...args);

                console.log(response.toString());
                console.log(`transaction ${func} with args has been evaluated`);
                await networkObj.gateway.disconnect();

                return JSON.parse(response.toString());
                
            } else{
                let response = await networkObj.contract.evaluateTransaction(func);
                console.log(response);
                console.log(`transaction ${func} without args has been evaluated`);
                await networkObj.gateway.disconnect();

                return JSON.parse(response.toString());
            }
        } else if (isQuery === false){
            console.log('not Query');

            if(args){
                console.log("args ", args);
                console.log("func ", func);
                let response = await networkObj.contract.submitTransaction(func, args);
                console.log(response);
                console.log("after submit response ", response.toString());

                await networkObj.gateway.disconnect();

                return JSON.parse(response.toString());

            } else {
                let response = await networkObj.contract.submitTransaction(func);
                console.log(response);
                console.log(`Transaction ${func} with args has been submitted`);

                await networkObj.gateway.disconnect();

                return JSON.parse(response.toString());
            }

        } else if (isQuery == "privateData"){

            if(args){
                console.log("args ", args);
                console.log("func ", func);
                console.log("privateData ", privateData);

                // const privateData = Buffer.from(JSON.stringify(args));
                
                let response = await networkObj.contract.createTransaction(func, args)
                                .setTransient(privateData)
                                .submit();
                
                console.log(response);
                console.log("after submit response ", response.toString());

                await networkObj.gateway.disconnect();

                return JSON.parse(response.toString());

            } else {
                console.log("func ", func);
                console.log("privateData ", privateData);

                let response = await networkObj.contract.createTransaction(func)
                                .setTransient(privateData)
                                .submit();
                
                console.log(response);
                console.log("after submit response ", response.toString());

                await networkObj.gateway.disconnect();

                return JSON.parse(response.toString());
            }
        }
        
    } catch (error) {
        console.log(`failed to submit transaction, error ${error}`);        
        throw error;
    }
}

module.exports = {invokeChaincode};
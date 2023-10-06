const {Wallets} = require("fabric-network");
const fs = require("fs");
const path = require('path');

const WALLET_PATH = path.join(__dirname, 'wallet');


// output: public and private key in hex format

async function createNewWalletEntity(enrollmentObject, username){
    const wallet = await Wallets.newFileSystemWallet(WALLET_PATH);
    const x509Identity = {
        credentials: {
            certificate: enrollmentObject.certificate,
            privateKey: enrollmentObject.key.toBytes(),
        },
        mspId: 'osqoMSP',
        type: 'X.509',
    };

    let hexKeyEntity = {
        publicKey: enrollmentObject.key._key.pubKeyHex,
        privateKey: enrollmentObject.key._key.prvKeyHex,
        username: username
    };

    let hexDataString = JSON.stringify(hexKeyEntity, null, 4);
    
    await Promise.all([
        wallet.put(username, x509Identity),
        fs.writeFile(path.join(WALLET_PATH, `${username}.json`), hexDataString, (err)=>{
            if(err) throw err;
        })
    ]);

    return hexKeyEntity;
}

function loadHexKeysFromWallet(email){
    try {
        let filePath = path.join(WALLET_PATH, email + ".json");

        if(!fs.existsSync(filePath)) {
            console.log(`user ${email} does not exist in wallet`);
            return null;
        }

        let rawData = fs.readFileSync(filePath);
        return JSON.parse(rawData);

    } catch (error) {
        console.log(`error in loadHexKeysFromWallet for username  ${email}`);
        console.log(`error: ${error}`);
        return null;
    }
}


module.exports = {createNewWalletEntity, loadHexKeysFromWallet};
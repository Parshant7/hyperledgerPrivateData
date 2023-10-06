const FabricCAServices = require('fabric-ca-client');
const { Wallets } = require('fabric-network');
const fs = require('fs');
const path = require('path');

const walletUtils = require('./wallet-utils');


const CCP_PATH = path.resolve(__dirname,'connection-org.json');

const WALLET_PATH = path.join(__dirname, 'wallet');
const org1UserId = "javascriptAppUser1";

const ccp =  JSON.parse(fs.readFileSync(CCP_PATH, 'utf8'));

async function enrollAdmin(){
    try {
        const caInfo = ccp.certificateAuthorities['ca.osqo.osqo.com'];
        const caTLSCACerts = caInfo.tlsCACerts.pem; 

        const ca = new FabricCAServices(caInfo.url, {trustedRoots: caTLSCACerts, verify: false}, caInfo.caName);

        const wallet = await Wallets.newFileSystemWallet(WALLET_PATH);
        console.log(wallet);

        const identity = await wallet.get('admin');
        if (identity) {
            console.log(identity);
            console.log("admin already exists in the wallet");
            return;
        }
        
        // enroll the admin user and import the new identity into the wallet.
        const enrollment = await ca.enroll({ enrollmentID: 'admin', enrollmentSecret: 'adminpw'});
        let adminkeys = await walletUtils.createNewWalletEntity(enrollment, "admin");

        return adminkeys;
    } catch (error) {
        console.log("error while enrolling admin ",error);
        process.exit(1);
    }
}

async function registerUser(){
    
    try {
        const caURL = ccp.certificateAuthorities['ca.osqo.osqo.com'].url;
        const ca = new FabricCAServices(caURL);

        const wallet = await Wallets.newFileSystemWallet(WALLET_PATH);

        const userIdentity = await wallet.get(org1UserId);
        if(userIdentity) {
            console.log(`An identity for this email ${org1UserId} already exists`);
            throw `An identity for this email ${org1UserId} already exists`;
        }

        const adminIdentity = await wallet.get('admin');
        if(!adminIdentity) {
            console.log(`An identity for the admin user "admin" does not exist in the wallet`);
            throw `An identity for the admin user "admin" does not exist in the wallet`;
            return;
        }


        //build a user object for authenticating with CA
        const provider = wallet.getProviderRegistry().getProvider(adminIdentity.type);
        const adminUser = await provider.getUserContext(adminIdentity, 'admin');

        // register the user, enroll the user and import the new identity into the wallet.
        const secret = await ca.register({
            affiliation: 'org1.department1',
            enrollmentID: org1UserId,
            role: 'client'
        },adminUser);

        const enrollment = await ca.enroll({
            enrollmentID: org1UserId,
            enrollmentSecret: secret
        });

        let userKeys = await walletUtils.createNewWalletEntity(enrollment, org1UserId);
        console.log(`succesfully registerd and enrolled user ${org1UserId} and imported it into the wallet`);
        return userKeys;

    } catch (error) {
        console.log(`failed to register user ${org1UserId}: ${org1UserId}`);
        throw error;
    }
}

module.exports = {enrollAdmin, registerUser};

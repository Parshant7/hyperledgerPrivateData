const characters ='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
const numerics = '0123456789';

module.exports.generateKey = () => {
    let length = 10;
    let result = '';
    const charactersLength = characters.length;
    for ( let i = 0; i < length; i++ ) {
        result += characters.charAt(Math.floor(Math.random() * charactersLength));
    }

    return result;
}


module.exports.generateOrderId = () => {
    let length = 12;
    let result = '';
    const numericsLength = numerics.length;
    for ( let i = 0; i < length; i++ ) {
        result += numerics.charAt(Math.floor(Math.random() * numericsLength));
    }

    return result;
}

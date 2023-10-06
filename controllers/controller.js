const { messages, responseStatus, statusCode } = require("../core/constant/constant");
const { v4: uuidv4 } = require('uuid');
const chaincode = require('../services/fabric/chaincode');


module.exports.register = async(req, res)=>{
    
    try {
        
        let data = {
            id: req.body[req.idName],
            docType: req.docType,
            idName : req.idName,
            [req.idName]: req.body[req.idName]
        }

        const osqoId = data.id;
        const payload = req.body;
        delete payload[data.idName];

        payload.osqoId = osqoId;
        payload.docType = data.docType;



        console.log(" /registeration POST payload ", payload);
        
        let queryString = {};
        queryString.selector = {};
        queryString.selector.osqoId = data.id;

        let fetchUser = await chaincode.invokeChaincode("getQueryResultForQueryString",[JSON.stringify(queryString)], true);
    
        if(fetchUser.success == "true"){
            return res.status(statusCode.Bad_request).json({
                messages:messages.idExists,
                ResponseStatus: responseStatus.failure,
            });
        }

        // console.log(isExists);
        let result = await chaincode.invokeChaincode("createUser", [JSON.stringify(payload)], false);

        console.log("result from the chaincode ", result);

        return res.status(statusCode.Created).json({
            messages:messages.register,
            ResponseStatus: responseStatus.success,
        });

    } catch (error) {
        console.log("/registeration POST failed  ",error.message);
        return res.status(statusCode.InternalServerError).json({
            messages:messages.serverErr,
            ResponseStatus: responseStatus.failure,
        });
    }
}


module.exports.getAllUsers = async (req, res)=>{
    try{
        let result = await chaincode.invokeChaincode("getAllusers",[], true);
        console.log("result from the chaincode ", result);
        return res.status(statusCode.Created).json({
            messages:messages.fetchSuccess,
            ResponseStatus: responseStatus.success,
            data: result
        });
    }catch(error){
        console.log("/get all users GET failed  ",error.message);
        return res.status(statusCode.InternalServerError).json({
            messages:messages.serverErr,
            ResponseStatus: responseStatus.failure,
        });
    }
}


module.exports.getUserById = async (req, res)=>{
    try{
        let queryString = {};
        queryString.selector = {};
        queryString.selector.osqoId = req.body.id;
        queryString.selector.docType = req.body.docType;

        let fetchUser = await chaincode.invokeChaincode("getQueryResultForQueryString",[JSON.stringify(queryString)], true);
    
        if(fetchUser.success == "false"){
            return res.status(statusCode.Not_Found).json({
                messages: messages.idNotFound,
                ResponseStatus: responseStatus.failure,
            });
        }

        return res.status(statusCode.Ok).json({
            messages: messages.idFound,
            ResponseStatus: responseStatus.failure,
            data: fetchUser.data
        });

    }catch(error){
        console.log("/get users GET failed  ",error.message);
        return res.status(statusCode.InternalServerError).json({
            messages:messages.serverErr,
            ResponseStatus: responseStatus.failure,
        });
    }
}

module.exports.updateUserById = async (req, res)=>{
    try{
        let queryString = {};
        queryString.selector = {};
        console.log("id name", req.idName);
        queryString.selector.osqoId = req.body[req.idName];
        queryString.selector.docType = req.body.docType;

        let isExists = await chaincode.invokeChaincode("getQueryResultForQueryString",[JSON.stringify(queryString)], true);

        if(isExists.success == "false"){
            return res.status(statusCode.Not_Found).json({
                messages: messages.idNotFound,
                ResponseStatus: responseStatus.failure,
            });
        }

        const userUpdate = req.body;
        const osqoId = req.body[req.idName];

        delete userUpdate[req.idName];
        userUpdate.osqoId = osqoId;

        console.log("req body", req.body);
        
        console.log(userUpdate);

        let result = await chaincode.invokeChaincode("updateUserById",[JSON.stringify(userUpdate)], false);

        if(result.success == "false"){
            return res.status(statusCode.InternalServerError).json({
                messages: "could not update user",
                ResponseStatus: responseStatus.failure,
            });
        }

        return res.status(statusCode.Ok).json({
            messages: "successfully updated data",
            ResponseStatus: responseStatus.success,
        });

    }catch(error){
        console.log("/update users GET failed  ",error.message);
        return res.status(statusCode.InternalServerError).json({
            messages:messages.serverErr,
            ResponseStatus: responseStatus.failure,
        });
    }
}

module.exports.deleteById = async (req, res)=>{
    try {
        const osqoId = req.params['id'];
        const docType = req.params['docType'];

        let queryString = {};
        queryString.selector = {};
        console.log("id name", req.params['id']);
        queryString.selector.osqoId = osqoId;
        queryString.selector.docType = docType;

        let isExists = await chaincode.invokeChaincode("getQueryResultForQueryString",[JSON.stringify(queryString)], true);

        if(isExists.success == "false"){
            return res.status(statusCode.Not_Found).json({
                messages: messages.idNotFound,
                ResponseStatus: responseStatus.failure,
            });
        }

     
        let result = await chaincode.invokeChaincode("deleteUserById",[JSON.stringify({osqoId})], false);

        if(result.success == "false"){
            return res.status(statusCode.InternalServerError).json({
                messages: "could not delete user",
                ResponseStatus: responseStatus.failure,
            });
        }

        return res.status(statusCode.Ok).json({
            messages: "successfully deleted data",
            ResponseStatus: responseStatus.success,
        });

    } catch (error) {
        console.log("/delete users delete failed  ",error.message);
        return res.status(statusCode.InternalServerError).json({
            messages:messages.serverErr,
            ResponseStatus: responseStatus.failure,
        });
    }
}



// Private data invoke

module.exports.createCar = async(req, res)=>{
    
    try {

        const data = req.body;

        console.log(" /createCar POST data ", data);
        
        // let queryString = {};
        // queryString.selector = {};
        // queryString.selector.osqoId = data.id;

        let privateData = {"car": Buffer.from(JSON.stringify(data))};

        let fetchCar = await chaincode.invokeChaincode("getCar", [], "privateData", privateData);
        if(fetchCar.success == "true"){
            return res.status(statusCode.Bad_request).json({
                messages:messages.idExists,
                ResponseStatus: responseStatus.failure,
            });
        }
        console.log("fetchCar", fetchCar);
        // console.log(isExists);
        privateData = {"car": Buffer.from(JSON.stringify(data))};

        let result = await chaincode.invokeChaincode("createCar", '', "privateData", privateData);

        console.log("result from the chaincode ", result);

        return res.status(statusCode.Created).json({
            messages:messages.register,
            ResponseStatus: responseStatus.success,
        });

    } catch (error) {
        console.log("/registeration POST failed  ",error.message);
        return res.status(statusCode.InternalServerError).json({
            messages:messages.serverErr,
            ResponseStatus: responseStatus.failure,
        });
    }
}

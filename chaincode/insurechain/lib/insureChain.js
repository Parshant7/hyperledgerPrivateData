/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const { Contract } = require('fabric-contract-api');

class InsureChain extends Contract {

    async createUser(ctx, user) {
        console.info('============= START : Create user ===========');
        const newUser = JSON.parse(user);
      
        console.log("new user info JSON.parse(user)", JSON.parse(user));
        
        const id = newUser.osqoId;

        await ctx.stub.putState(id, Buffer.from(JSON.stringify(newUser)));
        console.info('============= END : Create user ===========');
        return JSON.stringify({msg: "successfully added user", success: "true"});
    }


    async createCar(ctx) {
      console.info('============= START : Create car ===========');
      try{

        const transient = ctx.stub.getTransient();
        const data = transient.get("car");
        console.log("this is carDetails", data);
        console.log("this is carDetails.toString('utf-8')",  data.toString('utf-8'));
        
        const carDetailObj = JSON.parse(data.toString('utf-8'));
        
        console.log("car details in obj", carDetailObj);
        
        // const newCar={
      //   id: carId,
      //   model: carModel,
      //   owner: carOwner,
      //   price: carPrice
      // };
      
      // console.log("new car info ", newCar);
      
      const id = carDetailObj.id;
      
      await ctx.stub.putPrivateData("collectionCarPrivateDetails", id, Buffer.from(JSON.stringify(carDetailObj)));
      // console.info('============= END : Create car ===========');
      
      return JSON.stringify({msg: "successfully added car", success: "true"});
    }
    catch(error){
      console.log("this is error", error);
      return JSON.stringify({msg: "failed to add car", success: "false"});
    }


    }


    async getCar(ctx){
      
      try{
        console.info('============= START : Get Car ===========');

        const transient = ctx.stub.getTransient();
        console.log("this is the transient ", transient);
        const data = transient.get("car");
        console.log("this is the data ", data);
        const carDetails = JSON.parse(data.toString());

        console.log("this is the car details ", carDetails);
        
        const carId = carDetails.id;
        console.log(carId);

        
        const results = await ctx.stub.getPrivateData("collectionCarPrivateDetails", carId);
        console.log("this is the results", results.toString());
        

        if (!results || results.length === 0)
        {
          return JSON.stringify({msg: "car does not exists", success: "false"});
        }
        
        return JSON.stringify({msg: "here is the car", success: "true", data: results.toString()});
        
      }
      catch(error){
        console.log("error occured", error);
        return JSON.stringify({msg: "failed to get car", success: "false", data: error});
      }

    }

    async getAllusers(ctx) {
        const startKey = '';
        const endKey = '';
        const resultsIterator = await ctx.stub.getStateByRange(startKey, endKey);
        const allResults = await this.getAllResults(resultsIterator, false);

        console.info(allResults);
        return JSON.stringify(allResults);
    }

    // async idExists(ctx, id, docType) {
    //     let queryString = {};
    //     queryString.selector = {};
    //     queryString.selector.docType = docType;
    //     queryString.selector.id = id;
    //     let queryResults = await this.getQueryResultForQueryString(ctx, JSON.stringify(queryString));
    //     return queryResults && queryResults.length > 0;
    // }

    async getQueryResultForQueryString(ctx, queryString) {

        console.info('- getQueryResultForQueryString queryString:\n' + queryString);
        let resultsIterator = await ctx.stub.getQueryResult(queryString);    
        let results = await this.getAllResults(resultsIterator, false);
        console.log("results from query", results);
        if(results.length == 0){
          return JSON.stringify({success: "false"});
        }
        return JSON.stringify({success: "true", data:results});
    }


    async getAllResults(iterator, isHistory) {
        let allResults = [];
        while (true) {
          let res = await iterator.next();
    
          if (res.value && res.value.value.toString()) {
            let jsonRes = {};
            console.log(res.value.value.toString('utf8'));
    
            if (isHistory && isHistory === true) {
              jsonRes.TxId = res.value.tx_id;
              jsonRes.Timestamp = res.value.timestamp;
              jsonRes.IsDelete = res.value.is_delete.toString();
              try {
                jsonRes.Value = JSON.parse(res.value.value.toString('utf8'));
              } catch (err) {
                console.log(err);
                jsonRes.Value = res.value.value.toString('utf8');
              }
            } else {
              jsonRes.Key = res.value.key;
              try {
                jsonRes.Record = JSON.parse(res.value.value.toString('utf8'));
              } catch (err) {
                console.log(err);
                jsonRes.Record = res.value.value.toString('utf8');
              }
            }
            allResults.push(jsonRes);
          }
          if (res.done) {
            console.log('end of data');
            await iterator.close();
            console.info(allResults);
            return allResults;
          }
        }
      }

      async updateUserById(ctx, updations){
        console.info('============= START : update user ===========');
        let updates = JSON.parse(updations);
        console.log("updates ", updates);

        //getting the user
        let queryString = {};
        queryString.selector = {};
        queryString.selector.docType = updates.docType;
        queryString.selector.osqoId = updates.osqoId;
        
        let queryResults = await this.getQueryResultForQueryString(ctx, JSON.stringify(queryString));
        console.log("this is the query results", queryResults);
        let user = JSON.parse(queryResults).data[0].Record;
        
        console.log("this is user", user);
        
        // updating only the required fields
        let userUpdate = user;

        for (const key in updates){
          userUpdate[key] = updates[key];
        }
        // ----------------------------


        console.log("update user info ", userUpdate);
        
        const id = userUpdate.osqoId;

        await ctx.stub.putState(id, Buffer.from(JSON.stringify(userUpdate)));
        console.info('============= END : Update user ===========');

        return JSON.stringify({msg: "successfully update user", success: "true"});
      }

      async deleteUserById(ctx, id){
        try {
          const osqoId = JSON.parse(id);
          console.log("id to delete ", osqoId);
          await ctx.stub.deleteState(osqoId.osqoId);
          return JSON.stringify({msg: "successfully deleted user by id", success: "true"});

        } catch (error) {
          return JSON.stringify({msg: "could not delete user by id", success: "false"});          
        }
      }
}

module.exports = InsureChain;

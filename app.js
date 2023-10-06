require("dotenv").config();

const express = require('express');

const bcpRoutes = require('./routes/bcpRoutes');
const espRoutes = require('./routes/espRoutes');
const brockerRoutes = require('./routes/brokerRoutes');
const osqoRoutes = require('./routes/osqoRoutes');



const routes = require('./middlewares/routes');
//chaincode
const fabricEnrollment  = require('./services/fabric/enrollment');
//---------


const PORT = process.env.PORT || 3000;

const app = express();

// middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use('/bcp/', routes.bcp, bcpRoutes);
app.use('/esp/', routes.esp, espRoutes);
app.use('/broker/', routes.broker, brockerRoutes);
app.use('/osqo/', routes.osqo, osqoRoutes);



app.get('/', (req, res)=>{
  res.json("home");
  console.log(process.env.message);
})

app.get('/enroll', async(req, res)=>{
  try{
    let adminKeys = await fabricEnrollment.enrollAdmin();
    let userKeys = await fabricEnrollment.registerUser();
    return res.json("enrolled user and admin");
  }
  catch(error){
    console.log(error);
  //   return res.status(statusCode.Bad_request).json({
  //     messages:,
  //     ResponseStatus: responseStatus.failure,
  // });
    res.json(error);
  }

});

app.listen(PORT, ()=>{
    console.log("app listening on port ", PORT);
});

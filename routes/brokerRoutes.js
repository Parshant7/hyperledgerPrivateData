
const express= require('express');
const router = express.Router();

const brokerController = require('../controllers/controller');


router.post('/register', brokerController.register);
router.get('/getAllUsers', brokerController.getAllUsers);
router.get('/getUserById', brokerController.getUserById);
router.put('/updateUserById', brokerController.updateUserById);
router.delete('/deleteById/:docType/:id', brokerController.deleteById);

module.exports = router;

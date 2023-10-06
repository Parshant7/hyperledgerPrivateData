
const express= require('express');
const router = express.Router();

const bcpController = require('../controllers/controller');


router.post('/register', bcpController.register);
router.get('/getAllUsers', bcpController.getAllUsers);
router.get('/getUserById', bcpController.getUserById);
router.put('/updateUserById', bcpController.updateUserById);
router.delete('/deleteById/:docType/:id', bcpController.deleteById);

module.exports = router;

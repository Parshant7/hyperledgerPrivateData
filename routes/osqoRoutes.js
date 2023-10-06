
const express= require('express');
const router = express.Router();

const osqoController = require('../controllers/controller');

router.post('/register', osqoController.register);
router.get('/getAllUsers', osqoController.getAllUsers);
router.get('/getUserById', osqoController.getUserById);
router.put('/updateUserById', osqoController.updateUserById);
router.delete('/deleteById/:docType/:id', osqoController.deleteById);
router.post('/createCar', osqoController.createCar);

module.exports = router;

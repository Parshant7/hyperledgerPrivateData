
const express= require('express');
const router = express.Router();

const espController = require('../controllers/controller');


router.post('/register', espController.register);
router.get('/getAllUsers', espController.getAllUsers);
router.get('/getUserById', espController.getUserById);
router.put('/updateUserById', espController.updateUserById);
router.delete('/deleteById/:docType/:id', espController.deleteById);

module.exports = router;

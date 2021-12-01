const express = require("express");
const router = express.Router();
const result = require('../handler/result/firebase_read');

router.post('/pay', result.firebaseResult);

module.exports = router;
const express = require("express");
const router = express.Router();
const result = require('../handler/result/firebase_read');

router.post('/pay', result.firebaseResult);
router.post('/refund', result.refundBet);
router.post('/setTimeout', result.setTimeoutToClose);
router.post('/setIntervalCoins', result.setIntervalCoins);

module.exports = router;
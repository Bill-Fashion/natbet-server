const express = require("express");
const router = express.Router();
const notification = require('../handler/notification/newgame_notifcation');

router.post('/push', notification.notifyNewGame);

module.exports = router;
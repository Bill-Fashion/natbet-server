
module.exports = {
    firebaseResult: async (req, res) => {
        const {roomId, gameId, winner} = req.body;
        var prizePool;
        var winSideBudget;
        var betBudget;
        var odds;
        // var now = admin.firestore.Timestamp.now().toDate();
        const gameDocDb = await admin.firestore().collection('rooms').doc(roomId).collection('games').doc(gameId);
        const gameDocUpdate = await gameDocDb.update({
          winner: winner,
        });
        const gameDoc = await gameDocDb.get();
        if (!gameDoc.exists) {
          } else {
            prizePool = gameDoc.data()['leftBudget'] + gameDoc.data()['rightBudget']
            if (winner == 'Left') {
              winSideBudget = gameDoc.data()['leftBudget'];
              odds = prizePool / winSideBudget;
            } else {
              winSideBudget = gameDoc.data()['rightBudget'];
              odds = prizePool / winSideBudget;
            }
          }
          const historyDoc = await admin.firestore()
          .collection('rooms')
          .doc(roomId)
          .collection('histories')
          .doc();
          const historyDocAdd = await historyDoc
          .set({
            winner: winner,
            gameType: gameDoc.data()['gameType'],
            description: gameDoc.data()['description'],
            leftValue: gameDoc.data()['leftValue'],
            leftOdds: (gameDoc.data()['leftBudget'] + gameDoc.data()['rightBudget'])/gameDoc.data()['leftBudget'],
            rightValue: gameDoc.data()['rightValue'],
            rightOdds: (gameDoc.data()['leftBudget'] + gameDoc.data()['rightBudget'])/gameDoc.data()['rightBudget'],
            timestamp: admin.firestore.Timestamp.now().toDate()
          });
        const playersDocs = await admin.firestore()
            .collection('rooms')
            .doc(roomId)
            .collection('games')
            .doc(gameId)
            .collection('players')
            .get();
          playersDocs.forEach(async doc => {
            var prize;
            const playerDoc = await admin.firestore().collection('rooms')
              .doc(roomId)
              .collection('games')
              .doc(gameId)
              .collection('players')
              .doc(doc.id)
              .get();
            if (winner == 'Left') {
              betBudget = playerDoc.data()["leftBetBudget"];
            } else {
              betBudget = playerDoc.data()["rightBetBudget"]
            }
            prize = Math.round(betBudget * odds);
            const userDb = await admin.firestore().collection('users').doc(doc.id);
            const getUserCurrentCoins = await userDb.get();
            const updateUserCoins = await userDb.update({
              coins: getUserCurrentCoins.data()['coins'] + prize
            });
            var leftPrize;
            var rightPrize;
            if (winner == 'Left') {
              leftPrize = prize;
              rightPrize = 0;
            } else {
              leftPrize = 0;
              rightPrize = prize;
            }
            
            const addPlayersHistoryDoc = await historyDoc.collection('players').doc(doc.id).set({
              leftBetBudget: playerDoc.data()["leftBetBudget"],
              leftPrize: leftPrize,
              rightBetBudget: playerDoc.data()["rightBetBudget"],
              rightPrize: rightPrize
            })
          });
        res.status(200).json({
            message: "Set successfully",
        })
    },

    refundBet: async (req, res) => {
      const {roomId, gameId} = req.body;

      const gameDocDb = await admin.firestore()
        .collection('rooms')
        .doc(roomId)
        .collection('games')
        .doc(gameId);
      
      const gameDoc = await gameDocDb.get();
      
      const playersDocs = await gameDocDb
          .collection('players')
          .get();
        playersDocs.forEach(async doc => {
          var betBudget;
          const playerDoc = await admin.firestore().collection('rooms')
            .doc(roomId)
            .collection('games')
            .doc(gameId)
            .collection('players')
            .doc(doc.id);
          var playerDocData = await playerDoc.get();
          
            betBudget = playerDocData.data()["leftBetBudget"] + playerDocData.data()["rightBetBudget"];
          playerDoc.update({
            leftBetBudget: 0,
            rightBetBudget: 0
          })
          // prize = Math.round(betBudget * odds);
          const userDb = await admin.firestore().collection('users').doc(doc.id);
          const getUserCurrentCoins = await userDb.get();
          const updateUserCoins = await userDb.update({
            coins: getUserCurrentCoins.data()['coins'] + betBudget
          });
        });
        const gameDocUpdate = await gameDocDb.update({
          leftBudget: 0,
          rightBudget: 0,
          closed: true,
          refunded: true,
        });
      res.status(200).json({
          message: "Set successfully",
      })
  },
    setTimeoutToClose: async (req, res) => {
      const {roomId, gameId, milisecondSetted} = req.body;
      // create Date object for current location
      var d = new Date();
      // convert to msec
      // subtract local time zone offset
      // get UTC time in msec
      let utc = d.getTime() + (d.getTimezoneOffset() * 60000);
      let ts = utc + (3600000*(+7));

      let milisecondLeft = milisecondSetted - ts;
      const gameDb = await admin.firestore()
            .collection('rooms')
            .doc(roomId)
            .collection('games')
            .doc(gameId)
      
      if (milisecondLeft <= 0) {
        gameDb.update({
          closed: true,
          closedInProgress: false
        });
      } else {
        setTimeout( async () => {
          
            gameDb.update({
              closed: true,
              closedInProgress: false
            }); 
            
        }, milisecondLeft);        
      }
      res.status(200).json({
        message: "Success"
      })
    },
    setIntervalCoins: async (req, res) => {
      const {miliseconds} = req.body;
      setInterval(function () {
    }, miliseconds, 'freetuts', (miliseconds / 1000)) 
    res.status(200).json({
      message: "Success"
    })
    }
}


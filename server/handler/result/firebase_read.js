// const { sendNotify } = require("../handler/notification/notify_handler");
module.exports = {
    firebaseResult: async (req, res) => {
        const {roomId, gameId, winner} = req.body;
        var prizePool;
        var winSideBudget;
        var betBudget;
        var odds;
        // var now = admin.firestore.Timestamp.now().toDate();
        const gameDoc = await admin.firestore().collection('rooms').doc(roomId).collection('games').doc(gameId).get();
        // console.log(observer);
        if (!gameDoc.exists) {
            console.log('No such document!');
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
          console.log("odds:", odds);
          console.log("prize pool", prizePool);
        const playersDocs = await admin.firestore()
            .collection('rooms')
            .doc(roomId)
            .collection('games')
            .doc(gameId)
            .collection('players')
            .get();
          playersDocs.forEach(async doc => {
            var prize;
            console.log(doc.id);
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
            console.log("betBudget: ", betBudget);
            prize = Math.round(betBudget * odds);
            const userDb = await admin.firestore().collection('users').doc(doc.id);
            const getUserCurrentCoins = await userDb.get();
            console.log("current coins: ", getUserCurrentCoins.data()['coins']);;
            const updateUserCoins = await userDb.update({
              coins: getUserCurrentCoins.data()['coins'] + prize
            });
            console.log('Player: ', doc.id);
            console.log('Prize: ', prize);
          });
        // console.log(odds);
          
        res.status(200).json({
            message: "Set successfully",
            
        })
        
    
    }
}


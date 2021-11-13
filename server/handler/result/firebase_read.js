
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
          });
        res.status(200).json({
            message: "Set successfully",
        })
    }
}


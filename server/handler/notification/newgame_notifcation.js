module.exports = {
    notifyNewGame: async (req, res) => {
        const {roomId, description} = req.body;
        let tokensArray = [];
        let players = [];
        const roomDoc = await admin.firestore()
        .collection('rooms')
        .doc(roomId)
        .get();

        players = roomDoc.data()['members'];
        for (let i = 0; i < players.length; i++) {
          const userDoc = await admin.firestore()
            .collection('users')
            .doc(players[i])
            .get();
            
            tokensArray.push.apply(tokensArray, userDoc.data()['tokens']);
          
        } 
        console.log("tokens array: ", tokensArray);
        
        const uniqueArrayTokens = Array.from(new Set(tokensArray)); 
        console.log("unique: ", uniqueArrayTokens);
        if (uniqueArrayTokens != []) {
          await admin.messaging().sendToDevice(
            uniqueArrayTokens, // ['token_1', 'token_2', ...]
            {
              data: {
                notification: JSON.stringify({
                  roomId: roomId,
                  title: "New bet available!", 
                  content: description,
                  timestamp: admin.firestore.Timestamp.now().toDate()
                }),
              },
            },
            {
              // Required for background/quit data-only messages on iOS
              contentAvailable: true,
              // Required for background/quit data-only messages on Android
              priority: "high",
            }
          )
        }
        
        res.status(200).json({
            message: "Set successfully",
        })
    }
}


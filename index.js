const express = require('express')
const app = express()
const PORT = process.env.PORT || 8080;
const cors = require("cors");
const routes = require('./routes/index');
global.admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");
const http = require("http");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

app.use(cors());
app.use(express.json());
routes(app);

//Ping heroku every 5p to keep server awake
setInterval(function() {
    http.get("https://natbet.herokuapp.com");
}, 300000); // every 5 minutes (300000)
 
app.listen(PORT, () => {
  console.log(`Server app listening at http://localhost:${PORT}`)
})

module.exports = app;
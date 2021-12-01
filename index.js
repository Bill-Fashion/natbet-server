const resultRouter = require('./result_route');
const notifyRouter = require('./notification_route');

function routes(app){
    app.use("/result", resultRouter);
    app.use("/notify", notifyRouter);
}


module.exports = routes; 
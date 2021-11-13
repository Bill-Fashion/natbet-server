const resultRouter = require('./result_route');

function routes(app){
    app.use("/result", resultRouter);
}


module.exports = routes; 
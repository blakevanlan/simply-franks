/*
Environmental variables
 - PORT
*/

require("coffee-script");
app = require("./controllers/host.coffee");
http = require("http");
port = process.env.PORT || 2000;

http.createServer(app).listen(port, function () {
   console.log("Simply Franks listening on " + port);
});
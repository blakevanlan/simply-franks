/*
Environmental variables
 - PORT
 - COOKIE_SECRET
 - MONGOHQ_URL
 - REDISTOGO_URL
*/

require("coffee-script");
app = require("./controllers/host.coffee");
port = process.env.PORT || 2000;

app.listen(port, function () {
   console.log("Simply Franks listening on " + port);
});
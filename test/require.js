
var fs = require("fs");
var path = require("path");
requirejs = require("../node_modules/requirejs/bin/r.js");

var relative = "./";
while(!fs.existsSync(path.join(relative,"test"))&&fs.existsSync(relative)){
  relative = path.join(relative, "..");
}
if(!fs.existsSync(path.join(relative, "test"))){
  throw new Error("couldn't find test directory");
}

requirejs.config({
  nodeRequire: require,
  paths: {
  	'text': path.join(process.cwd(),relative,"lib/text"),
  	'json': path.join(process.cwd(),relative,"lib/json"),
    'src': path.join(process.cwd(),relative,"src"),
    'livescript': path.join(process.cwd(),relative,"lib/livescript"),
    'ls': path.join(process.cwd(),relative,"lib/ls"),
    'prelude': path.join(process.cwd(),relative,"lib/prelude-browser"),
  }
});

module.exports = requirejs;


requirejs = require("r.js");

requirejs.config({
  nodeRequire: require,
  paths: {
  	'text': "../../lib/text",
  	'json': "../../lib/json",
    'src': "../../src",
    'livescript': "../../lib/livescript",
    'ls': "../../lib/ls",
    'prelude': "../../lib/prelude-browser",
  }
});



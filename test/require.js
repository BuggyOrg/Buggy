
requirejs = require("../node_modules/requirejs/bin/r.js");

requirejs.config({
  nodeRequire: require,
  paths: {
  	'text': "../../../lib/text",
  	'json': "../../../lib/json",
    'src': "../../../src",
    'livescript': "../../../lib/livescript",
    'ls': "../../../lib/ls",
    'prelude': "../../../lib/prelude-browser",
  }
});

module.exports = requirejs;

var csp = require("js-csp");
var merge = require("object-merge");

function* id(input, out){
  while(true)
  {
    var taken = yield csp.take(input);
    yield csp.put(out, taken);
  }
}

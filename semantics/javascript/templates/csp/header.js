var csp = require("js-csp");
var merge = require("object-merge");

function* id(input, out){
  while(true)
  {
    yield csp.put(out, yield csp.take(input));
  }
}

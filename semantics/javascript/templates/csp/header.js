var csp = require("js-csp");

function* id(input, out){
  while(true)
  {
    yield csp.put(out, yield csp.take(input));
  }
}

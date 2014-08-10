var csp = require("js-csp");
var merge = require("object-merge");

function* id(input, out){
  while(true)
  {
    var taken = yield csp.take(input);
    yield csp.put(out, taken);
  }
}

{{~#if debug}}
// map id -> array of things not taken
var notTaken = {};
var outInMap = {};
function debug_put(id, what){
  if(id in notTaken){
    notTaken[id].push(what);
  } else {
    notTaken[id] = [what];
  }
}

function debug_take_pre(id){
  var newID = outInMap[id];
  notTaken[newID][0].taken = true;
}
function debug_take_post(id){
  var newID = outInMap[id];
  notTaken[newID] = notTaken[newID].slice(1);
}
{{~/if}}
function* outputData(id, chan, what){
{{~#if debug}}
  debug_put(id,what);
{{/if}}
  yield csp.put(chan, JSON.parse(JSON.stringify(what)));
}

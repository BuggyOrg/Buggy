{{#if implementation.implementation}}
function {{implementation.name}} (input, meta, callback){
  var output = {};
  {{implementation.implementation}}
{{#unless implementation.explicit-callback}}  callback(output);
{{/unless}}
}
{{/if}}

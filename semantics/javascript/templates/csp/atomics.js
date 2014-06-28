function {{generic.name}} (input, meta, callback){
  var output = {};
  {{node.implementation}}
{{#unless node.explicit-callback}}  callback(output);
{{/unless}}
}

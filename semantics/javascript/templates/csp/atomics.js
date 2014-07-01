function {{name}} (input, meta, callback){
  var output = {};
  {{implementation}}
{{#unless explicit-callback}}  callback(output);
{{/unless}}
}

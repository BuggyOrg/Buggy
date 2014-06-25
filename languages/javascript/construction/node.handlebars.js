function Node_{{generic.id}} (InQueues, OutQueues){
{{#ifCond node.atomic node.implemented}}\
  var name = "{{generic.id}}";
  var meta = {{meta}};
  csp.go({{generic.name}},[InQueues, OutQueues, name, meta]);
{{else}}\
  Group_{{generic.id}}(InQueues, OutQueues);
{{/ifCond}}
}

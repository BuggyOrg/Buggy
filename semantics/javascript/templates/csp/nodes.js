function Node_{{node.id}} (InQueues, OutQueues, meta){
{{#if implementation.atomic}}
  var name = "{{node.id}}__{{node.mangle}}";
  csp.go({{implementation.name}},[InQueues, OutQueues, name, meta]);
{{/if}}
}

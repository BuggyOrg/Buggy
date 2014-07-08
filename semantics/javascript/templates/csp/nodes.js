function Node_{{node.id}} (InQueues, OutQueues, meta){
{{#if implementation.atomic}}
  var name = "{{node.id}}__{{node.mangle}}";
  csp.go({{implementation.name}}_{{node.id}},[InQueues, OutQueues, name, meta]);
{{/if}}
}

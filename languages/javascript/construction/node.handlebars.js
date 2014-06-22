function* Node_{{generic.id}} (InQueues, OutQueues){
{{#ifCond node.atomic node.implemented}}\
{{#if node.input}}
{{else}}
while(true){
{{/if}}
  var InValues = {
{{#each node.connectors}}{{#if_eq connector-type "Input"}}\
    "{{name}}" : yield csp.take(InQueues["{{../../generic.id}}:{{name}}"]),
{{/if_eq}}{{/each}}\
  }
  {{generic.name}}(InValues, {{meta}}, function* (returnVals){
    for(var key in returnVals){
      yield csp.put(OutQueues["{{generic.id}}:" + key], returnVals[key]);
    }
  });
{{#if node.input}}
{{else}}
}
{{/if}}
{{else}}\
//  Group_{{generic.id}}(InQueues, OutQueues);
{{/ifCond}}
}

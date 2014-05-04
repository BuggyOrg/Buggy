function Node_{{generic.id}} (InQueues, OutQueues){
  if({{#each node.connectors}}{{#if_eq connector-type "Input"}} InQueues["{{../../generic.id}}:{{name}}"].isEmpty() || {{/if_eq}}{{/each}} false){
    return;
  }
  var InValues = {
{{#each node.connectors}}{{#if_eq connector-type "Input"}}\
    "{{name}}" : InQueues["{{../../generic.id}}:{{name}}"].dequeue(),
{{/if_eq}}{{/each}}\
  }
  {{generic.name}}(InValues, function(returnVals){
    for(var key in returnVals){
      OutQueues["{{generic.id}}:" + key].enqueue(returnVals[key]);
    }
  });
}


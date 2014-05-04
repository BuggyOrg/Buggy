function Group_{{generic.id}} (InQueues, OutQueues){
  qInput = {
{{#each connectors}}{{#if_eq connector-type "Input"}}\
    "{{generic}}:{{name}}" : Queue(),
{{/if_eq}}{{/each}}  };
  qOutput = {
{{#each connectors}}{{#if_eq connector-type "Output"}}\
    "{{generic}}:{{name}}" : Queue(),
{{/if_eq}}{{/each}}  };
{{#each connections}}\
  qOutput["{{from.generic}}:{{from.connector}}"].addEnqueueCallback(function(item){ qInput["{{to.generic}}:{{to.connector}}"].enqueue(item);});
{{/each}}
{{#each connectors}}{{#if_eq connector-type "Output"}}\
  qOutput["{{generic}}:{{name}}"].addEnqueueCallback(function(){ qOutput["{{generic}}:{{name}}"].dequeue(); });
{{/if_eq}}{{/each}}
{{#each connectors}}{{#if_eq connector-type "Input"}}\
  qInput["{{generic}}:{{name}}"].addEnqueueCallback(function(){ Node_{{generic}}(qInput,qOutput); });
{{/if_eq}}{{/each}}
  return {input:qInput, output:qOutput};
}


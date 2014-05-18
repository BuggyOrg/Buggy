function Group_{{generic.id}} (InQueues, OutQueues){
  var qInput = {
{{#each connectors}}{{#if_eq connector-type "Input"}}\
{{#if_neq ../../generic.id generic}}\
    "{{generic}}:{{name}}" : Queue(),
{{/if_neq}}\
{{/if_eq}}{{#if_eq connector-type "Output"}}\
{{#if_eq ../../generic.id generic}}\
    "{{generic}}:{{name}}" : Queue(),
{{/if_eq}}\
{{/if_eq}}{{/each}}  };
  var qOutput = {
{{#each connectors}}{{#if_eq connector-type "Output"}}\
{{#if_neq ../../generic.id generic}}\
    "{{generic}}:{{name}}" : Queue(),
{{/if_neq}}\
{{/if_eq}}{{#if_eq connector-type "Input"}}\
{{#if_eq ../../generic.id generic}}\
    "{{generic}}:{{name}}" : Queue(),
{{/if_eq}}\
{{/if_eq}}{{/each}}  };
{{#each connections}}\
  qOutput["{{from.generic}}:{{from.connector}}"].addEnqueueCallback(function(item){ qInput["{{to.generic}}:{{to.connector}}"].enqueue(item);});
{{/each}}
{{#each connectors}}{{#if_eq connector-type "Output"}}\
{{#if_neq ../../generic.id generic}}\
  qOutput["{{generic}}:{{name}}"].addEnqueueCallback(function(){ qOutput["{{generic}}:{{name}}"].dequeue(); });
{{/if_neq}}\
{{/if_eq}}{{#if_eq connector-type "Input"}}\
{{#if_eq ../../generic.id generic}}\
  qOutput["{{generic}}:{{name}}"].addEnqueueCallback(function(){ qOutput["{{generic}}:{{name}}"].dequeue(); });
  InQueues["{{generic}}:{{name}}"].addEnqueueCallback(function(item){
    qOutput["{{generic}}:{{name}}"].enqueue(item);
    InQueues["{{generic}}:{{name}}"].dequeue();
  });
{{/if_eq}}\
{{/if_eq}}{{/each}}
{{#each connectors}}{{#if_eq connector-type "Input"}}\
{{#if_neq ../../generic.id generic}}\
  qInput["{{generic}}:{{name}}"].addEnqueueCallback(function(){ Node_{{generic}}(qInput,qOutput); });
{{/if_neq}}\
{{/if_eq}}{{#if_eq connector-type "Output"}}\
{{#if_eq ../../generic.id generic}}\
  qInput["{{generic}}:{{name}}"].addEnqueueCallback(function(item){
    OutQueues["{{generic}}:{{name}}"].enqueue(item);
    qInput["{{generic}}:{{name}}"].dequeue();
  });
{{/if_eq}}\
{{/if_eq}}{{/each}}
  return {input:qInput, output:qOutput};
}


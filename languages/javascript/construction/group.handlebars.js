function* Group_{{generic.id}} (InQueues, OutQueues){
{{#ifCond node.atomic node.implemented}}\
{{#if node.input}}\
  csp.go(Node_{{generic.id}}, [InQueues,OutQueues]);
{{/if}}
{{else}}
  var dbID = guid();
  var setDatabase = function(item){
    MapUtil.softAssign(item, "meta.database.uuid", dbID);
  }
  var qInput = {
{{#each connectors}}{{#if_eq connector-type "Input"}}\
{{#if_neq ../../generic.id generic}}\
    "{{generic}}:{{name}}" : csp.chan(),
{{/if_neq}}\
{{/if_eq}}{{#if_eq connector-type "Output"}}\
{{#if_eq ../../generic.id generic}}\
    "{{generic}}:{{name}}" : csp.chan(),
{{/if_eq}}\
{{/if_eq}}{{/each}}  };
  var qOutput = {
{{#each connectors}}{{#if_eq connector-type "Output"}}\
{{#if_neq ../../generic.id generic}}\
    "{{generic}}:{{name}}" : csp.chan(),
{{/if_neq}}\
{{/if_eq}}{{#if_eq connector-type "Input"}}\
{{#if_eq ../../generic.id generic}}\
    "{{generic}}:{{name}}" : csp.chan(),
{{/if_eq}}\
{{/if_eq}}{{/each}}  };
{{#each connections}}\
  csp.go(id, [qOutput["{{from.generic}}:{{from.connector}}"], qInput["{{to.generic}}:{{to.connector}}"] ]);
{{/each}}
{{#each connectors}}{{#if_eq connector-type "Input"}}\
{{#if_neq ../../generic.id generic}}\
  csp.go(Node_{{generic}},[qInput, qOutput]);
{{/if_neq}}\
{{/if_eq}}{{#if_eq connector-type "Output"}}\
{{#if_eq ../../generic.id generic}}\
  qInput["{{generic}}:{{name}}"].addEnqueueCallback(function(item){
    OutQueues["{{generic}}:{{name}}"].enqueue(item);
    qInput["{{generic}}:{{name}}"].dequeue();
  });
{{/if_eq}}\
{{/if_eq}}{{/each}}
{{#each node.generics}}\
  csp.go(Group_{{generic.id}}, [qInput,qOutput]);
{{/each}}
{{#if generic.parentGroup}}{{else}}\
  return {input:qInput, output:qOutput};
{{/if}}\
{{/ifCond}}
}

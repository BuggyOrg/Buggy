{{#ifCond node.atomic node.implemented}}
{{else}}
function Group_{{generic.id}} (InQueues, OutQueues){
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
{{#each connectors}}\
{{#if_eq connector-type "Input"}}\
{{#if_eq ../../generic.id generic}}\
  csp.go(id, [InQueues["{{generic}}:{{name}}"], qOutput["{{generic}}:{{name}}"]]);
{{/if_eq}}\
{{/if_eq}}\
{{#if_eq connector-type "Output"}}\
{{#if_eq ../../generic.id generic}}\
  csp.go(id, [qInput["{{generic}}:{{name}}"], OutQueues["{{generic}}:{{name}}"]]);
{{/if_eq}}\
{{/if_eq}}{{/each}}
{{#each node.generics}}\
  Node_{{name}}(qInput, qOutput);
{{/each}}
}
{{/ifCond}}\

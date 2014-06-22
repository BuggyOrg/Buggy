
var {{generic.name}} = function(){
  var storage = {};
  return function*(InQueues, OutQueues, name, meta){
{{#unless node.input}}
  while(true){
{{/unless}}
    var output = {};
{{#each node.connectors}}{{#if_eq connector-type "Output"}}\
    output['{{name}}'] = { meta: {} };
{{/if_eq}}{{/each}}
    var input = {};
{{#each node.connectors}}{{#if_eq connector-type "Input"}}\
    input["{{name}}"] = yield csp.take(InQueues[name + ":{{name}}"]);
{{#if ../../debug}}\
    console.log("logging after taking {{../../../generic.name}}->{{name}} ");
    console.log(input["{{name}}"]);
{{/if}}\
{{/if_eq}}{{/each}}\
    {{node.implementation}}
{{#unless node.explicit-callback}}\
    {{#each node.connectors}}{{#if_eq connector-type "Output"}}\
{{#if ../../debug}}
        console.log("putting after {{../../../generic.name}}->{{name}}");
        console.log(output["{{name}}"]);
{{/if}}
        yield csp.put(OutQueues[name + ":{{name}}"], output["{{name}}"]);
{{#if ../../debug}}
  console.log("put done");
{{/if}}
    {{/if_eq}}{{/each}}\
{{/unless}}
  }
{{#unless node.input}}
}
{{/unless}}
}();

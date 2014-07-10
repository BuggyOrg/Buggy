{{#if implementation.implementation}}
var {{implementation.name}}_{{node.id}} = function(){
  var storage = {};
  return function*(InQueues, OutQueues, name, meta){
{{~#unless implementation.input}}
  while(true){
{{~/unless}}
    var output = {};
{{~#each symbol.connectors}}{{#if_eq type "Output"}}
    output['{{name}}'] = { meta: {} };
{{~/if_eq}}{{#if_eq type "Generator"}}
    output['{{name}}'] = { meta: {} };
{{~/if_eq}}{{/each}}
    var input = {};
{{~#unless implementation.explicit-input}}
{{~#each symbol.connectors}}{{#if_eq type "Input"}}
    input["{{name}}"] = yield csp.take(InQueues[name + ":{{name}}"]);
{{~#if ../../debug}}\
    console.log("logging after taking {{../../../generic.name}}->{{name}} ");
    console.log(input["{{name}}"]);
{{~/if}}
{{~/if_eq}}{{/each}}{{/unless}}
    {{implementation.implementation}}
{{~#unless implementation.explicit-callback}}
    {{#each symbol.connectors}}{{#if_eq type "Output"}}
{{~#if ../../debug}}
        console.log("putting after {{../../../generic.name}}->{{name}}");
        console.log(output["{{name}}"]);
{{~/if}}
    yield csp.put(OutQueues[name + ":{{name}}"], output["{{name}}"]);
{{~#if ../../debug}}
  console.log("put done");
{{~/if}}{{/if_eq}}{{#if_eq type "Generator"}}
{{~#if ../../debug}}
        console.log("putting after {{../../../generic.name}}->{{name}}");
        console.log(output["{{name}}"]);
{{~/if}}
    yield csp.put(OutQueues[name + ":{{name}}"], output["{{name}}"]);
{{~#if ../../debug}}
  console.log("put done");
{{~/if}}
    {{/if_eq}}{{/each}}
{{~/unless}}
  }
{{~#unless implementation.input}}
}
{{~/unless}}
}();
{{~/if}}

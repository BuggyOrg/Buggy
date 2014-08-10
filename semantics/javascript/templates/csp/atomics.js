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
    {{input-data name}};
    {{~#if ../../debug}}
    debug_take_pre(name + ":{{name}}");
    {{~/if}}
{{~/if_eq}}{{/each}}{{~#each symbol.connectors}}{{#if_eq type "Input"}}
    {{~#if ../../debug}}
    debug_take_post(name + ":{{name}}");
    {{~/if}}
{{~/if_eq}}{{/each}}{{/unless}}
    {{implementation.implementation}}
{{~#unless implementation.explicit-callback}}
    {{#each symbol.connectors}}{{#if_eq type "Output"}}
    {{output-data name}}
{{/if_eq}}{{#if_eq type "Generator"}}
    {{output-data name}}
{{~/if_eq}}{{/each}}
{{~/unless}}
  }
{{~#unless implementation.input}}
}
{{~/unless}}
}();
{{~/if}}


var {{generic.name}} = function(){
  var storage = {};
  return function(input, meta, callback){
    var output = {};
{{#each node.connectors}}{{#if_eq connector-type "Output"}}\
    output['{{name}}'] = { meta: {} };
{{/if_eq}}{{/each}}\n
    {{node.implementation}}
{{#unless node.explicit-callback}}    do_callback(callback,output);
{{/unless}}
  }
}();

function Connection_Graph(){
  var qOutput = {
{{~#each connections}}
    "{{from.generic}}__{{from.mangle}}:{{from.connector}}" : csp.chan(),
{{~/each}}
  };
  var qInput = {
{{~#each connections}}
    "{{to.generic}}__{{to.mangle}}:{{to.connector}}" : qOutput["{{from.generic}}__{{from.mangle}}:{{from.connector}}"],
{{~/each}}
  };

{{#each nodes}}
  Node_{{id}}(qInput, qOutput, {{node-meta-to-string meta}});
{{~/each}}
}

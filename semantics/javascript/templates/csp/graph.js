function Connection_Graph(){
  var qOutput = {
{{~#each connections}}
    "{{from.generic}}__{{from.mangle}}:{{from.connector}}" : csp.chan(),
{{~/each}}
  };
  var qInput = {
{{~#each connections}}
    "{{to.generic}}__{{to.mangle}}:{{to.connector}}" : csp.chan(),
{{~/each}}
  };

{{#each connections}}
  csp.go(id, [qOutput["{{from.generic}}__{{from.mangle}}:{{from.connector}}"], qInput["{{to.generic}}__{{to.mangle}}:{{to.connector}}"] ]);
{{~/each}}
{{#each nodes}}
  Node_{{name}}(qInput, qOutput, {{node-meta-to-string meta}});
{{~/each}}
}

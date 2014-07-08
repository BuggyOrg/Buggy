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

{{#each connections}}{{#if_eq type "Inverse"}}
  csp.go(id, [qInput["{{from.generic}}__{{from.mangle}}:{{from.connector}}"], qOutput["{{to.generic}}__{{to.mangle}}:{{to.connector}}"] ]);
{{~else}}
  csp.go(id, [qOutput["{{from.generic}}__{{from.mangle}}:{{from.connector}}"], qInput["{{to.generic}}__{{to.mangle}}:{{to.connector}}"] ]);
{{~/if_eq}}{{~/each}}
{{#each nodes}}
  Node_{{id}}(qInput, qOutput, {{node-meta-to-string meta}});
{{~/each}}
}

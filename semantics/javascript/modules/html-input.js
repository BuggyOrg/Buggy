addInput("{{node.id}}",function(val){
  {{output 'Value'}} = val;
  csp.go(function*(){ {{output-data 'Value'}} });
});

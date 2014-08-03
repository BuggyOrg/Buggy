{{input-data 'Array'}}
for(var i=0; i<{{input 'Array'}}.length; i++){
  {{output 'ArrayStreamOut'}} = {{input 'Array'}}[i];
  if(i == {{input 'Array'}}.length -1){
    {{set-meta 'ArrayStreamOut' 'last' true}};
  }
  {{set-meta 'ArrayStreamOut' 'StreamComponent' 'i'}};
  {{output-data 'ArrayStreamOut'}};
  {{input-data 'ResultStreamIn'}};
  {{output 'Result'}}[i] = {{input 'ResultStreamIn'}};
}
{{output-data 'Result'}}

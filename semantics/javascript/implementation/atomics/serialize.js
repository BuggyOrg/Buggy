for(var i=0; i<{{input 'Array'}}.length; i++){
  {{output 'Stream'}} = {{input 'Array'}}[i];
  if(i == {{input 'Array'}}.length -1){
    {{set-meta 'Stream' 'last' true}};
  }
  {{set-meta 'Stream' 'StreamComponent' 'i'}};
  {{output-data 'Stream'}};
}

if(!{{has-meta 'Stream' 'last'}} || {{meta-query 'Stream' 'last'}} == false){
  {{output 'OutStream'}} = {{input 'Stream'}};
  {{merge-meta 'OutStream' 'Stream'}};
  {{output-data 'OutStream'}};
}

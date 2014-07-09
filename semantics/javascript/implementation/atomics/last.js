if(({{has-meta 'Stream' 'last'}}) && {{meta-query 'Stream' 'last'}} == true){
  {{output 'Last'}} = {{input 'Stream'}};
  {{merge-meta 'Last' 'Stream'}};
  {{output-data 'Last'}};
}

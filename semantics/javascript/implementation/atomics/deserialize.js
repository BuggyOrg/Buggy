if(!('Value' in storage)){
  storage.Value = [];
}
storage.Value.push({{input 'Stream'}});
if({{has-meta 'Stream' 'last'}} && {{meta-query 'Stream' 'last'}} == true){
  {{output 'Array'}} = storage.Value;
  {{output-data 'Array'}};
  delete storage.Value;
}

if(!("initial" in storage)){
  {{input-data 'Initial'}}
  {{output 'OutStream'}} = {{input 'Initial'}};
  {{merge-meta 'OutStream' 'Initial'}};
  storage.initial = true;
  {{output-data 'OutStream'}};
}
else {
  {{input-data 'Stream'}}
  if(({{has-meta 'Stream' 'last'}}) && {{meta-query 'Stream' 'last'}} == true){
    delete storage.initial
    continue;
  }
  {{output 'OutStream'}} = {{input 'Stream'}};
  {{merge-meta 'OutStream' 'Stream'}};
  {{output-data 'OutStream'}};
}

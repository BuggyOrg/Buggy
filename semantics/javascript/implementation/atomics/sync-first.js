if({{has-meta 'SyncStream' 'StreamComponent'}} && {{meta-query 'SyncStream' 'StreamComponent'}} == 0){
  {{merge-meta 'Sync' 'SyncValue'}};
  {{output 'Sync'}} = {{input 'SyncValue'}};
  {{output-data 'Sync'}};
}

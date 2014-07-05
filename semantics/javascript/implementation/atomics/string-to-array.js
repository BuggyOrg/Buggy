if({{input 'String'}}.length == 0){
  {{output 'Array'}} = []
} else {
  {{output 'Array'}} = String({{input 'String'}}).split(',');
}

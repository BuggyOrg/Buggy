{{requires}}

function* id(input, out){
  while(true)
  {
    yield csp.put(out, yield csp.take(input));
  }
}


global <<< require \prelude-ls
require! chai
chai.should!
chai.use require \chai-things

Graph = requirejs \ls!src/graph
Group = requirejs \ls!src/group

describe "Graph Features" !->
  

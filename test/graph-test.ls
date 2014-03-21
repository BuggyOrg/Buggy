
global <<< require \prelude-ls
require! chai
chai.should!
chai.use require \chai-things

Graph = requirejs \ls!src/graph
Group = requirejs \ls!src/group

describe "Graph Features" !->
  describe "Create From Group" (...) !->
    it "should list all nodes" !->
      grp = Group.create!
      Group.add-generic grp, "A"
      Group.add-generic grp, "B"

      graph = Graph.from-group grp

      graph.nodes.should.include.something.that.equals "A"
      graph.nodes.should.include.something.that.equals "B"
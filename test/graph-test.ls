
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

      graph.nodes.should.contain.an.item.with.property "name", "A"
      graph.nodes.should.contain.an.item.with.property "name", "B"
      graph.nodes.should.contain.an.item.with.property "id", "A"
      graph.nodes.should.contain.an.item.with.property "id", "B"
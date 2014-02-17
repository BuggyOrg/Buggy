
require! chai
chai.should!

Group = requirejs \ls!src/group

describe "Buggy Group", ->
  describe "Creating a new group", (...) ->
    it "should create a valid empty group", ->
      grp = Group.create-group!
      grp.should.be.ok

      grp.should.have.property "name"
      grp.should.have.property "generics"

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

    it "shouldn't overwrite existing entries", (...) ->
      grp = Group.create-group name: "new Group"
      grp.name.should.equal "new Group"
      # but necessary items should be in the group!
      grp.should.have.property "generics"
      grp.generics.should.eql []

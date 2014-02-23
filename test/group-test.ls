
global <<< require \prelude-ls
require! chai
chai.should!

Group = requirejs \ls!src/group
Generic = requirejs \ls!src/generic

describe "Buggy Group", ->
  describe "Creating a new group", (...) ->
    it "should create a valid empty group", ->
      grp = Group.create!
      grp.should.be.ok

      grp.should.have.property "name"
      grp.should.have.property "generics"
      grp.should.have.property "meta"
      grp.meta.type.should.equal "group"

    it "shouldn't overwrite existing entries", (...) ->
      grp = Group.create name: "new Group"
      grp.name.should.equal "new Group"
      # but necessary items should be in the group!
      grp.should.have.property "generics"
      grp.generics.should.eql []
      grp.should.have.property "meta"
      grp.meta.type.should.equal "group"

  describe "Group generics", (...) ->
    it "should be able to add new generics", ->
      grp1 = Group.create!
      grp2 = Group.create name: "GRP2"

      grp2Generic = Generic.create grp2
      Group.add-generic grp1, grp2Generic
      generics = Group.get-generics-by-name grp1, "GRP2"
      generics.length.should.equal 1


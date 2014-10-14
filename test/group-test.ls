
global <<< require \prelude-ls
require! chai
should = chai.should!

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
      
  describe "Group symbol", (...) !->
    it "should be able to set an arbitrary symbol", ->
      grp = Group.create!
      Group.set-symbol grp, "SYMBOL"
      
      (Group.symbol grp).should.equal "SYMBOL"

  describe "Group generics", (...) !->
    it "should be able to add new generics", ->
      grp1 = Group.create!
      grp2 = Group.create name: "GRP2"

      grp2Generic = Generic.create grp2
      Group.add-generic grp1, grp2Generic
      generics = Group.get-generics-by-name grp1, "GRP2"
      generics.length.should.equal 1

    it "shouldn't affect other instances", !->
      grp1 = Group.create!

      grp1.generics.length.should.equal 0
      
    it "should remove existing groups", !->
      grp1 = Group.create!
      grp2 = Group.create name: "GRP2"
      
      grp2Generic = Generic.create grp2
      id2 = Group.add-generic grp1, grp2Generic
      Group.remove-generic grp1, id2
      
      gen2 = Group.get-generic grp1, id2
      should.not.exist gen2
    
    it "should throw an error if an id is given twice", !->
      grp1 = Group.create!
      grp2 = Group.create name: "GRP2"
      
      grp2Generic = Generic.create grp2
      id2 = Group.add-generic grp1, grp2Generic
      (-> Group.add-generic grp1, grp2Generic, id2).should.throw Error
    
  describe "Group connections", (...) !->
    it "should be able to create a connection between two generics", ->
      grp1 = Group.create!
      g1 = Group.create "G1"
      g2 = Group.create "G2"
      
      gen1 = Generic.create g1
      gen2 = Generic.create g2
      id1 = Group.add-generic grp1, gen1
      id2 = Group.add-generic grp1, gen2
      
      Group.add-connection grp1,
        {
          id: id1
          connector: "A"
        },
        {
          id: id2
          connector: "B"
        }
      (Group.connections grp1).length.should.equal 1

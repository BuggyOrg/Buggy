
global <<< require \prelude-ls
require! chai
chai.should!

Buggy = requirejs "ls!src/buggy"
Group = requirejs \ls!src/group


describe "Buggy Main", !->
  sample-group = Group.create name: "sampleGroup"

  describe "create", (...) !->
    it "should create a new scene with no groups", !->
      scene = Buggy.create!
      scene.symbols.should.deep.equal {}

  describe "add-group", (...) !->
    it "should add a group to the symbols table", !->
      scene = Buggy.create!
      Buggy.add-group scene, sample-group

      scene.symbols.should.have.property "sampleGroup"

    it "shouldn't overwrite existing groups", !->
      scene = Buggy.create!
      Buggy.add-group scene, sample-group

      scnd-group = Group.create name: "sampleGroup"
      Buggy.add-group scene, scnd-group

      scene.symbols.should.have.property "sampleGroup"
      scene.symbols["sampleGroup"].length.should.equal 2
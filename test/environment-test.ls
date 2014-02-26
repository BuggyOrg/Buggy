
require! chai
chai.should!

Environment = requirejs "ls!src/environment"
Group = requirejs "ls!src/group"

describe "Buggy Environment", !->
  describe "Creating an empty environment", (...) !->
    it "should create a valid instance", (...) !->
      env = Environment.create!
      env.should.be.ok
      # environment should contain 
      env.should.have.property "entry"
      env.should.have.property "dependencies"

  describe "Loading an exising environment", (...) !->
    it "should create an valid environment from an empty environment", (...) !->
      json-env = {}
      env = Environment.load json-env
      env.should.be.ok
      # environment should contain 
      env.should.have.property "entry"
      env.should.have.property "dependencies"

    it "should not overwrite existing groups", !->
      json-env = {entry: ["A"]}
      env = Environment.load json-env
      env.should.be.ok
      env.should.have.property "entry"
      env.entry.length.should.equal 1
      env.entry.0.should.equal "A"

    it "should not overwrite existing dependencies", !->
      json-env = {dependencies: ["A","B"]}
      env = Environment.load json-env
      env.should.be.ok
      env.should.have.property "dependencies"
      ("A" in env.dependencies).should.equal true
      ("B" in env.dependencies).should.equal true

    it "should fail on wrong formatted entry", !->
      json-env = {entry: {"A"} }
      (-> Environment.load json-env).should.throw Error

    it "should fail on wrong formatted dependencies", !->
      json-env = {dependencies: "A"}
      (-> Environment.load json-env).should.throw Error

  describe "Adding generics", (...) ->
    it "should be able to add new group", !->
      env = Environment.create!
      new-group = Group.create name: "GROUP"
      Environment.add-group env, new-group
      env.entry.length.should.equal 1
      env.entry.0.should.eql new-group

    it "shouldn't affect other created instances", !->
      group-name = "GROUPNAME"

      env1 = Environment.create!
      grp = Group.create name: group-name
      Environment.add-group env1, grp

      env2 = Environment.create!
      env2.entry.length.should.equal 0




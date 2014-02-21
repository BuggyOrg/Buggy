
require! chai
chai.should!

Environment = requirejs "ls!src/environment"

describe "Buggy Environment", !->
  describe "Creating an empty environment", (...) !->
    it "should create a valid instance", (...) !->
      env = Environment.create!
      env.should.be.ok
      # environment should contain 
      env.should.have.property "groups"
      env.should.have.property "dependencies"

  describe "Loading an exising environment", (...) !->
    it "should create an valid environment from an empty environment", (...) !->
      json-env = {}
      env = Environment.load json-env
      env.should.be.ok
      # environment should contain 
      env.should.have.property "groups"
      env.should.have.property "dependencies"

    it "should not overwrite existing groups", !->
      json-env = {groups: {"A":"B"}}
      env = Environment.load json-env
      env.should.be.ok
      env.should.have.property "groups"
      env.groups.A.should.equal "B"

    it "should not overwrite existing dependencies", !->
      json-env = {dependencies: ["A","B"]}
      env = Environment.load json-env
      env.should.be.ok
      env.should.have.property "dependencies"
      ("A" in env.dependencies).should.equal true
      ("B" in env.dependencies).should.equal true

    it "should fail on wrong formatted groups", !->
      json-env = {groups: ["A"]}
      # it should probably not throw simple strings ;)
      (-> Environment.load json-env).should.throw Error

    it "should fail on wrong formatted dependencies", !->
      json-env = {dependencies: "A"}
      # it should probably not throw simple strings ;)
      (-> Environment.load json-env).should.throw Error





require! chai
chai.should!

Buggy = requirejs "ls!src/buggy"

describe "Buggy Environment", ->
  describe "Creating an empty environment", (...) ->
    it "should create a valid instance", (...)->
      env = Buggy.create-environment!
      env.should.be.ok

global <<< require \prelude-ls
require! chai
chai.should!

Resolve = requirejs \ls!src/resolve
Environment = requirejs \ls!src/environment
Group = requirejs \ls!src/group

describe "Buggy Groups / Symbol Resolve", (...) !->
  describe "Resolving programs", (...) !->
    it "should contain every environment group", !->
      env = Environment.create!
      grp = Group.create name: "GRP"
      Environment.add-group env, grp

      # language definition is necessary, but not implemented yet ;)
      res = Resolve.resolve env, null
      res.should.contain "GRP"
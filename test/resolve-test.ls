
global <<< require \prelude-ls
require! chai
chai.should!

Resolve = requirejs \ls!src/resolve
Environment = requirejs \ls!src/environment
Group = requirejs \ls!src/group
Ld = requirejs \ls!src/language-definition

describe "Buggy Groups / Symbol Resolve", (...) !->
  ld = Ld.create (query) ->
    switch query
    | "## LanguageName" => "TESTLANG"
    | "GRP" => [{ "atomic" : true }]
    | otherwise => throw new Error "not existing symbol '#query' queried"

  describe "Resolving programs", (...) !->
    it "should contain the groups of the environment", !->
      env = Environment.create!
      grp = Group.create name: "GRP"
      Environment.add-group env, grp

      # language definition is necessary, but not implemented yet ;)
      Resolve.resolve env, ld, (res) ->
        res.should.have.property "GRP"
        res.GRP.should.eql [{"atomic" : true}]

    it "should fail?! if a symbol cannot be resolved", !->
      env = Environment.create!
      grp = Group.create name: "NOT_RESOLVABLE"
      Environment.add-group env, grp

      (-> Resolve.resolve env, ld).should.throw Error
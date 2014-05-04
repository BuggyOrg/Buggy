
global <<< require \prelude-ls
require! chai
chai.should!

Resolve = requirejs \ls!src/resolve
Group = requirejs \ls!src/group
Generic = requirejs \ls!src/generic
Ld = requirejs \ls!src/language-definition
/* works different now...
describe "Buggy Groups / Symbol Resolve", (...) !->
  ld = Ld.create (query) ->
    switch query
    | "## LanguageName" => "TESTLANG"
    | "GRP" => [{ "atomic" : true }]
    | otherwise => {}

  describe "Resolving programs", (...) !->
    it "should contain the groups of the environment", !->
      grp = Group.create name: "GRP"

      Resolve.resolve ld, (res) !->
        res.should.have.property "GRP"
        res.GRP.should.include.something.that.has.property "atomic"

    it "should fail?! if a symbol cannot be resolved", !->
      env = Environment.create!
      grp = Group.create name: "NOT_RESOLVABLE"
      Environment.add-group env, grp

      (-> Resolve.resolve env, ld).should.throw Error

    it "should contain given groups in the environment", !->
      # this group is created in the environment and though must have a implementation!
      grp = Group.create name: "GRP1"
      gnr = Generic.create "GRP"
      Group.add-generic grp, gnr

      Resolve.resolve ld, (res) ->
        res.should.have.property "GRP"

    it "should fail if a group cannot be resolve", !->
      grp = Group.create name: "GRP2"
      gnr = Generic.create "SUBGRP"
      Group.add-generic grp, gnr

      (-> Resolve.resolve ld !-> ).should.throw Error*/

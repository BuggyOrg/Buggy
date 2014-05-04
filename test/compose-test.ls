
global <<< require \prelude-ls
require! chai
chai.should!

Compose = requirejs "ls!src/compose"
Group = requirejs \ls!src/group
Generic = requirejs \ls!src/generic
Ld = requirejs \ls!src/language-definition

describe "Compose", !->
  empty-ld = query: (q) -> {}

  min-ld = Ld.create (query) ->
    switch query
    | "## LanguageName" => "TESTLANG"
    | "--> atomic" => "{{node.implementation}}"
    | "--> node" => ""
    | "--> group" => ""
    | "min-gen" => [{ "atomic" : true, "implementation" : "min-impl" }]
    | otherwise => null 

  describe "Composing a Scene", (...) !->
    it "should fail if the program contains no 'main' Method", !->
      (-> Compose.compose empty-ld).should.throw Error

    it "should generate a source string for a valid scene", !->
      main = Group.create name: "main"
      min-generic = Generic.create "min-gen"
      Group.add-generic main, min-generic
      module = Ld.load-module-from-json symbols: { "main" : main }
      min-ld.add-module module

      Compose.compose min-ld, (source) ->
        source.should.include "min-impl"
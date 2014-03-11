
global <<< require \prelude-ls
require! chai
chai.should!

ld = requirejs \ls!src/language-definition

describe "Buggy Language Definition", !->
  spec = require \./fixtures/simple_language_spec.json
  describe "Loading a json-language specification", (...) !->
    it "should create a working query function", !->
      lang-spec = ld.load-query-from-json spec
      # query meta information
      (lang-spec "## LanguageName").should.equal spec.meta.LanguageName
      # query symbols
      (lang-spec "Add").should.eql spec.symbols.Add

  module = require \./fixtures/simple_module_spec.json

  describe "Loading a module ontop of an environment", (...) !->
    it "should have both environments queryable", !->
      lang-spec = ld.load-from-json spec
      module-spec = ld.load-module-from-json module
      lang-spec.add-module module-spec

      (lang-spec.query "Add").should.eql spec.symbols.Add
      (lang-spec.query "input").should.eql module.symbols.input
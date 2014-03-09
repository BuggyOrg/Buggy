
global <<< require \prelude-ls
require! chai
chai.should!

ld = requirejs \ls!src/language-definition

describe "Buggy Language Definition", !->
  describe "Loading a json-language specification", (...) !->
    it "should create a working query function", !->
      spec = require \./fixtures/simple_language_spec.json
      lang-spec = ld.load-query-from-json spec
      # query meta information
      (lang-spec "## LanguageName").should.equal spec.meta.LanguageName
      # query symbols
      (lang-spec "Add").should.eql spec.symbols.Add


global <<< require \prelude-ls
require! chai
should = chai.should!

Symbol = requirejs \ls!src/symbol

describe "Buggy Symbol", ->
  describe "Creating a new symbol", (...) ->
    it "should create a symbol from a string", ->
      sym = Symbol.create "ABC"
      
      (Symbol.name sym).should.equal "ABC"

    it "should create a symbol from an object", ->
      sym = Symbol.create name: "CDE"
      
      (Symbol.name sym).should.equal "CDE"
      
  describe "Symbol Connectors", (...) !->
    it "should be able to add Inputs", !->
      sym = Symbol.create "SYM"
      Symbol.add-input sym, "A"

      inputs = Symbol.inputs sym
      inputs.length.should.equal 1
      inputs[0].name.should.equal "A"

    it "should be able to add Outputs", !->
      sym = Symbol.create  "SYM"
      Symbol.add-output sym, "B"

      outputs = Symbol.outputs sym
      outputs.length.should.equal 1
      outputs[0].name.should.equal "B"
    
    it "should be able to get an input by name", !->
      sym = Symbol.create "SYM"
      Symbol.add-input sym, "C"

      connector = Symbol.get-input sym, "C"
      connector.name.should.equal "C"
      connector.type.should.equal "Input"
      
    it "should be able to get an output by name", !->
      sym = Symbol.create "SYM"
      Symbol.add-output sym, "D"

      connector = Symbol.get-output sym, "D"
      connector.name.should.equal "D"
      connector.type.should.equal "Output"
      
    it "should be able to remove an input", !->
      sym = Symbol.create "SYM"
      Symbol.add-input sym, "S"
      Symbol.remove-input sym, "S"
      
      inputs = Symbol.inputs sym
      inputs.length.should.equal 0
      
    it "should be able to remove an output", !->
      sym = Symbol.create "SYM"
      Symbol.add-output sym, "S"
      Symbol.remove-output sym, "S"
      
      output = Symbol.outputs sym
      output.length.should.equal 0

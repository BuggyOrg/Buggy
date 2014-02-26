
global <<< require \prelude-ls
require! chai
chai.should!
chai.use require \chai-things

Connection = requirejs "ls!src/connection"
Group = requirejs "ls!src/group"

describe "Buggy Connections", !->
  describe "Processing a group", (...) !->
    it "should list all connections", !->
      grp = Group.create {
        generics: [
          { name:"A" }
          {
            name:"B",
            # the > indicates that the input is another generic
            # it is not necessary to resolve A (to know that A has an outgoing connector OUT)
            # at Connection creation. !!??
            inputs: { "INPUT": ">A:OUT" }
          }
        ]
      }

      cn = Connection.gather-connections grp
      cn.length.should.equal 1
      cn.should.include.something.that.deep.equals {
        input: {
          generic: "B"
          connector: "INPUT"
        }
        output: {
          generic: "A"
          connector: "OUT"
        }
      }

    it "should handle multiple inputs", !->
      grp = Group.create {
        generics: [
          { name:"A" }
          { name:"B" }
          {
            name:"C",
            inputs: { "INPUT1": ">A:OUT1", "INPUT2": ">B:OUT1" }
          }
        ]
      }

      cn = Connection.gather-connections grp
      cn.length.should.equal 2
      cn.should.include.something.that.deep.equals { 
        input: { generic: "C", connector: "INPUT1"}
        output: { generic: "A", connector: "OUT1"}
      }
      cn.should.include.something.that.deep.equals {
        input: { generic: "C", connector: "INPUT2"}
        output: { generic: "B", connector: "OUT1"}
      }

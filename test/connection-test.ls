
global <<< require \prelude-ls
require! chai
chai.should!
chai.use require \chai-things

Connection = requirejs "ls!src/connection"
Group = requirejs "ls!src/group"

describe "Buggy Connections", !->

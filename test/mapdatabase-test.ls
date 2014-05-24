
global <<< require \prelude-ls
require! chai
chai.should!

Mapdatabase = requirejs "ls!src/database/mapdatabase"

# TODO: there should be separate tests for Mapdatabase and the database itself
describe "Mapdatabase", !->

  describe "Creating a Mapdatabase", (...) !->
    it "should create an object", !->
      (typeof! Mapdatabase.create!).should.equal "Object"

  describe "Manipulating a Mapdatabase", (...) !->
    new-db = Mapdatabase.create!
    it "should add the element given", (...) !->
      Mapdatabase.add new-db, "props", 1
      new-db.should.have.property "props"

    it "should complain if a value gets assigned twice", (...) !->
      (!-> Mapdatabase.add new-db, "props", 2).should.throw Error


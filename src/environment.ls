/*
  This file is part of Buggy.

  Buggy is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  Buggy is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with Buggy.  If not, see <http://www.gnu.org/licenses/>.
*/

pkg = require "json!src/../package.json"

define ["ls!src/group"], (Group) ->
  minimal-environment = {
    # groups are an essential part of buggy as they describe the 
    # program flow, the environment can only contain groups, no generics!
    groups: {}
    # a set (list) of dependencies
    dependencies: []
    # some meta information
    meta: {
      description: "Buggy Environment Description"
      version: pkg.version
    }
  }

  sanity-check = (env) ->
    if typeof! env.groups != "Object"
      throw new Error "Groups must be an Object"
    else if typeof! env.dependencies != "Array"
      throw new Error "Dependencies must be an Array"

  # always do an sanity check on the minimal environment
  # otherwise it would be stupid to continue
  sanity-check minimal-environment

  {
    # Environments are a kind of program descriptors
    # they contain the important parts of the program
    create: (...) ->
      new-environment = {}
      new-environment <<< minimal-environment
    
    load: (env) ->
      new-environment = {}
      new-environment <<< minimal-environment
      new-environment <<< env
      sanity-check new-environment
      return new-environment

    add-group: (env, group) ->
      id = Group.identifier group
      if id of env.groups
        throw "Group #id already contained in environment"
      else
        env.groups[id] <<< group
  }

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

define ["ls!src/group","ls!src/util/clone"], (Group, Clone) ->
  minimal-environment = {
    entry: []
    dependencies: []
    meta: {
      description: "Buggy Environment Description"
      version: pkg.version
    }
  }

  sanity-check = (env) ->
    if typeof! env.entry != "Array"
      throw new Error "The Environment Entry must be a valid Array"
    if typeof! env.dependencies != "Array"
      throw new Error "Dependencies for the environment must be an array"

  {
    # Environments are a kind of program descriptors
    # they contain the important parts of the program
    create: (...) ->
      new-environment = Clone minimal-environment
    
    load: (env) ->
      new-environment = this.create!
      new-environment <<< Clone env
      sanity-check new-environment
      return new-environment

    add-group: (env, group) ->
      env.entry.push group
  }

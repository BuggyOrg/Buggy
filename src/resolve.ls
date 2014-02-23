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

# resolve tries to create an datastructure that contains all groups 
# resolved (contain all necessary information to compile)
# meaning that it resolves every group up to its atomics and creates necessary
# type-transformations. 
# This process requires a language definition (ld) that provides language specific stuff.
#
# Additionally it should be possible to choose between different implementation types for
# semantic groups (groups that describe a certain meaning, but are not specific on their
# exact implementation). One should be able to provide those information beforehand or
# the resolve-process be able to request a choice for every such situation (which is most certainly
# necessary due to changes done by others to the implementation of such semantic groups)
define ["ls!src/environment", "ls!src/language-definition", "ls!src/group"], (Env, Ld, Group) ->

  resolve-group = (query, enqueue, group-id) -->
    enqueue ["#group-id", query group-id]

  enqueue-into-array = (arr, loaded, what) -->
    arr.push what
    loaded what.0

  {
    resolve: (program, ld, done) ->
      resolved = []
      enqueue = enqueue-into-array resolved, (gid) -> # do something... call callback or so
      res = resolve-group ld.query, enqueue

      keys program.groups |> map res

      done (resolved |> pairs-to-obj)
      

    # resolves everything necessary for a given output.. creates a dependency tree
    # and only resolves necessary elements with optional lazy "resolvation"
    # if a path might not be necessary for the calculation
    resolve-output: (output, program, ld, done, lazy = false) ->
      # do other stuff
  }
  

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


# a group should be a semantic 'unit' that describes a process on a appropiate
# abstraction level (sound a bit vague, but for low abstraction layers the group
# can adress technical problems, wheres on a high level the group shouldn't adress
# low level / technical issues as those aren't vital for the semantics)
#
# Groups shouldn't define exactly how everything works in detail, but should referenc to
# other groups that solve problems on a lower abstraction level.
define (...) ->
  empty-group = {
    name: "Unnamed Group"
    # generics are a concept that be an object that
    # is further specified by its name / type / meta
    # e.g. this could be a group, an atomic, a note or similar
    generics: []
    meta: {
      type: "group"
      description: "Buggy Group"
    }
  }

  {
    # creates a new group using the group details
    # all necessary fields are defined in the empty-group
    # so create-group can be run without an argument
    create: (group-details) ->
      new-group = {}
      new-group <<< empty-group
      new-group <<< group-details

    # gets the identifier for the group
    identifier: (group) ->
      # currently the group is identified by its name, but that
      # should change somewhen to a unique identifier
      group.name

    add-generic: (group, generic) ->
      # make a copy of it to ensure that no side effects can change
      # the value of the generic
      new-generic = {}
      new-generic <<< generic
      group.generics.push new-generic

    get-generics-by-name: (group, name) ->
      group.generics |> filter (g) -> g.name == name
  }
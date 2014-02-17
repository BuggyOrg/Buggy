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

define (...) ->
  empty-group = {
    name: "Unnamed Group"
    # generics are a concept that be an object that
    # is further specified by its name / type / meta
    # e.g. this could be a group, an atomic, a note or similar
    generics: []
    meta: {
      description: "Buggy Group"
    }
  }

  {
    # creates a new group using the group details
    # all necessary fields are defined in the empty-group
    # so create-group can be run without an argument
    create-group: (group-details) ->
      new-group <<< empty-group
      new-group <<< group-details

    # gets the identifier for the group
    identifier: (group) ->
      # currently the group is identified by its name, but that
      # should change somewhen
      group.name

  }
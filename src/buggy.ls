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

default-config = {
  symbols: {
  }
  meta: {
      "description": "Buggy Environment Description",
      "version": "0.5.0"
  }
}

define [ "ls!src/group",
         "ls!src/util/clone",
         "ls!src/semantics",
         "ls!src/resolve",
         "ls!src/compose"], (Group, Clone) ->

  {
    create: (config) ->
      new-buggy = Clone default-config
      new-buggy <<< Clone config

    add-generic: (buggy, name) ->
      id = Group.identifier group
      if id of buggy.symbols
        buggy.symbols[id].push Clone group
      else
        buggy.symbols[id] = [ Clone group ]

  }
